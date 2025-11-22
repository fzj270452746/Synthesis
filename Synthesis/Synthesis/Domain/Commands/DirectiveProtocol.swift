//
//  DirectiveProtocol.swift
//  Synthesis - Domain Command
//
//  Defines command pattern protocol for encapsulating game operations.
//  Enables undo/redo, move history, and replay functionality.
//

import Foundation

protocol DirectiveProtocol {
    /// Executes directive operation
    func executeWithinRealm(
        lattice: TessellationMatrix,
        context: OrchestrationRealmContext
    ) throws -> DirectiveExecutionOutcome

    /// Reverses directive operation (undo)
    func reverseExecution(
        lattice: TessellationMatrix,
        context: OrchestrationRealmContext
    ) throws

    /// Directive temporal inscription
    var temporalInscription: Date { get }

    /// Directive classification
    var classification: DirectiveClassification { get }
}

// MARK: - Directive Classification

enum DirectiveClassification: String, Codable {
    case anchorFragment
    case consolidateCluster
    case transmuteFragment
    case eradicateFragments
    case generateFragment
}

// MARK: - Execution Outcome

struct DirectiveExecutionOutcome {
    let successfulExecution: Bool
    let affectedCoordinates: Set<LatticeCoordinate>
    let meritAugmentation: AccumulatedMerit
    let amplifierModification: Bool
    let cascadeTriggered: Bool
    let additionalData: [String: Any]

    init(
        success: Bool = true,
        coordinates: Set<LatticeCoordinate> = [],
        merit: AccumulatedMerit = AccumulatedMerit(),
        amplifierChanged: Bool = false,
        cascade: Bool = false,
        data: [String: Any] = [:]
    ) {
        self.successfulExecution = success
        self.affectedCoordinates = coordinates
        self.meritAugmentation = merit
        self.amplifierModification = amplifierChanged
        self.cascadeTriggered = cascade
        self.additionalData = data
    }
}

// MARK: - Orchestration Realm Context

class OrchestrationRealmContext {
    var accumulatedMerit: AccumulatedMerit
    var sequentialAmplifier: SequentialAmplifier
    var pendingFragment: NumericGlyphToken?
    var difficultyEchelon: DifficultyEchelon

    // Strategy dependencies
    var adjacencyStrategy: AdjacencyDetectionStrategy
    var scoringStrategy: ScoringStratagem

    // State tracking
    var lastExecutionOutcome: DirectiveExecutionOutcome?

    init(
        echelon: DifficultyEchelon,
        adjacencyStrategy: AdjacencyDetectionStrategy,
        scoringStrategy: ScoringStratagem
    ) {
        self.accumulatedMerit = AccumulatedMerit()
        self.sequentialAmplifier = SequentialAmplifier()
        self.difficultyEchelon = echelon
        self.adjacencyStrategy = adjacencyStrategy
        self.scoringStrategy = scoringStrategy
        self.pendingFragment = nil
    }
}

// MARK: - Directive Errors

enum DirectiveExecutionError: Error, LocalizedError {
    case coordinateInvalid
    case anchorOccupied
    case fragmentAbsent
    case insufficientClusterMagnitude
    case operationInvalidated

    var errorDescription: String? {
        switch self {
        case .coordinateInvalid:
            return "Coordinate resides outside valid boundaries"
        case .anchorOccupied:
            return "Anchor point already occupied"
        case .fragmentAbsent:
            return "No fragment present at coordinate"
        case .insufficientClusterMagnitude:
            return "Cluster size below minimum threshold"
        case .operationInvalidated:
            return "Operation cannot be executed in current state"
        }
    }
}
