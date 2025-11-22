//
//  AnchorFragmentDirective.swift
//  Synthesis - Domain Command
//
//  Command to anchor a numeric glyph token at specified coordinate.
//  Represents user's tile placement action.
//

import Foundation

class AnchorFragmentDirective: DirectiveProtocol {

    // MARK: - Properties

    let coordinate: LatticeCoordinate
    let fragment: NumericGlyphToken
    let temporalInscription: Date
    let classification: DirectiveClassification = .anchorFragment

    // MARK: - Initialization

    init(coordinate: LatticeCoordinate, fragment: NumericGlyphToken) {
        self.coordinate = coordinate
        self.fragment = fragment
        self.temporalInscription = Date()
    }

    // MARK: - DirectiveProtocol

    func executeWithinRealm(
        lattice: TessellationMatrix,
        context: OrchestrationRealmContext
    ) throws -> DirectiveExecutionOutcome {

        // Validate coordinate boundaries
        guard coordinate.residesWithinBoundaries(
            rows: lattice.dimensionalCapacity,
            columns: lattice.dimensionalCapacity
        ) else {
            throw DirectiveExecutionError.coordinateInvalid
        }

        // Validate anchor vacancy
        guard lattice.isAnchorVacant(at: coordinate) else {
            throw DirectiveExecutionError.anchorOccupied
        }

        // Anchor fragment
        try lattice.anchorFragment(fragment, at: coordinate)

        return DirectiveExecutionOutcome(
            success: true,
            coordinates: [coordinate],
            merit: AccumulatedMerit(),
            amplifierChanged: false,
            cascade: false,
            data: ["fragment": fragment]
        )
    }

    func reverseExecution(
        lattice: TessellationMatrix,
        context: OrchestrationRealmContext
    ) throws {
        // Remove anchored fragment
        try lattice.eradicateFragment(at: coordinate)
    }
}
