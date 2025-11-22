//
//  NumericGlyphToken.swift
//  Synthesis - Domain Entity
//
//  Represents an individual tile piece in the tessellated game arena.
//  Each token carries a numeric magnitude and visual representation.
//

import Foundation

struct NumericGlyphToken: Equatable, Hashable {

    // MARK: - Properties

    /// Unique quintessential identifier for token tracking
    let quintessenceIdentifier: UUID

    /// Numeric magnitude representing tile value (1-9)
    let hierarchicalMagnitude: Int

    /// Visual asset designation for rendering
    var emblematicAssetDesignation: String {
        return "Tile\(hierarchicalMagnitude)"
    }

    // MARK: - Initialization

    init(magnitude: Int) {
        self.quintessenceIdentifier = UUID()
        self.hierarchicalMagnitude = magnitude
    }

    init(identifier: UUID, magnitude: Int) {
        self.quintessenceIdentifier = identifier
        self.hierarchicalMagnitude = magnitude
    }

    // MARK: - Value Object Methods

    /// Transmutes token to elevated magnitude
    func transmuteToSuccessorMagnitude() -> NumericGlyphToken {
        let elevatedMagnitude = min(hierarchicalMagnitude + 1, 9)
        return NumericGlyphToken(magnitude: elevatedMagnitude)
    }

    /// Validates if token possesses identical magnitude with another
    func possessesIdenticalMagnitude(with other: NumericGlyphToken) -> Bool {
        return hierarchicalMagnitude == other.hierarchicalMagnitude
    }

    /// Determines if token resides at maximum echelon
    func residesAtMaximumEchelon(within difficulty: Int) -> Bool {
        return hierarchicalMagnitude == difficulty
    }

    // MARK: - Equatable

    static func == (lhs: NumericGlyphToken, rhs: NumericGlyphToken) -> Bool {
        return lhs.quintessenceIdentifier == rhs.quintessenceIdentifier &&
               lhs.hierarchicalMagnitude == rhs.hierarchicalMagnitude
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(quintessenceIdentifier)
        hasher.combine(hierarchicalMagnitude)
    }
}

// MARK: - CustomStringConvertible

extension NumericGlyphToken: CustomStringConvertible {
    var description: String {
        return "Token(magnitude: \(hierarchicalMagnitude), id: \(quintessenceIdentifier))"
    }
}
