//
//  ConsolidateClusterDirective.swift
//  Synthesis - Domain Command
//
//  Command to consolidate adjacent congruent fragments into elevated magnitude.
//  Represents the core merge mechanic.
//

import Foundation

class ConsolidateClusterDirective: DirectiveProtocol {

    // MARK: - Properties

    let originCoordinate: LatticeCoordinate
    let temporalInscription: Date
    let classification: DirectiveClassification = .consolidateCluster

    private var clusterSnapshot: [LatticeCoordinate: NumericGlyphToken] = [:]
    private var consolidationCoordinate: LatticeCoordinate?

    // MARK: - Initialization

    init(origin: LatticeCoordinate) {
        self.originCoordinate = origin
        self.temporalInscription = Date()
    }

    // MARK: - DirectiveProtocol

    func executeWithinRealm(
        lattice: TessellationMatrix,
        context: OrchestrationRealmContext
    ) throws -> DirectiveExecutionOutcome {

        // Retrieve origin fragment
        guard let originFragment = lattice.retrieveFragment(at: originCoordinate) else {
            throw DirectiveExecutionError.fragmentAbsent
        }

        // Excavate congruent cluster using strategy
        let clusterCoordinates = context.adjacencyStrategy.excavateCongruentCluster(
            origin: originCoordinate,
            lattice: lattice
        )

        // Validate minimum cluster size (3 required)
        guard clusterCoordinates.count >= 3 else {
            throw DirectiveExecutionError.insufficientClusterMagnitude
        }

        // Create snapshot for undo
        clusterSnapshot = clusterCoordinates.reduce(into: [:]) { snapshot, coord in
            if let fragment = lattice.retrieveFragment(at: coord) {
                snapshot[coord] = fragment
            }
        }

        // Determine consolidation behavior based on difficulty
        let atMaximumEchelon = originFragment.residesAtMaximumEchelon(
            within: context.difficultyEchelon.rawValue
        )

        var merit: AccumulatedMerit
        var resultingFragment: NumericGlyphToken?

        if atMaximumEchelon {
            // At max difficulty: eradicate all fragments
            for coordinate in clusterCoordinates {
                try lattice.eradicateFragment(at: coordinate)
            }
            consolidationCoordinate = nil

        } else {
            // Below max: eradicate all except origin, transmute origin
            for coordinate in clusterCoordinates where coordinate != originCoordinate {
                try lattice.eradicateFragment(at: coordinate)
            }

            // Transmute origin to successor magnitude
            resultingFragment = try lattice.transmuteFragment(at: originCoordinate)
            consolidationCoordinate = originCoordinate
        }

        // Calculate merit using scoring strategy
        merit = context.scoringStrategy.calculateMeritAccumulation(
            consolidatedCluster: clusterCoordinates,
            tokenMagnitude: originFragment.hierarchicalMagnitude,
            amplifierChain: context.sequentialAmplifier
        )

        // Augment context merit
        context.accumulatedMerit.amalgamate(merit)

        // Escalate amplifier
        context.sequentialAmplifier.escalateAmplitude()

        return DirectiveExecutionOutcome(
            success: true,
            coordinates: clusterCoordinates,
            merit: merit,
            amplifierChanged: true,
            cascade: true,
            data: [
                "clusterSize": clusterCoordinates.count,
                "magnitude": originFragment.hierarchicalMagnitude,
                "resultFragment": resultingFragment as Any
            ]
        )
    }

    func reverseExecution(
        lattice: TessellationMatrix,
        context: OrchestrationRealmContext
    ) throws {
        // Restore all fragments from snapshot
        for (coordinate, fragment) in clusterSnapshot {
            try lattice.eradicateFragment(at: coordinate)
            try lattice.anchorFragment(fragment, at: coordinate)
        }

        // Note: Merit and amplifier reversal handled by ChronicleHistorianService
    }
}
