//
//  TessellatedArenaCanvas.swift
//  Synthesis - Presentation Component
//
//  Grid canvas displaying tessellated lattice of numeric glyph tokens.
//  Handles user interaction and coordinates visual transformations.
//

import UIKit

protocol TessellatedArenaInteractionDelegate: AnyObject {
    func didSelectAnchorPoint(at coordinate: LatticeCoordinate)
}

class TessellatedArenaCanvas: UIView {

    // MARK: - Properties

    private var dimensionalCapacity: Int
    private var glyphMatrix: [[NumericGlyphVisage]] = []
    private let stackContainer: UIStackView

    weak var interactionDelegate: TessellatedArenaInteractionDelegate?

    // MARK: - Initialization

    init(dimensionalCapacity: Int) {
        self.dimensionalCapacity = dimensionalCapacity
        self.stackContainer = UIStackView()
        super.init(frame: .zero)

        configureStackContainer()
        fabricateGlyphMatrix()
    }

    required init?(coder: NSCoder) {
        self.dimensionalCapacity = 4
        self.stackContainer = UIStackView()
        super.init(coder: coder)

        configureStackContainer()
        fabricateGlyphMatrix()
    }

    // MARK: - Configuration

    private func configureStackContainer() {
        stackContainer.axis = .vertical
        stackContainer.distribution = .fillEqually
        stackContainer.spacing = 8
        stackContainer.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackContainer)

        NSLayoutConstraint.activate([
            stackContainer.topAnchor.constraint(equalTo: topAnchor),
            stackContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }

    private func fabricateGlyphMatrix() {
        // Clear existing matrix
        stackContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        glyphMatrix.removeAll()

        // Create rows
        for stratumIndex in 0..<dimensionalCapacity {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 8

            var rowGlyphs: [NumericGlyphVisage] = []

            // Create cells in row
            for ordinateIndex in 0..<dimensionalCapacity {
                let glyphVisage = NumericGlyphVisage()
                glyphVisage.obliteratePresentation()

                // Add tap gesture
                let tapGesture = UITapGestureRecognizer(
                    target: self,
                    action: #selector(handleGlyphTap(_:))
                )
                glyphVisage.addGestureRecognizer(tapGesture)
                glyphVisage.isUserInteractionEnabled = true
                glyphVisage.tag = stratumIndex * 100 + ordinateIndex

                rowStack.addArrangedSubview(glyphVisage)
                rowGlyphs.append(glyphVisage)
            }

            stackContainer.addArrangedSubview(rowStack)
            glyphMatrix.append(rowGlyphs)
        }
    }

    // MARK: - Interaction

    @objc private func handleGlyphTap(_ gesture: UITapGestureRecognizer) {
        guard let glyphView = gesture.view as? NumericGlyphVisage else { return }

        let tag = glyphView.tag
        let stratum = tag / 100
        let ordinate = tag % 100

        let coordinate = LatticeCoordinate(stratum: stratum, ordinate: ordinate)
        interactionDelegate?.didSelectAnchorPoint(at: coordinate)
    }

    // MARK: - Presentation Update

    func updatePresentation(with visualizationGrid: [[TileVisualizationData?]]) {
        guard visualizationGrid.count == dimensionalCapacity else { return }

        for (stratumIndex, row) in visualizationGrid.enumerated() {
            guard row.count == dimensionalCapacity else { continue }
            guard stratumIndex < glyphMatrix.count else { continue }

            for (ordinateIndex, visualizationData) in row.enumerated() {
                guard ordinateIndex < glyphMatrix[stratumIndex].count else { continue }

                let glyphVisage = glyphMatrix[stratumIndex][ordinateIndex]
                glyphVisage.presentVisualization(visualizationData)
            }
        }
    }

    // MARK: - Animations

    func animateFragmentAppearance(
        at coordinate: LatticeCoordinate,
        completion: (() -> Void)? = nil
    ) {
        guard let glyphVisage = retrieveGlyphVisage(at: coordinate) else {
            completion?()
            return
        }

        glyphVisage.animateAppearance(completion: completion)
    }

    func animateClusterMerge(
        coordinates: Set<LatticeCoordinate>,
        completion: (() -> Void)? = nil
    ) {
        let dispatchGroup = DispatchGroup()

        for coordinate in coordinates {
            guard let glyphVisage = retrieveGlyphVisage(at: coordinate) else { continue }

            dispatchGroup.enter()
            glyphVisage.animateMerge {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }

    func animateFragmentUpgrade(
        at coordinate: LatticeCoordinate,
        newData: TileVisualizationData,
        completion: (() -> Void)? = nil
    ) {
        guard let glyphVisage = retrieveGlyphVisage(at: coordinate) else {
            completion?()
            return
        }

        glyphVisage.animateUpgrade(newData: newData, completion: completion)
    }

    func animateClusterPulse(
        coordinates: Set<LatticeCoordinate>,
        completion: (() -> Void)? = nil
    ) {
        let dispatchGroup = DispatchGroup()

        for coordinate in coordinates {
            guard let glyphVisage = retrieveGlyphVisage(at: coordinate) else { continue }

            dispatchGroup.enter()
            glyphVisage.animatePulse(iterations: 1) {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }

    // MARK: - Utility

    private func retrieveGlyphVisage(at coordinate: LatticeCoordinate) -> NumericGlyphVisage? {
        guard coordinate.horizontalStratum >= 0,
              coordinate.horizontalStratum < dimensionalCapacity,
              coordinate.verticalOrdinate >= 0,
              coordinate.verticalOrdinate < dimensionalCapacity else {
            return nil
        }

        return glyphMatrix[coordinate.horizontalStratum][coordinate.verticalOrdinate]
    }

    // MARK: - Reconfiguration

    func reconfigureWithDimensions(_ newDimensions: Int) {
        self.dimensionalCapacity = newDimensions
        fabricateGlyphMatrix()
    }
}
