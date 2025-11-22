//
//  GameViewController.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class ArenaCommandController: UIViewController {

    private let atmosphericBackdropCanvas = UIImageView()
    private let sovereignConductor: SovereignGameConductor
    private let latticeArenaCanvas: TactileLatticeArena

    private let triumphTallyInscription = UILabel()
    private let sequentialMultiplierDescriptor = UILabel()
    private let pendulousFragmentNotation = UILabel()
    private let anticipatedFragmentExhibit = EmbellishedGlyphCanvas()
    private let terminationPillar = UIButton()

    private var isOrchestratingManeuverSequence = false
    private var pinnacleSequentialAmplification = 0

    init(maximumValue: Int) {
        self.sovereignConductor = SovereignGameConductor(apexMagnitude: maximumValue)
        self.latticeArenaCanvas = TactileLatticeArena(
            horizontalStrata: sovereignConductor.horizontalStratumQuantity,
            verticalOrdinates: sovereignConductor.verticalOrdinateQuantity
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        architectExperientialFacade()
        establishSpatialConstraints()
        latticeArenaCanvas.manipulationOverseer = self
        recalibrateInterfaceComponents()
    }

    private func architectExperientialFacade() {
        // Background
        atmosphericBackdropCanvas.image = UIImage(named: "backgruiou")
        atmosphericBackdropCanvas.contentMode = .scaleAspectFill
        atmosphericBackdropCanvas.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(atmosphericBackdropCanvas)

        // Close button
        terminationPillar.setTitle("✕", for: .normal)
        terminationPillar.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        terminationPillar.setTitleColor(.white, for: .normal)
        terminationPillar.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        terminationPillar.layer.cornerRadius = 20
        terminationPillar.translatesAutoresizingMaskIntoConstraints = false
        terminationPillar.addTarget(self, action: #selector(terminationPillarPercussed), for: .touchUpInside)
        view.addSubview(terminationPillar)

        // Score label
        triumphTallyInscription.font = UIFont.boldSystemFont(ofSize: 24)
        triumphTallyInscription.textColor = .white
        triumphTallyInscription.textAlignment = .center
        triumphTallyInscription.layer.shadowColor = UIColor.black.cgColor
        triumphTallyInscription.layer.shadowOffset = CGSize(width: 0, height: 2)
        triumphTallyInscription.layer.shadowRadius = 4
        triumphTallyInscription.layer.shadowOpacity = 0.8
        triumphTallyInscription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(triumphTallyInscription)

        // Combo label
        sequentialMultiplierDescriptor.font = UIFont.boldSystemFont(ofSize: 20)
        sequentialMultiplierDescriptor.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
        sequentialMultiplierDescriptor.textAlignment = .center
        sequentialMultiplierDescriptor.layer.shadowColor = UIColor.black.cgColor
        sequentialMultiplierDescriptor.layer.shadowOffset = CGSize(width: 0, height: 2)
        sequentialMultiplierDescriptor.layer.shadowRadius = 4
        sequentialMultiplierDescriptor.layer.shadowOpacity = 0.8
        sequentialMultiplierDescriptor.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sequentialMultiplierDescriptor)

        // Game board
        latticeArenaCanvas.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(latticeArenaCanvas)

        // Next tile label
        pendulousFragmentNotation.text = "Next Tile"
        pendulousFragmentNotation.font = UIFont.boldSystemFont(ofSize: 18)
        pendulousFragmentNotation.textColor = .white
        pendulousFragmentNotation.textAlignment = .center
        pendulousFragmentNotation.layer.shadowColor = UIColor.black.cgColor
        pendulousFragmentNotation.layer.shadowOffset = CGSize(width: 0, height: 2)
        pendulousFragmentNotation.layer.shadowRadius = 4
        pendulousFragmentNotation.layer.shadowOpacity = 0.8
        pendulousFragmentNotation.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pendulousFragmentNotation)

        // Next tile preview
        anticipatedFragmentExhibit.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(anticipatedFragmentExhibit)
    }

    private func establishSpatialConstraints() {
        let boardSize: CGFloat = min(view.bounds.width - 40, 400)

        NSLayoutConstraint.activate([
            atmosphericBackdropCanvas.topAnchor.constraint(equalTo: view.topAnchor),
            atmosphericBackdropCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            atmosphericBackdropCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            atmosphericBackdropCanvas.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            terminationPillar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            terminationPillar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            terminationPillar.widthAnchor.constraint(equalToConstant: 40),
            terminationPillar.heightAnchor.constraint(equalToConstant: 40),

            triumphTallyInscription.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            triumphTallyInscription.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            sequentialMultiplierDescriptor.topAnchor.constraint(equalTo: triumphTallyInscription.bottomAnchor, constant: 8),
            sequentialMultiplierDescriptor.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            latticeArenaCanvas.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            latticeArenaCanvas.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            latticeArenaCanvas.widthAnchor.constraint(equalToConstant: boardSize),
            latticeArenaCanvas.heightAnchor.constraint(equalToConstant: boardSize),

            pendulousFragmentNotation.topAnchor.constraint(equalTo: latticeArenaCanvas.bottomAnchor, constant: 24),
            pendulousFragmentNotation.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            anticipatedFragmentExhibit.topAnchor.constraint(equalTo: pendulousFragmentNotation.bottomAnchor, constant: 12),
            anticipatedFragmentExhibit.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            anticipatedFragmentExhibit.widthAnchor.constraint(equalToConstant: 80),
            anticipatedFragmentExhibit.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func recalibrateInterfaceComponents() {
        triumphTallyInscription.text = "Score: \(sovereignConductor.accumulatedTriumphQuantity)"

        if sovereignConductor.perpetualSequentialMultiplier > 1 {
            sequentialMultiplierDescriptor.text = "Combo ×\(sovereignConductor.perpetualSequentialMultiplier)"
            sequentialMultiplierDescriptor.isHidden = false
            choreographSequenceDescriptor()
        } else {
            sequentialMultiplierDescriptor.isHidden = true
        }

        if let nextTile = sovereignConductor.pendulousFragmentDesignate {
            anticipatedFragmentExhibit.inscribeFragmentVisualization(with: nextTile)
        }

        pinnacleSequentialAmplification = max(pinnacleSequentialAmplification, sovereignConductor.perpetualSequentialMultiplier)
    }

    private func choreographSequenceDescriptor() {
        sequentialMultiplierDescriptor.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseOut) {
            self.sequentialMultiplierDescriptor.transform = .identity
        }
    }

    @objc private func terminationPillarPercussed() {
        OpulentInquiryPanel.renderInquisitivePanel(
            title: "Exit Game",
            message: "Are you sure you want to exit? Your current score will be saved.",
            actions: [
                ("Cancel", .subsidiary, {}),
                ("Exit", .cataclysmic, { [weak self] in
                    self?.archiveContemporaryTriumph()
                    self?.dismiss(animated: true)
                })
            ]
        )
    }

    private func archiveContemporaryTriumph() {
        // Only save if player has scored points
        guard sovereignConductor.accumulatedTriumphQuantity > 0 else { return }

        let record = VictoryChronicleNode(
            triumphantTally: sovereignConductor.accumulatedTriumphQuantity,
            adversityGradient: sovereignConductor.supremeGlyphEscalationCeiling,
            temporalAnchor: Date(),
            consecutiveSequencePinnacle: pinnacleSequentialAmplification
        )
        ArchivedRepositoryKeeper.sovereignExemplar.embedVictoryChronicle(record)
    }

    private func processArenaConclusion() {
        let record = VictoryChronicleNode(
            triumphantTally: sovereignConductor.accumulatedTriumphQuantity,
            adversityGradient: sovereignConductor.supremeGlyphEscalationCeiling,
            temporalAnchor: Date(),
            consecutiveSequencePinnacle: pinnacleSequentialAmplification
        )
        ArchivedRepositoryKeeper.sovereignExemplar.embedVictoryChronicle(record)

        OpulentInquiryPanel.renderInquisitivePanel(
            title: "Game Over",
            message: "Final Score: \(sovereignConductor.accumulatedTriumphQuantity)\nMax Combo: ×\(pinnacleSequentialAmplification)",
            actions: [
                ("Restart Game", .accentuated, { [weak self] in
                    self?.reinaugurateContestSequence()
                }),
                ("Back to Menu", .subsidiary, { [weak self] in
                    self?.dismiss(animated: true)
                })
            ]
        )
    }

    private func reinaugurateContestSequence() {
        // Dismiss current game view
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }

            // Get the presenting view controller and present a new game
            if let presentingVC = self.presentingViewController {
                let newGameVC = ArenaCommandController(maximumValue: self.sovereignConductor.supremeGlyphEscalationCeiling)
                newGameVC.modalPresentationStyle = .fullScreen
                presentingVC.present(newGameVC, animated: true)
            }
        }
    }
}

