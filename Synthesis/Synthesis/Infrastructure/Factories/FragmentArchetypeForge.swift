//
//  FragmentArchetypeForge.swift
//  Synthesis - Infrastructure Factory
//
//  Factory for creating numeric glyph token fragments.
//  Encapsulates token generation logic with difficulty-based probability.
//

import Foundation

class FragmentArchetypeForge {

    // MARK: - Properties

    private let difficultyEchelon: DifficultyEchelon
    private let randomizationOracle: RandomizationOracle

    // MARK: - Initialization

    init(
        echelon: DifficultyEchelon,
        oracle: RandomizationOracle = RandomizationOracle.sovereignInstance
    ) {
        self.difficultyEchelon = echelon
        self.randomizationOracle = oracle
    }

    // MARK: - Fragment Creation

    /// Forges new token with probabilistic magnitude distribution
    func forgeFragment() -> NumericGlyphToken {
        let magnitude = selectMagnitudeViaProbabilityDistribution()
        return NumericGlyphToken(magnitude: magnitude)
    }

    /// Forges token with specific magnitude
    func forgeFragment(withMagnitude magnitude: Int) -> NumericGlyphToken {
        let clampedMagnitude = clamp(
            magnitude,
            minimum: difficultyEchelon.minimumTokenMagnitude,
            maximum: difficultyEchelon.maximumTokenMagnitude
        )
        return NumericGlyphToken(magnitude: clampedMagnitude)
    }

    /// Forges collection of tokens
    func forgeFragmentCollection(quantity: Int) -> [NumericGlyphToken] {
        return (0..<quantity).map { _ in forgeFragment() }
    }

    // MARK: - Probability Selection

    private func selectMagnitudeViaProbabilityDistribution() -> Int {
        let weights = difficultyEchelon.magnitudeProbabilityWeights

        // Calculate total weight
        let totalWeight = weights.values.reduce(0.0, +)

        // Generate random value within total weight
        let randomValue = randomizationOracle.generateFractionalValue(
            minimum: 0.0,
            maximum: totalWeight
        )

        // Select magnitude based on cumulative probability
        var cumulativeWeight = 0.0
        for magnitude in difficultyEchelon.minimumTokenMagnitude...difficultyEchelon.maximumTokenMagnitude {
            cumulativeWeight += weights[magnitude] ?? 0.0
            if randomValue <= cumulativeWeight {
                return magnitude
            }
        }

        // Fallback to minimum magnitude
        return difficultyEchelon.minimumTokenMagnitude
    }

    // MARK: - Utility

    private func clamp(_ value: Int, minimum: Int, maximum: Int) -> Int {
        return min(max(value, minimum), maximum)
    }
}

// MARK: - CustomStringConvertible

extension FragmentArchetypeForge: CustomStringConvertible {
    var description: String {
        return "FragmentForge(echelon: \(difficultyEchelon.designationLabel))"
    }
}
