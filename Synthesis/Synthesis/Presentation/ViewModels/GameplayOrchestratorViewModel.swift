//
//  GameplayOrchestratorViewModel.swift
//  Synthesis - Presentation ViewModel
//
//  ViewModel orchestrating gameplay presentation logic.
//  Bridges domain engine with view layer using MVVM pattern.
//

import Foundation
import UIKit

class GameplayOrchestratorViewModel {

    // MARK: - Properties

    private let orchestrationEngine: OrchestrationEngine
    private let chronicleRepository: ChronicleArchiveRepository
    private weak var navigationCoordinator: GameplayDirectiveCoordinator?

    // MARK: - Observable Outputs

    let latticeVisualizationData: ObservableVessel<[[TileVisualizationData?]]>
    let accumulatedMeritDisplay: ObservableVessel<String>
    let sequentialAmplifierDisplay: ObservableVessel<String>
    let pendingFragmentDisplay: ObservableVessel<TileVisualizationData?>
    let orchestrationPhaseDisplay: ObservableVessel<String>
    let isInteractionEnabled: ObservableVessel<Bool>

    // MARK: - Initialization

    init(
        difficultyEchelon: DifficultyEchelon,
        repository: ChronicleArchiveRepository = ChronicleArchiveRepository(),
        coordinator: GameplayDirectiveCoordinator? = nil
    ) {
        self.chronicleRepository = repository
        self.navigationCoordinator = coordinator

        // Create orchestration engine
        self.orchestrationEngine = OrchestrationEngine(
            difficultyEchelon: difficultyEchelon,
            adjacencyStrategy: DepthFirstExplorationStrategy(),
            scoringStrategy: StandardMeritCalculator()
        )

        // Initialize output observables
        self.latticeVisualizationData = ObservableVessel(initialPayload: [[]])
        self.accumulatedMeritDisplay = ObservableVessel(initialPayload: "0")
        self.sequentialAmplifierDisplay = ObservableVessel(initialPayload: "1x")
        self.pendingFragmentDisplay = ObservableVessel(initialPayload: nil)
        self.orchestrationPhaseDisplay = ObservableVessel(initialPayload: "Ready")
        self.isInteractionEnabled = ObservableVessel(initialPayload: true)

        // Bind engine observables to presentation
        configureObservableBindings()
    }

    // MARK: - Observable Bindings

    private func configureObservableBindings() {
        // Lattice snapshot → Visualization data
        orchestrationEngine.observableLatticeSnapshot.registerWitness { [weak self] snapshot in
            guard let self = self else { return }
            let visualizationGrid = snapshot.map { row in
                row.map { fragment in
                    fragment.map { TileVisualizationData(from: $0) }
                }
            }
            self.latticeVisualizationData.transmute(visualizationGrid)
        }

        // Merit → Display string
        orchestrationEngine.observableAccumulatedMerit.registerWitness { [weak self] merit in
            self?.accumulatedMeritDisplay.transmute(merit.formattedDesignation)
        }

        // Amplifier → Display string
        orchestrationEngine.observableSequentialAmplifier.registerWitness { [weak self] amplifier in
            let display = "\(amplifier.formattedDesignation) \(amplifier.visualIndicator)"
            self?.sequentialAmplifierDisplay.transmute(display)
        }

        // Pending fragment → Visualization data
        orchestrationEngine.observablePendingFragment.registerWitness { [weak self] fragment in
            let visualizationData = fragment.map { TileVisualizationData(from: $0) }
            self?.pendingFragmentDisplay.transmute(visualizationData)
        }

        // Game phase → Interaction state
        orchestrationEngine.observableGamePhase.registerWitness { [weak self] phase in
            self?.orchestrationPhaseDisplay.transmute(phase)
            self?.isInteractionEnabled.transmute(phase == "AwaitingOrchestration")
        }
    }

    // MARK: - User Actions

    /// Handles user-initiated tile placement
    func handleFragmentAnchorage(at coordinate: LatticeCoordinate) {
        do {
            try orchestrationEngine.processUserAnchorage(at: coordinate)

        } catch OrchestrationError.anchorOccupied {
            // Occupied cell - provide haptic feedback
            generateErrorHapticFeedback()

        } catch {
            print("Anchorage error: \(error.localizedDescription)")
        }
    }

    /// Handles game termination request
    func handleTerminationRequest() {
        // Save chronicle
        let chronicle = orchestrationEngine.fabricateTriumphChronicle()
        try? chronicleRepository.persistEntitySynchronously(chronicle)

        // Navigate back via coordinator
        navigationCoordinator?.concludeGameplaySession(finalChronicle: chronicle)
    }

    /// Handles game resurrection/restart
    func handleResurrectionRequest() {
        orchestrationEngine.resurrectOrchestration()
    }

    // MARK: - Computed Properties

    var currentScore: Int {
        return orchestrationEngine.currentScore
    }

    var currentCombo: Int {
        return orchestrationEngine.currentCombo
    }

    var isGameOver: Bool {
        return orchestrationEngine.isGameTerminated
    }

    var gridDimensions: Int {
        return orchestrationEngine.tessellatedLattice.dimensionalCapacity
    }

    // MARK: - Haptic Feedback

    private func generateErrorHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    private func generateSuccessHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// MARK: - Tile Visualization Data

struct TileVisualizationData {
    let magnitude: Int
    let assetDesignation: String
    let displayColor: UIColor

    init(from token: NumericGlyphToken) {
        self.magnitude = token.hierarchicalMagnitude
        self.assetDesignation = token.emblematicAssetDesignation

        // Color mapping based on magnitude
        self.displayColor = Self.colorForMagnitude(token.hierarchicalMagnitude)
    }

    private static func colorForMagnitude(_ magnitude: Int) -> UIColor {
        let hue = CGFloat(magnitude - 1) / 9.0
        return UIColor(hue: hue, saturation: 0.6, brightness: 0.8, alpha: 1.0)
    }
}