// MARK: - TactileManipulationOverseer

extension ArenaCommandController: TactileManipulationOverseer {

    func capturedAnchorVectorSelection(_ position: LatticeAnchorVector) {
        guard !isOrchestratingManeuverSequence else { return }
        guard sovereignConductor.canInscribeFragment(at: position) else { return }

        isOrchestratingManeuverSequence = true

        // Place tile
        guard sovereignConductor.embedFragmentIntoLattice(at: position) else {
            isOrchestratingManeuverSequence = false
            return
        }

        // Update UI
        if let tile = sovereignConductor.tessellatedMatrixRepository[position.horizontalStratum][position.verticalOrdinate] {
            latticeArenaCanvas.recalibrateCanvasContents(at: position, with: tile)
        }

        // Process merge
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.executeCoalescenceCascade(startingAt: position)
        }
    }

    private func executeCoalescenceCascade(startingAt position: LatticeAnchorVector) {
        let mergeResult = sovereignConductor.orchestrateCoalescenceMechanism(at: position)

        if mergeResult.amalgamatedVectors.isEmpty {
            // No merge occurred
            consolidateManeuverExecution()
            return
        }

        // Determine positions to clear (exclude upgrade position if exists)
        var positionsToClear = mergeResult.amalgamatedVectors
        if let upgradePos = mergeResult.transcendentVectorDesignate {
            positionsToClear.removeAll { $0 == upgradePos }
        }

        // Animate merge for positions that will be cleared
        if !positionsToClear.isEmpty {
            latticeArenaCanvas.executeCoalescenceChoreography(at: positionsToClear) { [weak self] in
                guard let self = self else { return }
                self.orchestrateTranscendenceOrFinality(mergeResult: mergeResult)
            }
        } else {
            // No positions to clear, just handle upgrade
            orchestrateTranscendenceOrFinality(mergeResult: mergeResult)
        }
    }

    private func orchestrateTranscendenceOrFinality(mergeResult: CoalescenceOutcomeBundle) {
        // If there's an upgraded tile, show it with animation
        if let newPosition = mergeResult.transcendentVectorDesignate,
           let newTile = sovereignConductor.tessellatedMatrixRepository[newPosition.horizontalStratum][newPosition.verticalOrdinate] {
            latticeArenaCanvas.choreographTranscendenceEvent(at: newPosition, with: newTile) {
                self.recalibrateInterfaceComponents()
                self.scrutinizeCascadingOpportunity()
            }
        } else {
            // Pure elimination, no upgrade - just update UI
            recalibrateInterfaceComponents()
            scrutinizeCascadingOpportunity()
        }
    }

    private func scrutinizeCascadingOpportunity() {
        if let chainPosition = sovereignConductor.scrutinizeForCascadingPhenomenon() {
            // Chain reaction detected
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.executeCoalescenceCascade(startingAt: chainPosition)
            }
        } else {
            // No more chains
            consolidateManeuverExecution()
        }
    }

    private func consolidateManeuverExecution() {
        sovereignConductor.synthesizePendulousFragment()
        recalibrateInterfaceComponents()

        if sovereignConductor.isLatticeComprehensivelyOccupied() {
            processArenaConclusion()
        }

        isOrchestratingManeuverSequence = false
    }
}
