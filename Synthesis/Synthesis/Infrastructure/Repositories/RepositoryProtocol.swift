//
//  RepositoryProtocol.swift
//  Synthesis - Infrastructure Repository
//
//  Generic repository protocol for entity persistence operations.
//  Provides CRUD interface abstraction.
//

import Foundation

protocol RepositoryProtocol {
    associatedtype Entity: Codable & Equatable

    /// Persists entity to repository
    func persistEntity(_ entity: Entity) async throws

    /// Persists multiple entities
    func persistEntities(_ entities: [Entity]) async throws

    /// Retrieves all entities from repository
    func retrieveAllEntities() async throws -> [Entity]

    /// Retrieves entity matching predicate
    func retrieveEntities(matching predicate: (Entity) -> Bool) async throws -> [Entity]

    /// Eradicates specific entity
    func eradicateEntity(_ entity: Entity) async throws

    /// Eradicates all entities
    func eradicateAllEntities() async throws

    /// Counts total entities
    func countEntities() async throws -> Int
}

// MARK: - Default Implementations

extension RepositoryProtocol {

    func persistEntities(_ entities: [Entity]) async throws {
        for entity in entities {
            try await persistEntity(entity)
        }
    }

    func retrieveEntities(matching predicate: (Entity) -> Bool) async throws -> [Entity] {
        let allEntities = try await retrieveAllEntities()
        return allEntities.filter(predicate)
    }

    func countEntities() async throws -> Int {
        let entities = try await retrieveAllEntities()
        return entities.count
    }
}
