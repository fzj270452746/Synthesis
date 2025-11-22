//
//  DifficultyEchelon.swift
//  Synthesis - Domain Value Object
//
//  Encapsulates difficulty configuration including grid dimensions,
//  maximum token magnitude, and spawn probability parameters.
//

import Foundation

enum DifficultyEchelon: Int, Codable, CaseIterable {
    case nascent = 3
    case elementary = 4
    case intermediate = 5
    case advanced = 6
    case formidable = 7
    case exceptional = 8
    case transcendent = 9

    // MARK: - Configuration Properties

    /// Lattice dimensional capacity for this echelon
    var latticeDimensionalCapacity: Int {
        switch self {
        case .nascent, .elementary:
            return 3
        case .intermediate, .advanced:
            return 4
        case .formidable, .exceptional, .transcendent:
            return 6
        }
    }

    /// Maximum hierarchical magnitude for token generation
    var maximumTokenMagnitude: Int {
        return rawValue
    }

    /// Minimum hierarchical magnitude for token generation
    var minimumTokenMagnitude: Int {
        return 1
    }

    /// Probability distribution weights for token spawn
    var magnitudeProbabilityWeights: [Int: Double] {
        var weights: [Int: Double] = [:]

        for magnitude in minimumTokenMagnitude...maximumTokenMagnitude {
            // Lower magnitudes have higher spawn probability
            // Exponential decay: P(m) = base^(-m)
            let decayFactor = 0.7
            let weight = pow(decayFactor, Double(magnitude - 1))
            weights[magnitude] = weight
        }

        return weights
    }

    /// Human-readable designation
    var designationLabel: String {
        switch self {
        case .nascent: return "Nascent"
        case .elementary: return "Elementary"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        case .formidable: return "Formidable"
        case .exceptional: return "Exceptional"
        case .transcendent: return "Transcendent"
        }
    }

    /// Descriptive exposition
    var descriptiveExposition: String {
        switch self {
        case .nascent:
            return "Initiation into fundamental mechanics"
        case .elementary:
            return "Gradual complexity escalation"
        case .intermediate:
            return "Balanced challenge equilibrium"
        case .advanced:
            return "Strategic depth amplification"
        case .formidable:
            return "Demanding tactical orchestration"
        case .exceptional:
            return "Elite mastery requirement"
        case .transcendent:
            return "Ultimate proficiency examination"
        }
    }

    // MARK: - Initialization

    init?(fromRawMagnitude magnitude: Int) {
        guard let echelon = DifficultyEchelon(rawValue: magnitude) else {
            return nil
        }
        self = echelon
    }

    // MARK: - Comparison

    func exceedsEchelon(_ other: DifficultyEchelon) -> Bool {
        return rawValue > other.rawValue
    }

    func precedesEchelon(_ other: DifficultyEchelon) -> Bool {
        return rawValue < other.rawValue
    }
}

// MARK: - CustomStringConvertible

extension DifficultyEchelon: CustomStringConvertible {
    var description: String {
        return "\(designationLabel) (Magnitude: \(rawValue), Grid: \(latticeDimensionalCapacity)x\(latticeDimensionalCapacity))"
    }
}
