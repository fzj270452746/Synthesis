//
//  TutorialExpositionViewController.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

class EnlightenmentManualPresenter: UIViewController {

    private let pedagogicalBackdropCanvas = UIImageView()
    private let completionPillar = UIButton()
    private let instructionalContentVessel = UIScrollView()
    private let pedagogicalEncapsulation = UIView()

    private let magistralProclamation = UILabel()
    private let aspirationalDomainSegment = PedagogicalDomainSegment()
    private let operationalPrinciplesSegment = PedagogicalDomainSegment()
    private let quantificationMethodologySegment = PedagogicalDomainSegment()
    private let tacticalWisdomSegment = PedagogicalDomainSegment()

    override func viewDidLoad() {
        super.viewDidLoad()
        architectPedagogicalPresentation()
        infuseEducationalSubstance()
        delineateLayoutBoundaries()
    }

    private func architectPedagogicalPresentation() {
        // Background
        pedagogicalBackdropCanvas.image = UIImage(named: "backgruiou")
        pedagogicalBackdropCanvas.contentMode = .scaleAspectFill
        pedagogicalBackdropCanvas.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pedagogicalBackdropCanvas)

        // Close button
        completionPillar.setTitle("✕", for: .normal)
        completionPillar.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        completionPillar.setTitleColor(.white, for: .normal)
        completionPillar.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        completionPillar.layer.cornerRadius = 20
        completionPillar.translatesAutoresizingMaskIntoConstraints = false
        completionPillar.addTarget(self, action: #selector(completionPercussionDetected), for: .touchUpInside)
        view.addSubview(completionPillar)

        // Scroll view
        instructionalContentVessel.translatesAutoresizingMaskIntoConstraints = false
        instructionalContentVessel.showsVerticalScrollIndicator = true
        view.addSubview(instructionalContentVessel)

        // Container view
        pedagogicalEncapsulation.translatesAutoresizingMaskIntoConstraints = false
        instructionalContentVessel.addSubview(pedagogicalEncapsulation)

        // Header title
        magistralProclamation.text = "How to Play"
        magistralProclamation.font = UIFont.boldSystemFont(ofSize: 32)
        magistralProclamation.textColor = .white
        magistralProclamation.textAlignment = .center
        magistralProclamation.layer.shadowColor = UIColor.black.cgColor
        magistralProclamation.layer.shadowOffset = CGSize(width: 0, height: 2)
        magistralProclamation.layer.shadowRadius = 4
        magistralProclamation.layer.shadowOpacity = 0.8
        magistralProclamation.translatesAutoresizingMaskIntoConstraints = false
        pedagogicalEncapsulation.addSubview(magistralProclamation)

        // Section views
        aspirationalDomainSegment.translatesAutoresizingMaskIntoConstraints = false
        pedagogicalEncapsulation.addSubview(aspirationalDomainSegment)

        operationalPrinciplesSegment.translatesAutoresizingMaskIntoConstraints = false
        pedagogicalEncapsulation.addSubview(operationalPrinciplesSegment)

        quantificationMethodologySegment.translatesAutoresizingMaskIntoConstraints = false
        pedagogicalEncapsulation.addSubview(quantificationMethodologySegment)

        tacticalWisdomSegment.translatesAutoresizingMaskIntoConstraints = false
        pedagogicalEncapsulation.addSubview(tacticalWisdomSegment)
    }

    private func infuseEducationalSubstance() {
        aspirationalDomainSegment.inscribeDomainSubstance(
            heading: "Objective",
            description: "Match 3 or more adjacent tiles of the same value to merge them into higher-value tiles. Create combos and achieve the highest score possible!"
        )

        operationalPrinciplesSegment.inscribeDomainSubstance(
            heading: "Game Mechanics",
            description: """
            • Place tiles on the grid by tapping empty cells
            • When 3+ identical tiles connect (horizontally/vertically), they merge
            • Tiles upgrade progressively (筒1→筒2→筒3...→筒9)
            • At maximum difficulty level, tiles are eliminated instead of upgraded
            • Chain reactions occur when merges create new matching groups
            • Game ends when the grid is completely filled
            """
        )

        quantificationMethodologySegment.inscribeDomainSubstance(
            heading: "Scoring System",
            description: """
            • Base Score: Tile Value × 10 × Number of Merged Tiles
            • Combo Bonus: Each consecutive merge adds +50 points
            • Chain Reactions: Automatic merges multiply your combo
            • Higher difficulty levels yield greater scoring opportunities
            """
        )

        tacticalWisdomSegment.inscribeDomainSubstance(
            heading: "Strategic Tips",
            description: """
            • Plan ahead - consider the next tile preview
            • Build larger connected groups for better merges
            • Create chain reaction opportunities for combo bonuses
            • Manage grid space efficiently to avoid filling up
            • Higher difficulties offer bigger grids and more challenge
            """
        )
    }

