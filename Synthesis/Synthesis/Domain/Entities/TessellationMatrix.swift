//
//  TessellationMatrix.swift
//  Synthesis - Domain Entity
//
//  Represents the game grid structure containing numeric glyph tokens.
//  Manages spatial arrangement and token lifecycle within the lattice.
//

import Foundation

class TessellationMatrix {

    // MARK: - Properties

    /// Dimensional capacity of the lattice
    private(set) var dimensionalCapacity: Int

    /// Two-dimensional repository of token fragments
    private var fragmentRepository: [[NumericGlyphToken?]]

    /// Total count of occupied anchor points
    private(set) var occupiedAnchorCount: Int = 0

    /// Total capacity of the lattice
    var totalCapacity: Int {
        return dimensionalCapacity * dimensionalCapacity
    }

    // MARK: - Initialization

    init(dimensionalCapacity: Int) {
        self.dimensionalCapacity = dimensionalCapacity
        self.fragmentRepository = Array(
            repeating: Array(repeating: nil, count: dimensionalCapacity),
            count: dimensionalCapacity
        )
    }

    // MARK: - Fragment Management

    /// Anchors a token fragment at specified coordinate
    func anchorFragment(_ fragment: NumericGlyphToken, at coordinate: LatticeCoordinate) throws {
        guard coordinate.residesWithinBoundaries(rows: dimensionalCapacity, columns: dimensionalCapacity) else {
            throw TessellationError.coordinateOutsideBoundaries
        }

        guard fragmentRepository[coordinate.horizontalStratum][coordinate.verticalOrdinate] == nil else {
            throw TessellationError.anchorPointOccupied
        }

        fragmentRepository[coordinate.horizontalStratum][coordinate.verticalOrdinate] = fragment
        occupiedAnchorCount += 1
    }

    /// Retrieves fragment residing at coordinate
    func retrieveFragment(at coordinate: LatticeCoordinate) -> NumericGlyphToken? {
        guard coordinate.residesWithinBoundaries(rows: dimensionalCapacity, columns: dimensionalCapacity) else {
            return nil
        }
        return fragmentRepository[coordinate.horizontalStratum][coordinate.verticalOrdinate]
    }

    /// Eradicates fragment from specified coordinate
    func eradicateFragment(at coordinate: LatticeCoordinate) throws {
        guard coordinate.residesWithinBoundaries(rows: dimensionalCapacity, columns: dimensionalCapacity) else {
            throw TessellationError.coordinateOutsideBoundaries
        }

        guard fragmentRepository[coordinate.horizontalStratum][coordinate.verticalOrdinate] != nil else {
            throw TessellationError.anchorPointVacant
        }

        fragmentRepository[coordinate.horizontalStratum][coordinate.verticalOrdinate] = nil
        occupiedAnchorCount -= 1
    }

    /// Transmutes fragment at coordinate to elevated magnitude
    func transmuteFragment(at coordinate: LatticeCoordinate) throws -> NumericGlyphToken {
        guard let existingFragment = retrieveFragment(at: coordinate) else {
            throw TessellationError.anchorPointVacant
        }

        let transmutedFragment = existingFragment.transmuteToSuccessorMagnitude()
        fragmentRepository[coordinate.horizontalStratum][coordinate.verticalOrdinate] = transmutedFragment

        return transmutedFragment
    }

    /// Validates if coordinate anchor is vacant
    func isAnchorVacant(at coordinate: LatticeCoordinate) -> Bool {
        guard coordinate.residesWithinBoundaries(rows: dimensionalCapacity, columns: dimensionalCapacity) else {
            return false
        }
        return fragmentRepository[coordinate.horizontalStratum][coordinate.verticalOrdinate] == nil
    }

    /// Determines if lattice is comprehensively occupied
    func isComprehensivelyOccupied() -> Bool {
        return occupiedAnchorCount >= totalCapacity
    }

    /// Excavates all vacant coordinates
    func excavateVacantCoordinates() -> [LatticeCoordinate] {
        var vacantCoordinates: [LatticeCoordinate] = []

        for stratum in 0..<dimensionalCapacity {
            for ordinate in 0..<dimensionalCapacity {
                let coordinate = LatticeCoordinate(stratum: stratum, ordinate: ordinate)
                if isAnchorVacant(at: coordinate) {
                    vacantCoordinates.append(coordinate)
                }
            }
        }

        return vacantCoordinates
    }

    /// Retrieves all occupied coordinates
    func excavateOccupiedCoordinates() -> [LatticeCoordinate] {
        var occupiedCoordinates: [LatticeCoordinate] = []

        for stratum in 0..<dimensionalCapacity {
            for ordinate in 0..<dimensionalCapacity {
                let coordinate = LatticeCoordinate(stratum: stratum, ordinate: ordinate)
                if !isAnchorVacant(at: coordinate) {
                    occupiedCoordinates.append(coordinate)
                }
            }
        }

        return occupiedCoordinates
    }

    /// Obliterates all fragments from lattice
    func obliterateAllFragments() {
        fragmentRepository = Array(
            repeating: Array(repeating: nil, count: dimensionalCapacity),
            count: dimensionalCapacity
        )
        occupiedAnchorCount = 0
    }

    // MARK: - Snapshot & Restoration

    /// Creates immutable snapshot of current lattice state
    func createImmutableSnapshot() -> [[NumericGlyphToken?]] {
        return fragmentRepository.map { $0 }
    }

    /// Restores lattice from snapshot
    func restoreFromSnapshot(_ snapshot: [[NumericGlyphToken?]]) {
        guard snapshot.count == dimensionalCapacity,
              snapshot.allSatisfy({ $0.count == dimensionalCapacity }) else {
            return
        }

        fragmentRepository = snapshot.map { $0 }
        occupiedAnchorCount = snapshot.reduce(0) { count, row in
            count + row.filter { $0 != nil }.count
        }
    }
}

// MARK: - Errors

enum TessellationError: Error, LocalizedError {
    case coordinateOutsideBoundaries
    case anchorPointOccupied
    case anchorPointVacant

    var errorDescription: String? {
        switch self {
        case .coordinateOutsideBoundaries:
            return "Coordinate resides outside lattice boundaries"
        case .anchorPointOccupied:
            return "Anchor point already occupied by fragment"
        case .anchorPointVacant:
            return "Anchor point contains no fragment"
        }
    }
}

// MARK: - CustomStringConvertible

extension TessellationMatrix: CustomStringConvertible {
    var description: String {
        var output = "TessellationMatrix(\(dimensionalCapacity)x\(dimensionalCapacity)):\n"
        for stratum in 0..<dimensionalCapacity {
            for ordinate in 0..<dimensionalCapacity {
                if let fragment = fragmentRepository[stratum][ordinate] {
                    output += "[\(fragment.hierarchicalMagnitude)]"
                } else {
                    output += "[ ]"
                }
            }
            output += "\n"
        }
        return output
    }
}
