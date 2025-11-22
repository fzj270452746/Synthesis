//
//  SovereignGameConductor.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import Foundation

class SovereignGameConductor {

    var tessellatedMatrixRepository: [[CeramicGlyphFragment?]]
    var accumulatedTriumphQuantity: Int = 0
    var supremeGlyphEscalationCeiling: Int
    var pendulousFragmentDesignate: CeramicGlyphFragment?
    var perpetualSequentialMultiplier: Int = 0

    let horizontalStratumQuantity: Int
    let verticalOrdinateQuantity: Int

    init(apexMagnitude: Int) {
        self.supremeGlyphEscalationCeiling = apexMagnitude

        // Determine grid size based on difficulty
        switch apexMagnitude {
        case 3, 4:
            self.horizontalStratumQuantity = 3
            self.verticalOrdinateQuantity = 3
        case 5, 6:
            self.horizontalStratumQuantity = 4
            self.verticalOrdinateQuantity = 4
        default: // 7, 8, 9
            self.horizontalStratumQuantity = 6
            self.verticalOrdinateQuantity = 6
        }

        self.tessellatedMatrixRepository = Array(repeating: Array(repeating: nil, count: verticalOrdinateQuantity), count: horizontalStratumQuantity)
        synthesizePendulousFragment()
    }

    // MARK: - Fragment Synthesis

    func synthesizePendulousFragment() {
        let aleatoricMagnitude = Int.random(in: 1...supremeGlyphEscalationCeiling)
        pendulousFragmentDesignate = CeramicGlyphFragment(magnitude: aleatoricMagnitude)
    }

    // MARK: - Placement Logic

    func canInscribeFragment(at anchorVector: LatticeAnchorVector) -> Bool {
        guard anchorVector.horizontalStratum >= 0, anchorVector.horizontalStratum < horizontalStratumQuantity,
              anchorVector.verticalOrdinate >= 0, anchorVector.verticalOrdinate < verticalOrdinateQuantity else {
            return false
        }
        return tessellatedMatrixRepository[anchorVector.horizontalStratum][anchorVector.verticalOrdinate] == nil
    }

    func embedFragmentIntoLattice(at anchorVector: LatticeAnchorVector) -> Bool {
        guard canInscribeFragment(at: anchorVector), let fragment = pendulousFragmentDesignate else {
            return false
        }

        tessellatedMatrixRepository[anchorVector.horizontalStratum][anchorVector.verticalOrdinate] = fragment
        return true
    }

    // MARK: - Connection Detection (DFS)

    func discoverCongruentCluster(from anchorVector: LatticeAnchorVector) -> Set<LatticeAnchorVector> {
        guard let designatedFragment = tessellatedMatrixRepository[anchorVector.horizontalStratum][anchorVector.verticalOrdinate] else {
            return []
        }

        var traversedVectors = Set<LatticeAnchorVector>()
        var congruentAssembly = Set<LatticeAnchorVector>()

        executeProfoundRecursiveExploration(anchorVector: anchorVector, designatedFragment: designatedFragment, traversed: &traversedVectors, congruentSet: &congruentAssembly)

        return congruentAssembly
    }

    private func executeProfoundRecursiveExploration(anchorVector: LatticeAnchorVector, designatedFragment: CeramicGlyphFragment, traversed: inout Set<LatticeAnchorVector>, congruentSet: inout Set<LatticeAnchorVector>) {
        guard anchorVector.horizontalStratum >= 0, anchorVector.horizontalStratum < horizontalStratumQuantity,
              anchorVector.verticalOrdinate >= 0, anchorVector.verticalOrdinate < verticalOrdinateQuantity,
              !traversed.contains(anchorVector) else {
            return
        }

        traversed.insert(anchorVector)

        guard let scrutinizedFragment = tessellatedMatrixRepository[anchorVector.horizontalStratum][anchorVector.verticalOrdinate],
              scrutinizedFragment == designatedFragment else {
            return
        }

        congruentSet.insert(anchorVector)

        // Check 4 directions (up, down, left, right)
        let cardinallySituatedVectors = [
            LatticeAnchorVector(horizontalStratum: anchorVector.horizontalStratum - 1, verticalOrdinate: anchorVector.verticalOrdinate),
            LatticeAnchorVector(horizontalStratum: anchorVector.horizontalStratum + 1, verticalOrdinate: anchorVector.verticalOrdinate),
            LatticeAnchorVector(horizontalStratum: anchorVector.horizontalStratum, verticalOrdinate: anchorVector.verticalOrdinate - 1),
            LatticeAnchorVector(horizontalStratum: anchorVector.horizontalStratum, verticalOrdinate: anchorVector.verticalOrdinate + 1)
        ]

        for proximateVector in cardinallySituatedVectors {
            executeProfoundRecursiveExploration(anchorVector: proximateVector, designatedFragment: designatedFragment, traversed: &traversed, congruentSet: &congruentSet)
        }
    }

