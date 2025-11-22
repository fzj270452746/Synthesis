//
//  ChronicleHistorianService.swift
//  Synthesis - Domain Service
//
//  Manages command history for undo/redo and replay functionality.
//  Maintains chronological record of all executed directives.
//

import Foundation

class ChronicleHistorianService {

    // MARK: - Properties

    /// Chronological archive of executed directives
    private var directiveArchive: [DirectiveProtocol] = []

    /// Current position in archive for undo/redo
    private var archiveNavigationIndex: Int = 0

    /// Maximum archive capacity
    private let maximumArchiveCapacity: Int

    // MARK: - Initialization

    init(maximumCapacity: Int = 1000) {
        self.maximumArchiveCapacity = maximumCapacity
    }

    // MARK: - Archival Operations

    /// Archives executed directive
    func archiveDirective(_ directive: DirectiveProtocol) {
        // Remove any directives ahead of current index (invalidated by new action)
        if archiveNavigationIndex < directiveArchive.count {
            directiveArchive.removeSubrange(archiveNavigationIndex...)
        }

        // Append new directive
        directiveArchive.append(directive)
        archiveNavigationIndex = directiveArchive.count

        // Enforce capacity limit
        if directiveArchive.count > maximumArchiveCapacity {
            let excessQuantity = directiveArchive.count - maximumArchiveCapacity
            directiveArchive.removeFirst(excessQuantity)
            archiveNavigationIndex = directiveArchive.count
        }
    }

    /// Retrieves directive at specified index
    func retrieveDirective(at index: Int) -> DirectiveProtocol? {
        guard index >= 0, index < directiveArchive.count else {
            return nil
        }
        return directiveArchive[index]
    }

    /// Retrieves all archived directives
    func retrieveCompleteArchive() -> [DirectiveProtocol] {
        return directiveArchive
    }

    // MARK: - Undo/Redo

    /// Determines if undo operation is available
    var canReverseExecution: Bool {
        return archiveNavigationIndex > 0
    }

    /// Determines if redo operation is available
    var canReplayExecution: Bool {
        return archiveNavigationIndex < directiveArchive.count
    }

    /// Retrieves directive for undo operation
    func retrieveDirectiveForReversal() -> DirectiveProtocol? {
        guard canReverseExecution else { return nil }
        archiveNavigationIndex -= 1
        return directiveArchive[archiveNavigationIndex]
    }

    /// Retrieves directive for redo operation
    func retrieveDirectiveForReplay() -> DirectiveProtocol? {
        guard canReplayExecution else { return nil }
        let directive = directiveArchive[archiveNavigationIndex]
        archiveNavigationIndex += 1
        return directive
    }

    // MARK: - History Management

    /// Obliterates all archived directives
    func obliterateArchive() {
        directiveArchive.removeAll()
        archiveNavigationIndex = 0
    }

    /// Retrieves archive metadata
    var archiveMetadata: (total: Int, currentIndex: Int) {
        return (directiveArchive.count, archiveNavigationIndex)
    }

    /// Exports archive for replay/debugging
    func exportArchiveDescriptions() -> [String] {
        return directiveArchive.enumerated().map { index, directive in
            let marker = index < archiveNavigationIndex ? "✓" : "○"
            return "\(marker) [\(index)] \(directive.classification.rawValue) @ \(directive.temporalInscription)"
        }
    }
}

// MARK: - CustomStringConvertible

extension ChronicleHistorianService: CustomStringConvertible {
    var description: String {
        return "ChronicleHistorian(archived: \(directiveArchive.count), index: \(archiveNavigationIndex))"
    }
}
