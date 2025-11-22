//
//  OrchestrationEngine.swift
//  Synthesis - Domain Service
//
//  Core game orchestration engine managing all gameplay logic.
//  Coordinates state machine, commands, strategies, and lattice operations.
//

import Foundation

class OrchestrationEngine {

    // MARK: - Properties

    /// Tessellated game lattice
    private(set) var tessellatedLattice: TessellationMatrix

    /// Orchestration realm context
    private(set) var realmContext: OrchestrationRealmContext

    /// State machine orchestrator
    private let stateMachine: StateMachineOrchestrator

    /// Command historian for undo/redo
    private let commandHistorian: ChronicleHistorianService

    /// Fragment forge for token generation
    private let fragmentForge: FragmentArchetypeForge

    // MARK: - Observable State

    let observableLatticeSnapshot: ObservableVessel<[[NumericGlyphToken?]]>
    let observableAccumulatedMerit: ObservableVessel<AccumulatedMerit>
    let observableSequentialAmplifier: ObservableVessel<SequentialAmplifier>
    let observablePendingFragment: ObservableVessel<NumericGlyphToken?>
    let observableGamePhase: ObservableVessel<String>

    // MARK: - Initialization

    init(
        difficultyEchelon: DifficultyEchelon,
        adjacencyStrategy: AdjacencyDetectionStrategy = DepthFirstExplorationStrategy(),
        scoringStrategy: ScoringStratagem = StandardMeritCalculator()
    ) {
        // Create lattice
        self.tessellatedLattice = GridLatticeFabricator.fabricateLattice(
            forEchelon: difficultyEchelon
        )

        // Create realm context
        self.realmContext = OrchestrationRealmContext(
            echelon: difficultyEchelon,
            adjacencyStrategy: adjacencyStrategy,
            scoringStrategy: scoringStrategy
        )

        // Create fragment forge
        self.fragmentForge = FragmentArchetypeForge(echelon: difficultyEchelon)

        // Create command historian
        self.commandHistorian = ChronicleHistorianService()

        // Initialize observables
        self.observableLatticeSnapshot = ObservableVessel(
            initialPayload: tessellatedLattice.createImmutableSnapshot()
        )
        self.observableAccumulatedMerit = ObservableVessel(
            initialPayload: AccumulatedMerit()
        )
        self.observableSequentialAmplifier = ObservableVessel(
            initialPayload: SequentialAmplifier()
        )
        self.observablePendingFragment = ObservableVessel(
            initialPayload: nil
        )
        self.observableGamePhase = ObservableVessel(
            initialPayload: "AwaitingOrchestration"
        )

        // Create state machine
        self.stateMachine = StateMachineOrchestrator()

        // Set engine reference after initialization
        stateMachine.transitionContext.orchestrationEngine = self

        // Generate initial fragment
        generateNextPendingFragment()
    }

    // MARK: - Primary Game Interface

    /// Processes user-initiated fragment anchorage
    func processUserAnchorage(at coordinate: LatticeCoordinate) throws {
        // Validate state allows user input
        guard stateMachine.isAwaitingInput else {
            throw OrchestrationError.invalidStateForOperation
        }

        // Validate coordinate
        guard coordinate.residesWithinBoundaries(
            rows: tessellatedLattice.dimensionalCapacity,
            columns: tessellatedLattice.dimensionalCapacity
        ) else {
            throw OrchestrationError.coordinateOutOfBounds
        }

        // Validate anchor vacancy
        guard tessellatedLattice.isAnchorVacant(at: coordinate) else {
            throw OrchestrationError.anchorOccupied
        }

        // Get pending fragment
        guard let fragment = realmContext.pendingFragment else {
            throw OrchestrationError.noPendingFragment
        }

        // Transition to executing maneuver phase
        stateMachine.processEvent(.userInitiatedAnchorage(coordinate: coordinate))

        // Execute anchorage directive
        let anchorDirective = AnchorFragmentDirective(
            coordinate: coordinate,
            fragment: fragment
        )

        do {
            let outcome = try anchorDirective.executeWithinRealm(
                lattice: tessellatedLattice,
                context: realmContext
            )
            commandHistorian.archiveDirective(anchorDirective)

            // Update observables
            disseminateLatticeTransformation()

            // Process fragment anchored event
            stateMachine.processEvent(.fragmentAnchored)

            // Check for consolidation at placement coordinate
            try processConsolidationAtCoordinate(coordinate)

        } catch {
            // Revert to awaiting state on error
            stateMachine.forceTransitionTo(AwaitingOrchestrationPhase())
            throw error
        }
    }

    // MARK: - Consolidation Processing

