//
//  TerminalConfigurationPhase.swift
//  Synthesis - Domain State Machine
//
//  Phase representing game over state.
//  Handles chronicle persistence and resurrection initiation.
//

import Foundation

class TerminalConfigurationPhase: ConstellationPhaseProtocol {

    let phaseDesignation: String = "TerminalConfiguration"

    func inauguratePhase(context: PhaseTransitionContext) {
        print("→ Terminal configuration reached - Game Over")
    }

    func transmuteToSuccessor(
        event: OrchestrationEvent,
        context: PhaseTransitionContext
    ) -> ConstellationPhaseProtocol? {

        switch event {
        case .userRequestedResurrection:
            return AwaitingOrchestrationPhase()

        default:
            return nil
        }
    }

    func canProcessEvent(_ event: OrchestrationEvent) -> Bool {
        switch event {
        case .userRequestedResurrection:
            return true
        default:
            return false
        }
    }
}
