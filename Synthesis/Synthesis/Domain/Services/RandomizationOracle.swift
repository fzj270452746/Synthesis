//
//  RandomizationOracle.swift
//  Synthesis - Domain Service
//
//  Centralized randomization service providing deterministic and stochastic
//  number generation with optional seeding for reproducibility.
//

import Foundation

class RandomizationOracle {

    // MARK: - Singleton

    static let sovereignInstance = RandomizationOracle()

    // MARK: - Properties

    private var customSeedValue: UInt64?
    private var sequenceGenerator: RandomNumberGenerator

    // MARK: - Initialization

    init(seed: UInt64? = nil) {
        self.customSeedValue = seed
        if let seedValue = seed {
            self.sequenceGenerator = SeededRandomGenerator(seed: seedValue)
        } else {
            self.sequenceGenerator = SystemRandomNumberGenerator()
        }
    }

    // MARK: - Integer Generation

    /// Generates random integer within inclusive range
    func generateIntegerValue(minimum: Int, maximum: Int) -> Int {
        guard minimum <= maximum else { return minimum }
        let range = minimum...maximum
        return Int.random(in: range, using: &sequenceGenerator)
    }

    /// Generates random integer below exclusive upper bound
    func generateIntegerValue(below upperBound: Int) -> Int {
        guard upperBound > 0 else { return 0 }
        return Int.random(in: 0..<upperBound, using: &sequenceGenerator)
    }

    // MARK: - Fractional Generation

    /// Generates random double within inclusive range
    func generateFractionalValue(minimum: Double, maximum: Double) -> Double {
        guard minimum <= maximum else { return minimum }
        let range = minimum...maximum
        return Double.random(in: range, using: &sequenceGenerator)
    }

    /// Generates random fractional value between 0.0 and 1.0
    func generateNormalizedFraction() -> Double {
        return Double.random(in: 0.0...1.0, using: &sequenceGenerator)
    }

    // MARK: - Boolean Generation

    /// Generates random boolean with optional probability bias
    func generateBooleanValue(probabilityOfTrue: Double = 0.5) -> Bool {
        let clampedProbability = max(0.0, min(1.0, probabilityOfTrue))
        return generateNormalizedFraction() < clampedProbability
    }

    // MARK: - Collection Utilities

    /// Selects random element from collection
    func selectRandomElement<T>(from collection: [T]) -> T? {
        guard !collection.isEmpty else { return nil }
        return collection.randomElement(using: &sequenceGenerator)
    }

    /// Shuffles collection using current generator
    func shuffleCollection<T>(_ collection: inout [T]) {
        collection.shuffle(using: &sequenceGenerator)
    }

    /// Creates shuffled copy of collection
    func createShuffledCollection<T>(_ collection: [T]) -> [T] {
        var mutableCopy = collection
        shuffleCollection(&mutableCopy)
        return mutableCopy
    }

    // MARK: - Weighted Selection

    /// Selects element based on weighted probabilities
    func selectWeightedElement<T>(
        from elements: [T],
        weights: [Double]
    ) -> T? {
        guard elements.count == weights.count,
              !elements.isEmpty else {
            return nil
        }

        let totalWeight = weights.reduce(0.0, +)
        guard totalWeight > 0 else { return nil }

        let randomValue = generateFractionalValue(minimum: 0.0, maximum: totalWeight)
        var cumulativeWeight = 0.0

        for (index, weight) in weights.enumerated() {
            cumulativeWeight += weight
            if randomValue <= cumulativeWeight {
                return elements[index]
            }
        }

        return elements.last
    }

    // MARK: - Seed Management

    /// Reconfigures oracle with new seed for deterministic generation
    func reconfigureWithSeed(_ seed: UInt64) {
        self.customSeedValue = seed
        self.sequenceGenerator = SeededRandomGenerator(seed: seed)
    }

    /// Resets to system random generation
    func resetToSystemGeneration() {
        self.customSeedValue = nil
        self.sequenceGenerator = SystemRandomNumberGenerator()
    }

    var currentSeedValue: UInt64? {
        return customSeedValue
    }
}

// MARK: - Seeded Random Generator

private struct SeededRandomGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next() -> UInt64 {
        // Linear Congruential Generator (LCG)
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}

// MARK: - CustomStringConvertible

extension RandomizationOracle: CustomStringConvertible {
    var description: String {
        if let seed = customSeedValue {
            return "RandomizationOracle(seeded: \(seed))"
        } else {
            return "RandomizationOracle(system)"
        }
    }
}
