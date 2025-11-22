//
//  LatticeCoordinate.swift
//  Synthesis - Domain Entity
//
//  Represents a position vector within the tessellated game matrix.
//  Provides navigation and boundary validation capabilities.
//

import Foundation

struct LatticeCoordinate: Hashable, Equatable {

    // MARK: - Properties

    /// Horizontal stratum index (row position)
    let horizontalStratum: Int

    /// Vertical ordinate index (column position)
    let verticalOrdinate: Int

    // MARK: - Initialization

    init(stratum: Int, ordinate: Int) {
        self.horizontalStratum = stratum
        self.verticalOrdinate = ordinate
    }

    // MARK: - Navigation

    /// Cardinal compass bearings for directional navigation
    enum CompassBearing: CaseIterable {
        case northernHemisphere
        case southernHemisphere
        case easternQuadrant
        case westernQuadrant

        var vectorTransformation: (stratum: Int, ordinate: Int) {
            switch self {
            case .northernHemisphere: return (-1, 0)
            case .southernHemisphere: return (1, 0)
            case .easternQuadrant: return (0, 1)
            case .westernQuadrant: return (0, -1)
            }
        }
    }

    /// Navigates to adjacent coordinate along specified bearing
    func navigateAlong(bearing: CompassBearing) -> LatticeCoordinate {
        let transformation = bearing.vectorTransformation
        return LatticeCoordinate(
            stratum: horizontalStratum + transformation.stratum,
            ordinate: verticalOrdinate + transformation.ordinate
        )
    }

    /// Retrieves all adjacent coordinates in cardinal directions
    func excavateAdjacentCoordinates() -> [LatticeCoordinate] {
        return CompassBearing.allCases.map { bearing in
            navigateAlong(bearing: bearing)
        }
    }

    // MARK: - Validation

    /// Validates coordinate resides within lattice boundaries
    func residesWithinBoundaries(rows: Int, columns: Int) -> Bool {
        return horizontalStratum >= 0 &&
               horizontalStratum < rows &&
               verticalOrdinate >= 0 &&
               verticalOrdinate < columns
    }

    // MARK: - Hashable & Equatable

    func hash(into hasher: inout Hasher) {
        hasher.combine(horizontalStratum)
        hasher.combine(verticalOrdinate)
    }

    static func == (lhs: LatticeCoordinate, rhs: LatticeCoordinate) -> Bool {
        return lhs.horizontalStratum == rhs.horizontalStratum &&
               lhs.verticalOrdinate == rhs.verticalOrdinate
    }
}

// MARK: - CustomStringConvertible

extension LatticeCoordinate: CustomStringConvertible {
    var description: String {
        return "Coordinate(stratum: \(horizontalStratum), ordinate: \(verticalOrdinate))"
    }
}
