//
//  GameStateOrchestrator.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import Foundation

class GameStateOrchestrator {

    var gridMatrix: [[MahjongTileEntity?]]
    var currentScore: Int = 0
    var maximumTileValue: Int
    var nextTileToPlace: MahjongTileEntity?
    var consecutiveComboCount: Int = 0

    let gridRowCount: Int
    let gridColumnCount: Int

    init(maxValue: Int) {
        self.maximumTileValue = maxValue

        // Determine grid size based on difficulty
        switch maxValue {
        case 3, 4:
            self.gridRowCount = 3
            self.gridColumnCount = 3
        case 5, 6:
            self.gridRowCount = 4
            self.gridColumnCount = 4
        default: // 7, 8, 9
            self.gridRowCount = 6
            self.gridColumnCount = 6
        }

        self.gridMatrix = Array(repeating: Array(repeating: nil, count: gridColumnCount), count: gridRowCount)
        generateNextTile()
    }

    // MARK: - Tile Generation

    func generateNextTile() {
        let randomValue = Int.random(in: 1...maximumTileValue)
        nextTileToPlace = MahjongTileEntity(value: randomValue)
    }

    // MARK: - Placement Logic

    func canPlaceTile(at position: GridPositionCoordinate) -> Bool {
        guard position.rowIndex >= 0, position.rowIndex < gridRowCount,
              position.columnIndex >= 0, position.columnIndex < gridColumnCount else {
            return false
        }
        return gridMatrix[position.rowIndex][position.columnIndex] == nil
    }

    func placeTile(at position: GridPositionCoordinate) -> Bool {
        guard canPlaceTile(at: position), let tile = nextTileToPlace else {
            return false
        }

        gridMatrix[position.rowIndex][position.columnIndex] = tile
        return true
    }

    // MARK: - Connection Detection (DFS)

    func detectConnectedGroup(from position: GridPositionCoordinate) -> Set<GridPositionCoordinate> {
        guard let targetTile = gridMatrix[position.rowIndex][position.columnIndex] else {
            return []
        }

        var visitedPositions = Set<GridPositionCoordinate>()
        var connectedGroup = Set<GridPositionCoordinate>()

        depthFirstSearch(position: position, targetTile: targetTile, visited: &visitedPositions, connected: &connectedGroup)

        return connectedGroup
    }

    private func depthFirstSearch(position: GridPositionCoordinate, targetTile: MahjongTileEntity, visited: inout Set<GridPositionCoordinate>, connected: inout Set<GridPositionCoordinate>) {
        guard position.rowIndex >= 0, position.rowIndex < gridRowCount,
              position.columnIndex >= 0, position.columnIndex < gridColumnCount,
              !visited.contains(position) else {
            return
        }

        visited.insert(position)

        guard let currentTile = gridMatrix[position.rowIndex][position.columnIndex],
              currentTile == targetTile else {
            return
        }

        connected.insert(position)

        // Check 4 directions (up, down, left, right)
        let adjacentDirections = [
            GridPositionCoordinate(rowIndex: position.rowIndex - 1, columnIndex: position.columnIndex),
            GridPositionCoordinate(rowIndex: position.rowIndex + 1, columnIndex: position.columnIndex),
            GridPositionCoordinate(rowIndex: position.rowIndex, columnIndex: position.columnIndex - 1),
            GridPositionCoordinate(rowIndex: position.rowIndex, columnIndex: position.columnIndex + 1)
        ]

        for adjacentPos in adjacentDirections {
            depthFirstSearch(position: adjacentPos, targetTile: targetTile, visited: &visited, connected: &connected)
        }
    }

    // MARK: - Merge/Elimination Logic

    func processMergeOperation(at position: GridPositionCoordinate) -> MergeResultData {
        let connectedGroup = detectConnectedGroup(from: position)

        guard connectedGroup.count >= 3 else {
            consecutiveComboCount = 0
            return MergeResultData(mergedPositions: [], newTilePosition: nil, scoreGained: 0, comboMultiplier: 0)
        }

        guard let originalTile = gridMatrix[position.rowIndex][position.columnIndex] else {
            return MergeResultData(mergedPositions: [], newTilePosition: nil, scoreGained: 0, comboMultiplier: 0)
        }

        // Create upgraded tile or eliminate based on difficulty
        let newTilePosition: GridPositionCoordinate?

        if originalTile.numericalValue < maximumTileValue {
            // Not at max difficulty: upgrade to next level
            // Clear all positions first
            for pos in connectedGroup {
                gridMatrix[pos.rowIndex][pos.columnIndex] = nil
            }

            // Place upgraded tile at the position where merge was triggered (last clicked position)
            let upgradedTile = MahjongTileEntity(value: originalTile.numericalValue + 1)
            gridMatrix[position.rowIndex][position.columnIndex] = upgradedTile
            newTilePosition = position
        } else {
            // At max difficulty: eliminate all tiles completely
            for pos in connectedGroup {
                gridMatrix[pos.rowIndex][pos.columnIndex] = nil
            }
            newTilePosition = nil
        }

        // Calculate score
        consecutiveComboCount += 1
        let baseScore = originalTile.numericalValue * 10 * connectedGroup.count
        let comboBonus = consecutiveComboCount > 1 ? (consecutiveComboCount - 1) * 50 : 0
        let totalScore = baseScore + comboBonus

        currentScore += totalScore

        return MergeResultData(
            mergedPositions: Array(connectedGroup),
            newTilePosition: newTilePosition,
            scoreGained: totalScore,
            comboMultiplier: consecutiveComboCount
        )
    }

    // MARK: - Chain Reaction Detection

    func checkForChainReaction() -> GridPositionCoordinate? {
        for row in 0..<gridRowCount {
            for col in 0..<gridColumnCount {
                if gridMatrix[row][col] != nil {
                    let position = GridPositionCoordinate(rowIndex: row, columnIndex: col)
                    let connectedGroup = detectConnectedGroup(from: position)
                    if connectedGroup.count >= 3 {
                        return position
                    }
                }
            }
        }
        return nil
    }

    // MARK: - Game State Checks

    func isGridFull() -> Bool {
        for row in gridMatrix {
            for tile in row {
                if tile == nil {
                    return false
                }
            }
        }
        return true
    }

    func availableEmptySpaces() -> Int {
        var count = 0
        for row in gridMatrix {
            for tile in row {
                if tile == nil {
                    count += 1
                }
            }
        }
        return count
    }
}

// MARK: - Data Structures

struct MergeResultData {
    let mergedPositions: [GridPositionCoordinate]
    let newTilePosition: GridPositionCoordinate?
    let scoreGained: Int
    let comboMultiplier: Int
}
