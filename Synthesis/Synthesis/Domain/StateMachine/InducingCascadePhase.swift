//
//  InducingCascadePhase.swift
//  Synthesis - Domain State Machine
//
//  Phase processing chain reactions and cascading consolidations.
//  Loops until no more clusters detected, then returns to awaiting.
//

import Foundation

class InducingCascadePhase: ConstellationPhaseProtocol {

    let phaseDesignation: String = "InducingCascade"

    func inauguratePhase(context: PhaseTransitionContext) {
        print("→ Inducing cascade reactions")
    }

    func transmuteToSuccessor(
        event: OrchestrationEvent,
        context: PhaseTransitionContext
    ) -> ConstellationPhaseProtocol? {

        switch event {
        case .cascadeDetected:
            // Continue cascade processing (recursive)
            return InducingCascadePhase()

        case .cascadeExhausted:
            // No more clusters, check game over
            if context.currentLattice.isComprehensivelyOccupied() {
                return TerminalConfigurationPhase()
            } else {
                return AwaitingOrchestrationPhase()
            }

        case .latticeComprehensivelyOccupied:
            return TerminalConfigurationPhase()

        default:
            return nil
        }
    }

    func conclusionPhase(context: PhaseTransitionContext) {
        // Reset combo if cascade exhausted without finding new clusters
        print("← Cascade processing concluded")
    }

    func canProcessEvent(_ event: OrchestrationEvent) -> Bool {
        switch event {
        case .cascadeDetected, .cascadeExhausted, .latticeComprehensivelyOccupied:
            return true
        default:
            return false
        }
    }
}
