//
//  ChronicleArchiveRepository.swift
//  Synthesis - Infrastructure Repository
//
//  Repository for persisting triumph chronicle records.
//  Maintains top 50 leaderboard with automatic ranking.
//

import Foundation

class ChronicleArchiveRepository: RepositoryProtocol {

    typealias Entity = TriumphChronicle

    // MARK: - Properties

    private let storageMedium: StorageMediumProtocol
    private let vaultKey = "triumphChronicleVault"
    private let maximumArchiveCapacity = 50

    // MARK: - Initialization

    init(storageMedium: StorageMediumProtocol = UserDefaultsPersistenceAdapter()) {
        self.storageMedium = storageMedium
    }

    // MARK: - RepositoryProtocol

    func persistEntity(_ entity: TriumphChronicle) async throws {
        var existingChronicles = try await retrieveAllEntities()
        existingChronicles.append(entity)

        // Sort by score descending (Comparable implementation)
        let rankedChronicles = existingChronicles.sorted()

        // Limit to maximum capacity
        let curatedChronicles = Array(rankedChronicles.prefix(maximumArchiveCapacity))

        try await storageMedium.inscribe(curatedChronicles, forKey: vaultKey)
    }

    func retrieveAllEntities() async throws -> [TriumphChronicle] {
        guard let chronicles = try await storageMedium.retrieve(
            forKey: vaultKey,
            as: [TriumphChronicle].self
        ) else {
            return []
        }
        return chronicles
    }

    func eradicateEntity(_ entity: TriumphChronicle) async throws {
        var chronicles = try await retrieveAllEntities()
        chronicles.removeAll { $0 == entity }
        try await storageMedium.inscribe(chronicles, forKey: vaultKey)
    }

    func eradicateAllEntities() async throws {
        try await storageMedium.eradicate(forKey: vaultKey)
    }

    // MARK: - Specialized Queries

    /// Retrieves top N chronicles
    func retrieveTopChronicles(limit: Int) async throws -> [TriumphChronicle] {
        let allChronicles = try await retrieveAllEntities()
        return Array(allChronicles.prefix(limit))
    }

    /// Retrieves chronicles for specific difficulty
    func retrieveChronicles(forEchelon echelon: DifficultyEchelon) async throws -> [TriumphChronicle] {
        return try await retrieveEntities { chronicle in
            chronicle.difficultyEchelon == echelon
        }
    }

    /// Retrieves highest score
    func retrievePinnacleChronicle() async throws -> TriumphChronicle? {
        let chronicles = try await retrieveAllEntities()
        return chronicles.first // Already sorted
    }

    /// Validates if score qualifies for leaderboard
    func qualifiesForLeaderboard(merit: AccumulatedMerit) async throws -> Bool {
        let chronicles = try await retrieveAllEntities()

        // Always qualify if under capacity
        if chronicles.count < maximumArchiveCapacity {
            return true
        }

        // Check if score exceeds lowest ranked
        guard let lowestChronicle = chronicles.last else {
            return true
        }

        return merit > lowestChronicle.accumulatedMerit
    }
}

// MARK: - Synchronous Convenience (for backward compatibility)

extension ChronicleArchiveRepository {

    func persistEntitySynchronously(_ entity: TriumphChronicle) throws {
        guard let adapter = storageMedium as? UserDefaultsPersistenceAdapter else {
            return
        }

        var existingChronicles = (try? adapter.retrieveSynchronously(
            forKey: vaultKey,
            as: [TriumphChronicle].self
        )) ?? []

        existingChronicles.append(entity)
        let rankedChronicles = existingChronicles.sorted()
        let curatedChronicles = Array(rankedChronicles.prefix(maximumArchiveCapacity))

        try adapter.inscribeSynchronously(curatedChronicles, forKey: vaultKey)
    }

    func retrieveAllEntitiesSynchronously() throws -> [TriumphChronicle] {
        guard let adapter = storageMedium as? UserDefaultsPersistenceAdapter else {
            return []
        }

        return (try? adapter.retrieveSynchronously(
            forKey: vaultKey,
            as: [TriumphChronicle].self
        )) ?? []
    }

    func eradicateAllEntitiesSynchronously() throws {
        guard let adapter = storageMedium as? UserDefaultsPersistenceAdapter else {
            return
        }

        try adapter.inscribeSynchronously([TriumphChronicle](), forKey: vaultKey)
    }
}
