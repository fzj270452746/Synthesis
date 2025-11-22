//
//  AccumulatedMerit.swift
//  Synthesis - Domain Value Object
//
//  Represents the quantified achievement score accumulated during gameplay.
//  Combines primary merit with bonus amplifications.
//

import Foundation

struct AccumulatedMerit: Equatable, Comparable, Codable {

    // MARK: - Properties

    /// Primary merit value from tile consolidations
    private(set) var primaryQuantity: Int

    /// Bonus merit from sequential amplifications
    private(set) var bonusQuantity: Int

    /// Total consolidated merit
    var totalQuantity: Int {
        return primaryQuantity + bonusQuantity
    }

    // MARK: - Initialization

    init(primary: Int = 0, bonus: Int = 0) {
        self.primaryQuantity = max(0, primary)
        self.bonusQuantity = max(0, bonus)
    }

    // MARK: - Mutation

    /// Augments merit by specified quantities
    mutating func augmentMerit(primary: Int, bonus: Int = 0) {
        primaryQuantity += max(0, primary)
        bonusQuantity += max(0, bonus)
    }

    /// Amalgamates another merit accumulation
    mutating func amalgamate(_ other: AccumulatedMerit) {
        primaryQuantity += other.primaryQuantity
        bonusQuantity += other.bonusQuantity
    }

    /// Resets merit to initial state
    mutating func obliterate() {
        primaryQuantity = 0
        bonusQuantity = 0
    }

    // MARK: - Comparable

    static func < (lhs: AccumulatedMerit, rhs: AccumulatedMerit) -> Bool {
        return lhs.totalQuantity < rhs.totalQuantity
    }

    static func == (lhs: AccumulatedMerit, rhs: AccumulatedMerit) -> Bool {
        return lhs.totalQuantity == rhs.totalQuantity
    }

    // MARK: - Arithmetic Operators

    static func + (lhs: AccumulatedMerit, rhs: AccumulatedMerit) -> AccumulatedMerit {
        return AccumulatedMerit(
            primary: lhs.primaryQuantity + rhs.primaryQuantity,
            bonus: lhs.bonusQuantity + rhs.bonusQuantity
        )
    }

    static func += (lhs: inout AccumulatedMerit, rhs: AccumulatedMerit) {
        lhs.amalgamate(rhs)
    }
}

// MARK: - CustomStringConvertible

extension AccumulatedMerit: CustomStringConvertible {
    var description: String {
        return "Merit(total: \(totalQuantity), primary: \(primaryQuantity), bonus: \(bonusQuantity))"
    }
}

// MARK: - Formatting

extension AccumulatedMerit {
    /// Formatted string representation for display
    var formattedDesignation: String {
        return String(format: "%d", totalQuantity)
    }

    /// Detailed breakdown for scoring display
    var detailedBreakdown: String {
        if bonusQuantity > 0 {
            return "\(primaryQuantity) + \(bonusQuantity) = \(totalQuantity)"
        } else {
            return "\(totalQuantity)"
        }
    }
}
