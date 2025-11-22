//
//  StateMachineOrchestrator.swift
//  Synthesis - Domain State Machine
//
//  Orchestrates state transitions between constellation phases.
//  Maintains current phase and processes orchestration events.
//

import Foundation

class StateMachineOrchestrator {

    // MARK: - Properties

    private(set) var currentPhase: ConstellationPhaseProtocol
    let transitionContext: PhaseTransitionContext

    /// Observable current phase designation
    var observablePhaseDesignation: ObservableVessel<String>

    // MARK: - Initialization

    init(
        initialPhase: ConstellationPhaseProtocol = AwaitingOrchestrationPhase(),
        orchestrationEngine: OrchestrationEngine? = nil
    ) {
        self.currentPhase = initialPhase
        self.transitionContext = PhaseTransitionContext(
            stateMachine: nil,
            engine: orchestrationEngine
        )
        self.observablePhaseDesignation = ObservableVessel(
            initialPayload: initialPhase.phaseDesignation
        )

        transitionContext.stateMachine = self

        // Inaugurate initial phase
        currentPhase.inauguratePhase(context: transitionContext)
    }

    // MARK: - Event Processing

    /// Processes orchestration event and transitions if applicable
    func processEvent(_ event: OrchestrationEvent) {
        // Validate current phase can process event
        guard currentPhase.canProcessEvent(event) else {
            print("⚠️ Event \(event) cannot be processed in phase \(currentPhase.phaseDesignation)")
            return
        }

        // Attempt phase transition
        if let successorPhase = currentPhase.transmuteToSuccessor(
            event: event,
            context: transitionContext
        ) {
            transitionToPhase(successorPhase)
        }
    }

    // MARK: - Phase Transition

    private func transitionToPhase(_ newPhase: ConstellationPhaseProtocol) {
        print("⟳ Phase transition: \(currentPhase.phaseDesignation) → \(newPhase.phaseDesignation)")

        // Conclude current phase
        currentPhase.conclusionPhase(context: transitionContext)

        // Update current phase
        currentPhase = newPhase

        // Inaugurate new phase
        currentPhase.inauguratePhase(context: transitionContext)

        // Notify observers
        observablePhaseDesignation.transmute(newPhase.phaseDesignation)
    }

    /// Forces transition to specific phase (for resurrection/restart)
    func forceTransitionTo(_ phase: ConstellationPhaseProtocol) {
        transitionToPhase(phase)
    }

    // MARK: - State Queries

    var isAwaitingInput: Bool {
        return currentPhase is AwaitingOrchestrationPhase
    }

    var isProcessingManeuver: Bool {
        return currentPhase is ExecutingManeuverPhase
    }

    var isInducingCascade: Bool {
        return currentPhase is InducingCascadePhase
    }

    var isTerminal: Bool {
        return currentPhase is TerminalConfigurationPhase
    }
}

// MARK: - CustomStringConvertible

extension StateMachineOrchestrator: CustomStringConvertible {
    var description: String {
        return "StateMachine(phase: \(currentPhase.phaseDesignation))"
    }
}
