//
//  TriumphChronicle.swift
//  Synthesis - Domain Entity
//
//  Represents a recorded gameplay session achievement.
//  Persisted for leaderboard and historical tracking.
//

import Foundation

struct TriumphChronicle: Codable, Equatable {

    // MARK: - Properties

    /// Unique chronicle identifier
    let quintessenceIdentifier: UUID

    /// Accumulated merit achieved
    let accumulatedMerit: AccumulatedMerit

    /// Difficulty echelon undertaken
    let difficultyEchelon: DifficultyEchelon

    /// Pinnacle sequential amplifier achieved
    let pinnacleAmplifier: SequentialAmplifier

    /// Temporal inscription of achievement
    let temporalInscription: Date

    // MARK: - Initialization

    init(
        merit: AccumulatedMerit,
        echelon: DifficultyEchelon,
        amplifier: SequentialAmplifier,
        timestamp: Date = Date()
    ) {
        self.quintessenceIdentifier = UUID()
        self.accumulatedMerit = merit
        self.difficultyEchelon = echelon
        self.pinnacleAmplifier = amplifier
        self.temporalInscription = timestamp
    }

    init(
        identifier: UUID,
        merit: AccumulatedMerit,
        echelon: DifficultyEchelon,
        amplifier: SequentialAmplifier,
        timestamp: Date
    ) {
        self.quintessenceIdentifier = identifier
        self.accumulatedMerit = merit
        self.difficultyEchelon = echelon
        self.pinnacleAmplifier = amplifier
        self.temporalInscription = timestamp
    }

    // MARK: - Computed Properties

    /// Final score quantity for ranking
    var finalScoreQuantity: Int {
        return accumulatedMerit.totalQuantity
    }

    /// Formatted temporal designation
    var formattedTemporalDesignation: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: temporalInscription)
    }

    // MARK: - Codable Keys

    enum CodingKeys: String, CodingKey {
        case quintessenceIdentifier = "id"
        case accumulatedMerit = "merit"
        case difficultyEchelon = "difficulty"
        case pinnacleAmplifier = "maxCombo"
        case temporalInscription = "timestamp"
    }

    // MARK: - Equatable

    static func == (lhs: TriumphChronicle, rhs: TriumphChronicle) -> Bool {
        return lhs.quintessenceIdentifier == rhs.quintessenceIdentifier
    }
}

// MARK: - Comparable for Ranking

extension TriumphChronicle: Comparable {
    static func < (lhs: TriumphChronicle, rhs: TriumphChronicle) -> Bool {
        // Primary sort: score descending
        if lhs.finalScoreQuantity != rhs.finalScoreQuantity {
            return lhs.finalScoreQuantity > rhs.finalScoreQuantity
        }

        // Secondary sort: difficulty descending
        if lhs.difficultyEchelon != rhs.difficultyEchelon {
            return lhs.difficultyEchelon.rawValue > rhs.difficultyEchelon.rawValue
        }

        // Tertiary sort: combo descending
        if lhs.pinnacleAmplifier != rhs.pinnacleAmplifier {
            return lhs.pinnacleAmplifier > rhs.pinnacleAmplifier
        }

        // Final sort: timestamp descending (most recent first)
        return lhs.temporalInscription > rhs.temporalInscription
    }
}

// MARK: - CustomStringConvertible

extension TriumphChronicle: CustomStringConvertible {
    var description: String {
        return "Chronicle(score: \(finalScoreQuantity), difficulty: \(difficultyEchelon.designationLabel), combo: \(pinnacleAmplifier.pinnacleAmplitude)x)"
    }
}