    private func delineateLayoutBoundaries() {
        NSLayoutConstraint.activate([
            pedagogicalBackdropCanvas.topAnchor.constraint(equalTo: view.topAnchor),
            pedagogicalBackdropCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pedagogicalBackdropCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pedagogicalBackdropCanvas.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            completionPillar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            completionPillar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completionPillar.widthAnchor.constraint(equalToConstant: 40),
            completionPillar.heightAnchor.constraint(equalToConstant: 40),

            instructionalContentVessel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            instructionalContentVessel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            instructionalContentVessel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            instructionalContentVessel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            pedagogicalEncapsulation.topAnchor.constraint(equalTo: instructionalContentVessel.topAnchor),
            pedagogicalEncapsulation.leadingAnchor.constraint(equalTo: instructionalContentVessel.leadingAnchor),
            pedagogicalEncapsulation.trailingAnchor.constraint(equalTo: instructionalContentVessel.trailingAnchor),
            pedagogicalEncapsulation.bottomAnchor.constraint(equalTo: instructionalContentVessel.bottomAnchor),
            pedagogicalEncapsulation.widthAnchor.constraint(equalTo: instructionalContentVessel.widthAnchor),

            magistralProclamation.topAnchor.constraint(equalTo: pedagogicalEncapsulation.topAnchor, constant: 20),
            magistralProclamation.leadingAnchor.constraint(equalTo: pedagogicalEncapsulation.leadingAnchor, constant: 20),
            magistralProclamation.trailingAnchor.constraint(equalTo: pedagogicalEncapsulation.trailingAnchor, constant: -20),

            aspirationalDomainSegment.topAnchor.constraint(equalTo: magistralProclamation.bottomAnchor, constant: 24),
            aspirationalDomainSegment.leadingAnchor.constraint(equalTo: pedagogicalEncapsulation.leadingAnchor, constant: 20),
            aspirationalDomainSegment.trailingAnchor.constraint(equalTo: pedagogicalEncapsulation.trailingAnchor, constant: -20),

            operationalPrinciplesSegment.topAnchor.constraint(equalTo: aspirationalDomainSegment.bottomAnchor, constant: 20),
            operationalPrinciplesSegment.leadingAnchor.constraint(equalTo: pedagogicalEncapsulation.leadingAnchor, constant: 20),
            operationalPrinciplesSegment.trailingAnchor.constraint(equalTo: pedagogicalEncapsulation.trailingAnchor, constant: -20),

            quantificationMethodologySegment.topAnchor.constraint(equalTo: operationalPrinciplesSegment.bottomAnchor, constant: 20),
            quantificationMethodologySegment.leadingAnchor.constraint(equalTo: pedagogicalEncapsulation.leadingAnchor, constant: 20),
            quantificationMethodologySegment.trailingAnchor.constraint(equalTo: pedagogicalEncapsulation.trailingAnchor, constant: -20),

            tacticalWisdomSegment.topAnchor.constraint(equalTo: quantificationMethodologySegment.bottomAnchor, constant: 20),
            tacticalWisdomSegment.leadingAnchor.constraint(equalTo: pedagogicalEncapsulation.leadingAnchor, constant: 20),
            tacticalWisdomSegment.trailingAnchor.constraint(equalTo: pedagogicalEncapsulation.trailingAnchor, constant: -20),
            tacticalWisdomSegment.bottomAnchor.constraint(equalTo: pedagogicalEncapsulation.bottomAnchor, constant: -20)
        ])
    }

    @objc private func completionPercussionDetected() {
        dismiss(animated: true)
    }
}

// MARK: - Pedagogical Domain Segment

class PedagogicalDomainSegment: UIView {

    private let thematicProclamation = UILabel()
    private let expositoryNarration = UILabel()
    private let segmentEncapsulation = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        establishSegmentAesthetic()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func establishSegmentAesthetic() {
        // Container with semi-transparent background
        segmentEncapsulation.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        segmentEncapsulation.layer.cornerRadius = 16
        segmentEncapsulation.layer.borderWidth = 1
        segmentEncapsulation.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        segmentEncapsulation.translatesAutoresizingMaskIntoConstraints = false
        addSubview(segmentEncapsulation)

        // Heading label
        thematicProclamation.font = UIFont.boldSystemFont(ofSize: 22)
        thematicProclamation.textColor = UIColor(red: 1.0, green: 0.9, blue: 0.4, alpha: 1.0)
        thematicProclamation.numberOfLines = 0
        thematicProclamation.translatesAutoresizingMaskIntoConstraints = false
        segmentEncapsulation.addSubview(thematicProclamation)

        // Description label
        expositoryNarration.font = UIFont.systemFont(ofSize: 16)
        expositoryNarration.textColor = .white
        expositoryNarration.numberOfLines = 0
        expositoryNarration.translatesAutoresizingMaskIntoConstraints = false
        segmentEncapsulation.addSubview(expositoryNarration)

        NSLayoutConstraint.activate([
            segmentEncapsulation.topAnchor.constraint(equalTo: topAnchor),
            segmentEncapsulation.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentEncapsulation.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentEncapsulation.bottomAnchor.constraint(equalTo: bottomAnchor),

            thematicProclamation.topAnchor.constraint(equalTo: segmentEncapsulation.topAnchor, constant: 16),
            thematicProclamation.leadingAnchor.constraint(equalTo: segmentEncapsulation.leadingAnchor, constant: 16),
            thematicProclamation.trailingAnchor.constraint(equalTo: segmentEncapsulation.trailingAnchor, constant: -16),

            expositoryNarration.topAnchor.constraint(equalTo: thematicProclamation.bottomAnchor, constant: 12),
            expositoryNarration.leadingAnchor.constraint(equalTo: segmentEncapsulation.leadingAnchor, constant: 16),
            expositoryNarration.trailingAnchor.constraint(equalTo: segmentEncapsulation.trailingAnchor, constant: -16),
            expositoryNarration.bottomAnchor.constraint(equalTo: segmentEncapsulation.bottomAnchor, constant: -16)
        ])
    }

    func inscribeDomainSubstance(heading: String, description: String) {
        thematicProclamation.text = heading
        expositoryNarration.text = description
    }
}
