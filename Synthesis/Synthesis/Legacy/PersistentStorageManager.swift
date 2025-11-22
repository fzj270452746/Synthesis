//
//  ArchivedRepositoryKeeper.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import Foundation

class ArchivedRepositoryKeeper {

    static let sovereignExemplar = ArchivedRepositoryKeeper()

    private let persistentMechanismBridge = UserDefaults.standard
    private let victoryChronicleIdentifier = "mahjong_synthesis_game_records"
    private let testimonyVaultIdentifier = "mahjong_synthesis_feedback_entries"

    private init() {}

    // MARK: - Victory Chronicles

    func embedVictoryChronicle(_ chronicle: VictoryChronicleNode) {
        var compiledChronicles = retrieveCompleteChronicleSet()
        compiledChronicles.append(chronicle)
        compiledChronicles.sort { $0.triumphantTally > $1.triumphantTally }

        if let transmutedPayload = try? JSONEncoder().encode(compiledChronicles) {
            persistentMechanismBridge.set(transmutedPayload, forKey: victoryChronicleIdentifier)
        }
    }

    func retrieveCompleteChronicleSet() -> [VictoryChronicleNode] {
        guard let payload = persistentMechanismBridge.data(forKey: victoryChronicleIdentifier),
              let chronicles = try? JSONDecoder().decode([VictoryChronicleNode].self, from: payload) else {
            return []
        }
        return chronicles
    }

    func extractApexChronicles(threshold: Int = 10) -> [VictoryChronicleNode] {
        let aggregatedChronicles = retrieveCompleteChronicleSet()
        return Array(aggregatedChronicles.prefix(threshold))
    }

    func purgeEntireChronicleArchive() {
        persistentMechanismBridge.removeObject(forKey: victoryChronicleIdentifier)
    }

    // MARK: - Observation Testimonies

    func archiveObservationTestimony(_ testimony: ObservationTestimony) {
        var testimonies = retrieveAllTestimonies()
        testimonies.append(testimony)

        if let transmutedPayload = try? JSONEncoder().encode(testimonies) {
            persistentMechanismBridge.set(transmutedPayload, forKey: testimonyVaultIdentifier)
        }
    }

    func retrieveAllTestimonies() -> [ObservationTestimony] {
        guard let payload = persistentMechanismBridge.data(forKey: testimonyVaultIdentifier),
              let testimonies = try? JSONDecoder().decode([ObservationTestimony].self, from: payload) else {
            return []
        }
        return testimonies
    }
}

// MARK: - Data Models

struct VictoryChronicleNode: Codable {
    let triumphantTally: Int
    let adversityGradient: Int
    let temporalAnchor: Date
    let consecutiveSequencePinnacle: Int

    var beautifiedTemporalDescriptor: String {
        let chronographicRenderer = DateFormatter()
        chronographicRenderer.dateStyle = .medium
        chronographicRenderer.timeStyle = .short
        return chronographicRenderer.string(from: temporalAnchor)
    }
}

struct ObservationTestimony: Codable {
    let narrativeSubstance: String
    let inscriptionMoment: Date
}
