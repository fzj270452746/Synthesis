//
//  UserDefaultsPersistenceAdapter.swift
//  Synthesis - Infrastructure Storage
//
//  UserDefaults-backed storage medium implementation.
//  Provides synchronous persistence for small data entities.
//

import Foundation

class UserDefaultsPersistenceAdapter: StorageMediumProtocol {

    // MARK: - Properties

    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder

    // MARK: - Initialization

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        self.jsonEncoder = JSONEncoder()
        self.jsonEncoder.dateEncodingStrategy = .iso8601

        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.dateDecodingStrategy = .iso8601
    }

    // MARK: - StorageMediumProtocol

    func inscribe<T: Codable>(_ entity: T, forKey key: String) async throws {
        do {
            let encodedData = try jsonEncoder.encode(entity)
            userDefaults.set(encodedData, forKey: key)
            userDefaults.synchronize()
        } catch {
            throw StorageMediumError.encodingFailure(underlyingError: error)
        }
    }

    func retrieve<T: Codable>(forKey key: String, as type: T.Type) async throws -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }

        do {
            let entity = try jsonDecoder.decode(type, from: data)
            return entity
        } catch {
            throw StorageMediumError.decodingFailure(underlyingError: error)
        }
    }

    func eradicate(forKey key: String) async throws {
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }

    func entityExists(forKey key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }

    func obliterateAll() async throws {
        guard let domainName = Bundle.main.bundleIdentifier else {
            return
        }
        userDefaults.removePersistentDomain(forName: domainName)
        userDefaults.synchronize()
    }
}

// MARK: - Synchronous Convenience Methods

extension UserDefaultsPersistenceAdapter {

    /// Synchronous inscription for simple use cases
    func inscribeSynchronously<T: Codable>(_ entity: T, forKey key: String) throws {
        do {
            let encodedData = try jsonEncoder.encode(entity)
            userDefaults.set(encodedData, forKey: key)
            userDefaults.synchronize()
        } catch {
            throw StorageMediumError.encodingFailure(underlyingError: error)
        }
    }

    /// Synchronous retrieval for simple use cases
    func retrieveSynchronously<T: Codable>(forKey key: String, as type: T.Type) throws -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }

        do {
            let entity = try jsonDecoder.decode(type, from: data)
            return entity
        } catch {
            throw StorageMediumError.decodingFailure(underlyingError: error)
        }
    }
}
