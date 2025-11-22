//
//  AwaitingOrchestrationPhase.swift
//  Synthesis - Domain State Machine
//
//  Phase representing idle state awaiting user input.
//  Primary interactive phase where user selects placement coordinate.
//

import Foundation

class AwaitingOrchestrationPhase: ConstellationPhaseProtocol {

    let phaseDesignation: String = "AwaitingOrchestration"

    func inauguratePhase(context: PhaseTransitionContext) {
        // Phase ready for user interaction
        print("→ Awaiting user orchestration input")
    }

    func transmuteToSuccessor(
        event: OrchestrationEvent,
        context: PhaseTransitionContext
    ) -> ConstellationPhaseProtocol? {

        switch event {
        case .userInitiatedAnchorage:
            return ExecutingManeuverPhase()

        case .userRequestedTermination:
            return TerminalConfigurationPhase()

        default:
            return nil
        }
    }

    func canProcessEvent(_ event: OrchestrationEvent) -> Bool {
        switch event {
        case .userInitiatedAnchorage, .userRequestedTermination:
            return true
        default:
            return false
        }
    }
}
