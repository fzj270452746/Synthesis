//
//  StorageMediumProtocol.swift
//  Synthesis - Infrastructure Storage
//
//  Protocol abstraction for storage medium implementations.
//  Enables dependency injection and testability.
//

import Foundation

protocol StorageMediumProtocol {
    /// Inscribes codable entity to storage
    func inscribe<T: Codable>(_ entity: T, forKey key: String) async throws

    /// Retrieves codable entity from storage
    func retrieve<T: Codable>(forKey key: String, as type: T.Type) async throws -> T?

    /// Eradicates entity at specified key
    func eradicate(forKey key: String) async throws

    /// Validates entity existence
    func entityExists(forKey key: String) -> Bool

    /// Obliterates all stored entities
    func obliterateAll() async throws
}

// MARK: - Storage Errors

enum StorageMediumError: Error, LocalizedError {
    case encodingFailure(underlyingError: Error)
    case decodingFailure(underlyingError: Error)
    case entityNotFound(key: String)
    case inscriptionFailure(underlyingError: Error)
    case eradicationFailure(underlyingError: Error)

    var errorDescription: String? {
        switch self {
        case .encodingFailure(let error):
            return "Failed to encode entity: \(error.localizedDescription)"
        case .decodingFailure(let error):
            return "Failed to decode entity: \(error.localizedDescription)"
        case .entityNotFound(let key):
            return "Entity not found for key: \(key)"
        case .inscriptionFailure(let error):
            return "Failed to inscribe entity: \(error.localizedDescription)"
        case .eradicationFailure(let error):
            return "Failed to eradicate entity: \(error.localizedDescription)"
        }
    }
}
