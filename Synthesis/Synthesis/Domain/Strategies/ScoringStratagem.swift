//
//  ScoringStratagem.swift
//  Synthesis - Domain Strategy
//
//  Defines strategy protocol for calculating merit accumulation from consolidations.
//  Enables different scoring formulas and progression systems.
//

import Foundation

protocol ScoringStratagem {
    /// Calculates merit from consolidated cluster
    func calculateMeritAccumulation(
        consolidatedCluster: Set<LatticeCoordinate>,
        tokenMagnitude: Int,
        amplifierChain: SequentialAmplifier
    ) -> AccumulatedMerit
}

// MARK: - Standard Merit Calculator

class StandardMeritCalculator: ScoringStratagem {

    func calculateMeritAccumulation(
        consolidatedCluster: Set<LatticeCoordinate>,
        tokenMagnitude: Int,
        amplifierChain: SequentialAmplifier
    ) -> AccumulatedMerit {

        // Base merit: magnitude × 10 × cluster count
        let baseQuantity = tokenMagnitude * 10 * consolidatedCluster.count

        // Amplification bonus: (amplifier - 1) × 50
        let bonusQuantity = amplifierChain.calculateBonusMerit()

        return AccumulatedMerit(
            primary: baseQuantity,
            bonus: bonusQuantity
        )
    }
}

// MARK: - Exponential Merit Calculator

class ExponentialMeritCalculator: ScoringStratagem {

    private let baseMultiplier: Double = 10.0
    private let exponentialFactor: Double = 1.5

    func calculateMeritAccumulation(
        consolidatedCluster: Set<LatticeCoordinate>,
        tokenMagnitude: Int,
        amplifierChain: SequentialAmplifier
    ) -> AccumulatedMerit {

        // Exponential scaling: magnitude^1.5 × 10 × count
        let exponentialValue = pow(Double(tokenMagnitude), exponentialFactor)
        let baseQuantity = Int(exponentialValue * baseMultiplier) * consolidatedCluster.count

        // Enhanced amplification bonus
        let bonusQuantity = amplifierChain.calculateBonusMerit() * 2

        return AccumulatedMerit(
            primary: baseQuantity,
            bonus: bonusQuantity
        )
    }
}

// MARK: - Progressive Merit Calculator

class ProgressiveMeritCalculator: ScoringStratagem {

    func calculateMeritAccumulation(
        consolidatedCluster: Set<LatticeCoordinate>,
        tokenMagnitude: Int,
        amplifierChain: SequentialAmplifier
    ) -> AccumulatedMerit {

        // Progressive scaling based on cluster size
        let clusterSize = consolidatedCluster.count
        let sizeMultiplier: Int

        switch clusterSize {
        case 3...4:
            sizeMultiplier = 1
        case 5...6:
            sizeMultiplier = 2
        case 7...9:
            sizeMultiplier = 3
        default:
            sizeMultiplier = 4
        }

        let baseQuantity = tokenMagnitude * 10 * clusterSize * sizeMultiplier

        // Standard amplification bonus
        let bonusQuantity = amplifierChain.calculateBonusMerit()

        return AccumulatedMerit(
            primary: baseQuantity,
            bonus: bonusQuantity
        )
    }
}

// MARK: - Cascade Bonus Calculator

class CascadeBonusMeritCalculator: ScoringStratagem {

    func calculateMeritAccumulation(
        consolidatedCluster: Set<LatticeCoordinate>,
        tokenMagnitude: Int,
        amplifierChain: SequentialAmplifier
    ) -> AccumulatedMerit {

        // Standard base calculation
        let baseQuantity = tokenMagnitude * 10 * consolidatedCluster.count

        // Cascade multiplier increases with combo
        let cascadeMultiplier = amplifierChain.amplitudeMagnitude
        let enhancedBonus = (cascadeMultiplier - 1) * 50 * cascadeMultiplier

        return AccumulatedMerit(
            primary: baseQuantity,
            bonus: enhancedBonus
        )
    }
}
