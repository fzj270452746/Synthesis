//
//  SequentialAmplifier.swift
//  Synthesis - Domain Value Object
//
//  Tracks consecutive successful consolidation chains to amplify scoring.
//  Represents the combo multiplier mechanism.
//

import Foundation

struct SequentialAmplifier: Equatable, Comparable, Codable {

    // MARK: - Properties

    /// Current amplification magnitude
    private(set) var amplitudeMagnitude: Int

    /// Maximum achieved amplitude in session
    private(set) var pinnacleAmplitude: Int

    /// Validates if amplifier is activated
    var isActivated: Bool {
        return amplitudeMagnitude > 1
    }

    // MARK: - Constants

    private static let initialAmplitude = 1
    private static let minimumAmplitude = 1

    // MARK: - Initialization

    init(amplitude: Int = initialAmplitude) {
        self.amplitudeMagnitude = max(Self.minimumAmplitude, amplitude)
        self.pinnacleAmplitude = self.amplitudeMagnitude
    }

    // MARK: - Mutation

    /// Escalates amplifier magnitude for consecutive success
    mutating func escalateAmplitude() {
        amplitudeMagnitude += 1
        pinnacleAmplitude = max(pinnacleAmplitude, amplitudeMagnitude)
    }

    /// Obliterates amplifier back to initial state
    mutating func obliterateAmplitude() {
        amplitudeMagnitude = Self.initialAmplitude
    }

    /// Preserves pinnacle while resetting current amplitude
    mutating func resetToInitialPreservingPinnacle() {
        amplitudeMagnitude = Self.initialAmplitude
    }

    // MARK: - Calculation

    /// Calculates bonus merit contribution from amplification
    func calculateBonusMerit() -> Int {
        guard isActivated else { return 0 }
        return (amplitudeMagnitude - 1) * 50
    }

    /// Computes amplification multiplier factor
    var multiplierFactor: Double {
        return Double(amplitudeMagnitude)
    }

    // MARK: - Comparable

    static func < (lhs: SequentialAmplifier, rhs: SequentialAmplifier) -> Bool {
        return lhs.amplitudeMagnitude < rhs.amplitudeMagnitude
    }

    static func == (lhs: SequentialAmplifier, rhs: SequentialAmplifier) -> Bool {
        return lhs.amplitudeMagnitude == rhs.amplitudeMagnitude
    }
}

// MARK: - CustomStringConvertible

extension SequentialAmplifier: CustomStringConvertible {
    var description: String {
        return "Amplifier(current: \(amplitudeMagnitude)x, pinnacle: \(pinnacleAmplitude)x)"
    }
}

// MARK: - Formatting

extension SequentialAmplifier {
    /// Formatted designation for display
    var formattedDesignation: String {
        return "\(amplitudeMagnitude)x"
    }

    /// Visual indicator for combo state
    var visualIndicator: String {
        if amplitudeMagnitude >= 5 {
            return "🔥"
        } else if amplitudeMagnitude >= 3 {
            return "⚡️"
        } else if isActivated {
            return "✨"
        }
        return ""
    }
}
