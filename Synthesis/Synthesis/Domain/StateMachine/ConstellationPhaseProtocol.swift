//
//  ConstellationPhaseProtocol.swift
//  Synthesis - Domain State Machine
//
//  Defines protocol for game orchestration phases in state machine.
//  Each phase encapsulates specific game flow behavior.
//

import Foundation

protocol ConstellationPhaseProtocol {
    /// Phase designation for identification
    var phaseDesignation: String { get }

    /// Inaugurates phase execution
    func inauguratePhase(context: PhaseTransitionContext)

    /// Transmutes to successor phase based on events
    func transmuteToSuccessor(
        event: OrchestrationEvent,
        context: PhaseTransitionContext
    ) -> ConstellationPhaseProtocol?

    /// Concludes current phase execution
    func conclusionPhase(context: PhaseTransitionContext)

    /// Validates if event can be processed in current phase
    func canProcessEvent(_ event: OrchestrationEvent) -> Bool
}

// MARK: - Orchestration Events

enum OrchestrationEvent {
    case userInitiatedAnchorage(coordinate: LatticeCoordinate)
    case fragmentAnchored
    case clusterDetected(coordinates: Set<LatticeCoordinate>)
    case consolidationCompleted
    case cascadeDetected
    case cascadeExhausted
    case latticeComprehensivelyOccupied
    case userRequestedTermination
    case userRequestedResurrection
}

// MARK: - Phase Transition Context

class PhaseTransitionContext {
    weak var stateMachine: StateMachineOrchestrator?
    weak var orchestrationEngine: OrchestrationEngine?

    var currentLattice: TessellationMatrix {
        guard let engine = orchestrationEngine else {
            fatalError("Orchestration engine not configured")
        }
        return engine.tessellatedLattice
    }

    var realmContext: OrchestrationRealmContext {
        guard let engine = orchestrationEngine else {
            fatalError("Orchestration engine not configured")
        }
        return engine.realmContext
    }

    init(
        stateMachine: StateMachineOrchestrator? = nil,
        engine: OrchestrationEngine? = nil
    ) {
        self.stateMachine = stateMachine
        self.orchestrationEngine = engine
    }
}

// MARK: - Default Implementations

extension ConstellationPhaseProtocol {
    func inauguratePhase(context: PhaseTransitionContext) {
        // Default: no initialization required
    }

    func conclusionPhase(context: PhaseTransitionContext) {
        // Default: no cleanup required
    }

    func canProcessEvent(_ event: OrchestrationEvent) -> Bool {
        // Default: validate in transmuteToSuccessor
        return true
    }
}