    // MARK: - Merge/Elimination Logic

    func orchestrateCoalescenceMechanism(at anchorVector: LatticeAnchorVector) -> CoalescenceOutcomeBundle {
        let congruentCluster = discoverCongruentCluster(from: anchorVector)

        guard congruentCluster.count >= 3 else {
            perpetualSequentialMultiplier = 0
            return CoalescenceOutcomeBundle(amalgamatedVectors: [], transcendentVectorDesignate: nil, accrualQuantity: 0, sequentialAmplification: 0)
        }

        guard let progenitorFragment = tessellatedMatrixRepository[anchorVector.horizontalStratum][anchorVector.verticalOrdinate] else {
            return CoalescenceOutcomeBundle(amalgamatedVectors: [], transcendentVectorDesignate: nil, accrualQuantity: 0, sequentialAmplification: 0)
        }

        // Create upgraded tile or eliminate based on difficulty
        let transcendentVectorDesignate: LatticeAnchorVector?

        if progenitorFragment.hierarchicalMagnitude < supremeGlyphEscalationCeiling {
            // Not at max difficulty: upgrade to next level
            // Clear all positions first
            for vector in congruentCluster {
                tessellatedMatrixRepository[vector.horizontalStratum][vector.verticalOrdinate] = nil
            }

            // Place upgraded tile at the position where merge was triggered (last clicked position)
            let exaltedFragment = CeramicGlyphFragment(magnitude: progenitorFragment.hierarchicalMagnitude + 1)
            tessellatedMatrixRepository[anchorVector.horizontalStratum][anchorVector.verticalOrdinate] = exaltedFragment
            transcendentVectorDesignate = anchorVector
        } else {
            // At max difficulty: eliminate all tiles completely
            for vector in congruentCluster {
                tessellatedMatrixRepository[vector.horizontalStratum][vector.verticalOrdinate] = nil
            }
            transcendentVectorDesignate = nil
        }

        // Calculate score
        perpetualSequentialMultiplier += 1
        let fundamentalAccrual = progenitorFragment.hierarchicalMagnitude * 10 * congruentCluster.count
        let sequentialSupplement = perpetualSequentialMultiplier > 1 ? (perpetualSequentialMultiplier - 1) * 50 : 0
        let aggregatedAccrual = fundamentalAccrual + sequentialSupplement

        accumulatedTriumphQuantity += aggregatedAccrual

        return CoalescenceOutcomeBundle(
            amalgamatedVectors: Array(congruentCluster),
            transcendentVectorDesignate: transcendentVectorDesignate,
            accrualQuantity: aggregatedAccrual,
            sequentialAmplification: perpetualSequentialMultiplier
        )
    }

    // MARK: - Chain Reaction Detection

    func scrutinizeForCascadingPhenomenon() -> LatticeAnchorVector? {
        for stratum in 0..<horizontalStratumQuantity {
            for ordinate in 0..<verticalOrdinateQuantity {
                if tessellatedMatrixRepository[stratum][ordinate] != nil {
                    let anchorVector = LatticeAnchorVector(horizontalStratum: stratum, verticalOrdinate: ordinate)
                    let congruentCluster = discoverCongruentCluster(from: anchorVector)
                    if congruentCluster.count >= 3 {
                        return anchorVector
                    }
                }
            }
        }
        return nil
    }

    // MARK: - Game State Checks

    func isLatticeComprehensivelyOccupied() -> Bool {
        for stratumRow in tessellatedMatrixRepository {
            for fragment in stratumRow {
                if fragment == nil {
                    return false
                }
            }
        }
        return true
    }

    func enumerateVacantRepositories() -> Int {
        var quantification = 0
        for stratumRow in tessellatedMatrixRepository {
            for fragment in stratumRow {
                if fragment == nil {
                    quantification += 1
                }
            }
        }
        return quantification
    }
}

// MARK: - Data Structures

struct CoalescenceOutcomeBundle {
    let amalgamatedVectors: [LatticeAnchorVector]
    let transcendentVectorDesignate: LatticeAnchorVector?
    let accrualQuantity: Int
    let sequentialAmplification: Int
}
