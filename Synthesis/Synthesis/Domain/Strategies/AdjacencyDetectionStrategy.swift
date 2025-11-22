//
//  AdjacencyDetectionStrategy.swift
//  Synthesis - Domain Strategy
//
//  Defines strategy protocol for detecting adjacent congruent token clusters.
//  Enables interchangeable algorithms (DFS, BFS, Flood Fill).
//

import Foundation

protocol AdjacencyDetectionStrategy {
    /// Excavates cluster of congruent fragments adjacent to origin
    func excavateCongruentCluster(
        origin: LatticeCoordinate,
        lattice: TessellationMatrix
    ) -> Set<LatticeCoordinate>
}

// MARK: - Depth-First Exploration Strategy

class DepthFirstExplorationStrategy: AdjacencyDetectionStrategy {

    func excavateCongruentCluster(
        origin: LatticeCoordinate,
        lattice: TessellationMatrix
    ) -> Set<LatticeCoordinate> {

        guard let originFragment = lattice.retrieveFragment(at: origin) else {
            return []
        }

        var discoveredNodes = Set<LatticeCoordinate>()
        var expeditionFrontier = [origin]

        while let currentNode = expeditionFrontier.popLast() {
            // Skip if already discovered
            guard !discoveredNodes.contains(currentNode) else {
                continue
            }

            // Verify fragment exists and matches origin magnitude
            guard let currentFragment = lattice.retrieveFragment(at: currentNode),
                  currentFragment.possessesIdenticalMagnitude(with: originFragment) else {
                continue
            }

            // Mark as discovered
            discoveredNodes.insert(currentNode)

            // Explore cardinal neighbors
            for compassBearing in LatticeCoordinate.CompassBearing.allCases {
                let adjacentNode = currentNode.navigateAlong(bearing: compassBearing)

                // Validate boundaries and undiscovered status
                if adjacentNode.residesWithinBoundaries(
                    rows: lattice.dimensionalCapacity,
                    columns: lattice.dimensionalCapacity
                ), !discoveredNodes.contains(adjacentNode) {
                    expeditionFrontier.append(adjacentNode)
                }
            }
        }

        return discoveredNodes
    }
}

// MARK: - Breadth-First Exploration Strategy

class BreadthFirstExplorationStrategy: AdjacencyDetectionStrategy {

    func excavateCongruentCluster(
        origin: LatticeCoordinate,
        lattice: TessellationMatrix
    ) -> Set<LatticeCoordinate> {

        guard let originFragment = lattice.retrieveFragment(at: origin) else {
            return []
        }

        var discoveredNodes = Set<LatticeCoordinate>()
        var expeditionQueue = [origin]
        var queueIndex = 0

        while queueIndex < expeditionQueue.count {
            let currentNode = expeditionQueue[queueIndex]
            queueIndex += 1

            // Skip if already discovered
            guard !discoveredNodes.contains(currentNode) else {
                continue
            }

            // Verify fragment matches origin
            guard let currentFragment = lattice.retrieveFragment(at: currentNode),
                  currentFragment.possessesIdenticalMagnitude(with: originFragment) else {
                continue
            }

            // Mark as discovered
            discoveredNodes.insert(currentNode)

            // Enqueue cardinal neighbors
            for adjacentNode in currentNode.excavateAdjacentCoordinates() {
                if adjacentNode.residesWithinBoundaries(
                    rows: lattice.dimensionalCapacity,
                    columns: lattice.dimensionalCapacity
                ), !discoveredNodes.contains(adjacentNode) {
                    expeditionQueue.append(adjacentNode)
                }
            }
        }

        return discoveredNodes
    }
}

// MARK: - Recursive Flood Fill Strategy

class RecursiveFloodFillStrategy: AdjacencyDetectionStrategy {

    func excavateCongruentCluster(
        origin: LatticeCoordinate,
        lattice: TessellationMatrix
    ) -> Set<LatticeCoordinate> {

        guard let originFragment = lattice.retrieveFragment(at: origin) else {
            return []
        }

        var discoveredNodes = Set<LatticeCoordinate>()

        recursivelyExplore(
            coordinate: origin,
            targetMagnitude: originFragment.hierarchicalMagnitude,
            lattice: lattice,
            discovered: &discoveredNodes
        )

        return discoveredNodes
    }

    private func recursivelyExplore(
        coordinate: LatticeCoordinate,
        targetMagnitude: Int,
        lattice: TessellationMatrix,
        discovered: inout Set<LatticeCoordinate>
    ) {
        // Boundary validation
        guard coordinate.residesWithinBoundaries(
            rows: lattice.dimensionalCapacity,
            columns: lattice.dimensionalCapacity
        ) else {
            return
        }

        // Skip if already discovered
        guard !discovered.contains(coordinate) else {
            return
        }

        // Validate fragment magnitude matches target
        guard let fragment = lattice.retrieveFragment(at: coordinate),
              fragment.hierarchicalMagnitude == targetMagnitude else {
            return
        }

        // Mark as discovered
        discovered.insert(coordinate)

        // Recursively explore neighbors
        for compassBearing in LatticeCoordinate.CompassBearing.allCases {
            let adjacentCoordinate = coordinate.navigateAlong(bearing: compassBearing)
            recursivelyExplore(
                coordinate: adjacentCoordinate,
                targetMagnitude: targetMagnitude,
                lattice: lattice,
                discovered: &discovered
            )
        }
    }
}