    private func processConsolidationAtCoordinate(_ coordinate: LatticeCoordinate) throws {
        guard let fragment = tessellatedLattice.retrieveFragment(at: coordinate) else {
            // No fragment found, check cascade exhaustion
            completeCascadeSequence()
            return
        }

        // Excavate cluster
        let clusterCoordinates = realmContext.adjacencyStrategy.excavateCongruentCluster(
            origin: coordinate,
            lattice: tessellatedLattice
        )

        // Check minimum cluster size (3 required)
        if clusterCoordinates.count >= 3 {
            // Execute consolidation
            let consolidateDirective = ConsolidateClusterDirective(origin: coordinate)

            let outcome = try consolidateDirective.executeWithinRealm(
                lattice: tessellatedLattice,
                context: realmContext
            )
            commandHistorian.archiveDirective(consolidateDirective)

            // Update observables
            disseminateLatticeTransformation()
            disseminateMeritTransformation()
            disseminateAmplifierTransformation()

            // Check for cascade continuation
            try scrutinizeForCascadingConsolidations()

        } else {
            // No cluster found, cascade exhausted
            completeCascadeSequence()
        }
    }

    // MARK: - Cascade Detection

    private func scrutinizeForCascadingConsolidations() throws {
        // Scan entire lattice for consolidation opportunities
        let occupiedCoordinates = tessellatedLattice.excavateOccupiedCoordinates()

        for coordinate in occupiedCoordinates {
            guard let fragment = tessellatedLattice.retrieveFragment(at: coordinate) else {
                continue
            }

            let clusterCoordinates = realmContext.adjacencyStrategy.excavateCongruentCluster(
                origin: coordinate,
                lattice: tessellatedLattice
            )

            if clusterCoordinates.count >= 3 {
                // Cascade detected
                stateMachine.processEvent(.cascadeDetected)
                try processConsolidationAtCoordinate(coordinate)
                return
            }
        }

        // No cascade found
        completeCascadeSequence()
    }

    private func completeCascadeSequence() {
        stateMachine.processEvent(.cascadeExhausted)

        // Reset combo amplifier
        realmContext.sequentialAmplifier.obliterateAmplitude()
        disseminateAmplifierTransformation()

        // Check game over
        if tessellatedLattice.isComprehensivelyOccupied() {
            stateMachine.processEvent(.latticeComprehensivelyOccupied)
        } else {
            // Generate next fragment
            generateNextPendingFragment()
        }
    }

    // MARK: - Fragment Generation

    private func generateNextPendingFragment() {
        let newFragment = fragmentForge.forgeFragment()
        realmContext.pendingFragment = newFragment
        observablePendingFragment.transmute(newFragment)
    }

    // MARK: - Game Control

    /// Resurrects game to initial state
    func resurrectOrchestration() {
        // Clear lattice
        tessellatedLattice.obliterateAllFragments()

        // Reset context
        realmContext.accumulatedMerit.obliterate()
        realmContext.sequentialAmplifier.obliterateAmplitude()

        // Clear command history
        commandHistorian.obliterateArchive()

        // Reset state machine
        stateMachine.forceTransitionTo(AwaitingOrchestrationPhase())

        // Generate new fragment
        generateNextPendingFragment()

        // Update all observables
        disseminateAllTransformations()
    }

    /// Creates triumph chronicle from current session
    func fabricateTriumphChronicle() -> TriumphChronicle {
        return TriumphChronicle(
            merit: realmContext.accumulatedMerit,
            echelon: realmContext.difficultyEchelon,
            amplifier: realmContext.sequentialAmplifier,
            timestamp: Date()
        )
    }

    // MARK: - Observable Dissemination

    private func disseminateLatticeTransformation() {
        let snapshot = tessellatedLattice.createImmutableSnapshot()
        observableLatticeSnapshot.transmute(snapshot)
    }

    private func disseminateMeritTransformation() {
        observableAccumulatedMerit.transmute(realmContext.accumulatedMerit)
    }

    private func disseminateAmplifierTransformation() {
        observableSequentialAmplifier.transmute(realmContext.sequentialAmplifier)
    }

    private func disseminateAllTransformations() {
        disseminateLatticeTransformation()
        disseminateMeritTransformation()
        disseminateAmplifierTransformation()
    }

    // MARK: - State Queries

    var isAwaitingUserInput: Bool {
        return stateMachine.isAwaitingInput
    }

    var isGameTerminated: Bool {
        return stateMachine.isTerminal
    }

    var currentScore: Int {
        return realmContext.accumulatedMerit.totalQuantity
    }

    var currentCombo: Int {
        return realmContext.sequentialAmplifier.amplitudeMagnitude
    }
}

// MARK: - Orchestration Errors

enum OrchestrationError: Error, LocalizedError {
    case invalidStateForOperation
    case coordinateOutOfBounds
    case anchorOccupied
    case noPendingFragment

    var errorDescription: String? {
        switch self {
        case .invalidStateForOperation:
            return "Operation cannot be executed in current game phase"
        case .coordinateOutOfBounds:
            return "Coordinate resides outside lattice boundaries"
        case .anchorOccupied:
            return "Selected anchor point already occupied"
        case .noPendingFragment:
            return "No fragment available for placement"
        }
    }
}

// MARK: - CustomStringConvertible

extension OrchestrationEngine: CustomStringConvertible {
    var description: String {
        return """
        OrchestrationEngine(
          score: \(currentScore),
          combo: \(currentCombo)x,
          occupied: \(tessellatedLattice.occupiedAnchorCount)/\(tessellatedLattice.totalCapacity),
          phase: \(stateMachine.currentPhase.phaseDesignation)
        )
        """
    }
}
