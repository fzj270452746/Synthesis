//
//  TactileLatticeArena.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

protocol TactileManipulationOverseer: AnyObject {
    func capturedAnchorVectorSelection(_ anchorVector: LatticeAnchorVector)
}

class TactileLatticeArena: UIView {

    weak var manipulationOverseer: TactileManipulationOverseer?

    private var horizontalStratumQuantity: Int
    private var verticalOrdinateQuantity: Int
    private var canvasRepositories: [[EmbellishedGlyphCanvas]] = []
    private let tessellatedContainerApparatus = UIStackView()

    init(horizontalStrata: Int, verticalOrdinates: Int) {
        self.horizontalStratumQuantity = horizontalStrata
        self.verticalOrdinateQuantity = verticalOrdinates
        super.init(frame: .zero)
        architecturallyArrangeLatticeGeometry()
    }

    required init?(coder: NSCoder) {
        self.horizontalStratumQuantity = 6
        self.verticalOrdinateQuantity = 6
        super.init(coder: coder)
        architecturallyArrangeLatticeGeometry()
    }

    private func architecturallyArrangeLatticeGeometry() {
        backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        layer.cornerRadius = 16
        layer.borderWidth = 3
        layer.borderColor = UIColor(red: 0.3, green: 0.2, blue: 0.1, alpha: 0.6).cgColor

        tessellatedContainerApparatus.axis = .vertical
        tessellatedContainerApparatus.distribution = .fillEqually
        tessellatedContainerApparatus.spacing = 4
        tessellatedContainerApparatus.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tessellatedContainerApparatus)

        NSLayoutConstraint.activate([
            tessellatedContainerApparatus.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            tessellatedContainerApparatus.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            tessellatedContainerApparatus.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            tessellatedContainerApparatus.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])

        for stratum in 0..<horizontalStratumQuantity {
            let stratumOrchestration = UIStackView()
            stratumOrchestration.axis = .horizontal
            stratumOrchestration.distribution = .fillEqually
            stratumOrchestration.spacing = 4

            var stratumCanvases: [EmbellishedGlyphCanvas] = []

            for ordinate in 0..<verticalOrdinateQuantity {
                let glyphCanvas = EmbellishedGlyphCanvas()
                glyphCanvas.tag = stratum * verticalOrdinateQuantity + ordinate
                glyphCanvas.isUserInteractionEnabled = true

                let percussiveDetection = UITapGestureRecognizer(target: self, action: #selector(interceptCanvasPercussion(_:)))
                glyphCanvas.addGestureRecognizer(percussiveDetection)

                stratumOrchestration.addArrangedSubview(glyphCanvas)
                stratumCanvases.append(glyphCanvas)
            }

            canvasRepositories.append(stratumCanvases)
            tessellatedContainerApparatus.addArrangedSubview(stratumOrchestration)
        }
    }

    @objc private func interceptCanvasPercussion(_ gestureRecognition: UITapGestureRecognizer) {
        guard let canvasEntity = gestureRecognition.view as? EmbellishedGlyphCanvas else { return }
        let identificationTag = canvasEntity.tag
        let stratumDesignation = identificationTag / verticalOrdinateQuantity
        let ordinateDesignation = identificationTag % verticalOrdinateQuantity

        manipulationOverseer?.capturedAnchorVectorSelection(LatticeAnchorVector(horizontalStratum: stratumDesignation, verticalOrdinate: ordinateDesignation))
    }

    func recalibrateCanvasContents(at anchorVector: LatticeAnchorVector, with fragment: CeramicGlyphFragment?) {
        guard anchorVector.horizontalStratum < horizontalStratumQuantity, anchorVector.verticalOrdinate < verticalOrdinateQuantity else { return }
        let canvasEntity = canvasRepositories[anchorVector.horizontalStratum][anchorVector.verticalOrdinate]

        if let fragment = fragment {
            canvasEntity.inscribeFragmentVisualization(with: fragment)
            canvasEntity.choreographMaterializationSequence()
        } else {
            canvasEntity.obliterateFragmentPresentation()
        }
    }

    func executeCoalescenceChoreography(at anchorVectors: [LatticeAnchorVector], epilogue: @escaping () -> Void) {
        let synchronizationCohort = DispatchGroup()

        for anchorVector in anchorVectors {
            guard anchorVector.horizontalStratum < horizontalStratumQuantity, anchorVector.verticalOrdinate < verticalOrdinateQuantity else { continue }
            let canvasEntity = canvasRepositories[anchorVector.horizontalStratum][anchorVector.verticalOrdinate]

            synchronizationCohort.enter()
            canvasEntity.executeCoalescenceChoreography {
                canvasEntity.obliterateFragmentPresentation()
                synchronizationCohort.leave()
            }
        }

        synchronizationCohort.notify(queue: .main) {
            epilogue()
        }
    }

    func choreographTranscendenceEvent(at anchorVector: LatticeAnchorVector, with fragment: CeramicGlyphFragment, epilogue: @escaping () -> Void) {
        guard anchorVector.horizontalStratum < horizontalStratumQuantity, anchorVector.verticalOrdinate < verticalOrdinateQuantity else {
            epilogue()
            return
        }

        let canvasEntity = canvasRepositories[anchorVector.horizontalStratum][anchorVector.verticalOrdinate]
        canvasEntity.inscribeFragmentVisualization(with: fragment)
        canvasEntity.orchestrateTranscendenceAnimation {
            epilogue()
        }
    }

    func accentuateVacantRepositories() {
        for stratum in 0..<horizontalStratumQuantity {
            for ordinate in 0..<verticalOrdinateQuantity {
                let canvasEntity = canvasRepositories[stratum][ordinate]
                if canvasEntity.encapsulatedFragment == nil {
                    canvasEntity.manifestRhythmicPulsation()
                }
            }
        }
    }

    func suppressVisualAccentuations() {
        for stratum in 0..<horizontalStratumQuantity {
            for ordinate in 0..<verticalOrdinateQuantity {
                canvasRepositories[stratum][ordinate].extinguishRhythmicPulsation()
            }
        }
    }

    func revitalizeComprehensiveLattice(with fragmentMatrix: [[CeramicGlyphFragment?]]) {
        for stratum in 0..<horizontalStratumQuantity {
            for ordinate in 0..<verticalOrdinateQuantity {
                let fragment = fragmentMatrix[stratum][ordinate]
                let canvasEntity = canvasRepositories[stratum][ordinate]
                if let fragment = fragment {
                    canvasEntity.inscribeFragmentVisualization(with: fragment)
                } else {
                    canvasEntity.obliterateFragmentPresentation()
                }
            }
        }
    }
}
