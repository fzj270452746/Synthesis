//
//  GameBoardGridView.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import UIKit

protocol GameBoardInteractionDelegate: AnyObject {
    func didSelectGridPosition(_ position: GridPositionCoordinate)
}

class GameBoardGridView: UIView {

    weak var interactionDelegate: GameBoardInteractionDelegate?

    private var gridRowCount: Int
    private var gridColumnCount: Int
    private var tileViews: [[MahjongTileView]] = []
    private let gridContainerStack = UIStackView()

    init(rows: Int, columns: Int) {
        self.gridRowCount = rows
        self.gridColumnCount = columns
        super.init(frame: .zero)
        configureGridLayout()
    }

    required init?(coder: NSCoder) {
        self.gridRowCount = 6
        self.gridColumnCount = 6
        super.init(coder: coder)
        configureGridLayout()
    }

    private func configureGridLayout() {
        backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        layer.cornerRadius = 16
        layer.borderWidth = 3
        layer.borderColor = UIColor(red: 0.3, green: 0.2, blue: 0.1, alpha: 0.6).cgColor

        gridContainerStack.axis = .vertical
        gridContainerStack.distribution = .fillEqually
        gridContainerStack.spacing = 4
        gridContainerStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gridContainerStack)

        NSLayoutConstraint.activate([
            gridContainerStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            gridContainerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            gridContainerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            gridContainerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])

        for row in 0..<gridRowCount {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 4

            var rowTiles: [MahjongTileView] = []

            for col in 0..<gridColumnCount {
                let tileView = MahjongTileView()
                tileView.tag = row * gridColumnCount + col
                tileView.isUserInteractionEnabled = true

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTileTap(_:)))
                tileView.addGestureRecognizer(tapGesture)

                rowStack.addArrangedSubview(tileView)
                rowTiles.append(tileView)
            }

            tileViews.append(rowTiles)
            gridContainerStack.addArrangedSubview(rowStack)
        }
    }

    @objc private func handleTileTap(_ gesture: UITapGestureRecognizer) {
        guard let tileView = gesture.view as? MahjongTileView else { return }
        let tag = tileView.tag
        let row = tag / gridColumnCount
        let col = tag % gridColumnCount

        interactionDelegate?.didSelectGridPosition(GridPositionCoordinate(rowIndex: row, columnIndex: col))
    }

    func updateTile(at position: GridPositionCoordinate, with entity: MahjongTileEntity?) {
        guard position.rowIndex < gridRowCount, position.columnIndex < gridColumnCount else { return }
        let tileView = tileViews[position.rowIndex][position.columnIndex]

        if let entity = entity {
            tileView.configureTile(with: entity)
            tileView.animateAppearance()
        } else {
            tileView.clearTile()
        }
    }

    func animateMerge(at positions: [GridPositionCoordinate], completion: @escaping () -> Void) {
        let group = DispatchGroup()

        for position in positions {
            guard position.rowIndex < gridRowCount, position.columnIndex < gridColumnCount else { continue }
            let tileView = tileViews[position.rowIndex][position.columnIndex]

            group.enter()
            tileView.animateMerge {
                tileView.clearTile()
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion()
        }
    }

    func animateUpgrade(at position: GridPositionCoordinate, with entity: MahjongTileEntity, completion: @escaping () -> Void) {
        guard position.rowIndex < gridRowCount, position.columnIndex < gridColumnCount else {
            completion()
            return
        }

        let tileView = tileViews[position.rowIndex][position.columnIndex]
        tileView.configureTile(with: entity)
        tileView.animateUpgrade {
            completion()
        }
    }

    func highlightEmptySpaces() {
        for row in 0..<gridRowCount {
            for col in 0..<gridColumnCount {
                let tileView = tileViews[row][col]
                if tileView.tileEntity == nil {
                    tileView.applyPulseEffect()
                }
            }
        }
    }

    func removeHighlights() {
        for row in 0..<gridRowCount {
            for col in 0..<gridColumnCount {
                tileViews[row][col].removePulseEffect()
            }
        }
    }

    func refreshEntireGrid(with matrix: [[MahjongTileEntity?]]) {
        for row in 0..<gridRowCount {
            for col in 0..<gridColumnCount {
                let entity = matrix[row][col]
                let tileView = tileViews[row][col]
                if let entity = entity {
                    tileView.configureTile(with: entity)
                } else {
                    tileView.clearTile()
                }
            }
        }
    }
}
