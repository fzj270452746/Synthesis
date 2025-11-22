//
//  ExecutingManeuverPhase.swift
//  Synthesis - Domain State Machine
//
//  Phase executing user's tile placement and immediate consolidation check.
//  Transitions to cascade detection or returns to awaiting.
//

import Foundation

class ExecutingManeuverPhase: ConstellationPhaseProtocol {

    let phaseDesignation: String = "ExecutingManeuver"

    func inauguratePhase(context: PhaseTransitionContext) {
        print("→ Executing placement maneuver")
    }

    func transmuteToSuccessor(
        event: OrchestrationEvent,
        context: PhaseTransitionContext
    ) -> ConstellationPhaseProtocol? {

        switch event {
        case .fragmentAnchored:
            // Check for immediate cluster at placement location
            return InducingCascadePhase()

        case .latticeComprehensivelyOccupied:
            return TerminalConfigurationPhase()

        default:
            return nil
        }
    }

    func canProcessEvent(_ event: OrchestrationEvent) -> Bool {
        switch event {
        case .fragmentAnchored, .latticeComprehensivelyOccupied:
            return true
        default:
            return false
        }
    }
}
