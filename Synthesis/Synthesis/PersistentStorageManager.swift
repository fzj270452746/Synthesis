//
//  PersistentStorageManager.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import Foundation

class PersistentStorageManager {

    static let sharedInstance = PersistentStorageManager()

    private let userDefaultsInterface = UserDefaults.standard
    private let gameRecordsKey = "mahjong_synthesis_game_records"
    private let feedbackEntriesKey = "mahjong_synthesis_feedback_entries"

    private init() {}

    // MARK: - Game Records

    func saveGameRecord(_ record: GameRecordEntry) {
        var records = fetchAllGameRecords()
        records.append(record)
        records.sort { $0.achievedScore > $1.achievedScore }

        if let encodedData = try? JSONEncoder().encode(records) {
            userDefaultsInterface.set(encodedData, forKey: gameRecordsKey)
        }
    }

    func fetchAllGameRecords() -> [GameRecordEntry] {
        guard let data = userDefaultsInterface.data(forKey: gameRecordsKey),
              let records = try? JSONDecoder().decode([GameRecordEntry].self, from: data) else {
            return []
        }
        return records
    }

    func fetchTopGameRecords(limit: Int = 10) -> [GameRecordEntry] {
        let allRecords = fetchAllGameRecords()
        return Array(allRecords.prefix(limit))
    }

    func clearAllGameRecords() {
        userDefaultsInterface.removeObject(forKey: gameRecordsKey)
    }

    // MARK: - Feedback

    func saveFeedbackEntry(_ feedback: FeedbackEntry) {
        var feedbacks = fetchAllFeedback()
        feedbacks.append(feedback)

        if let encodedData = try? JSONEncoder().encode(feedbacks) {
            userDefaultsInterface.set(encodedData, forKey: feedbackEntriesKey)
        }
    }

    func fetchAllFeedback() -> [FeedbackEntry] {
        guard let data = userDefaultsInterface.data(forKey: feedbackEntriesKey),
              let feedbacks = try? JSONDecoder().decode([FeedbackEntry].self, from: data) else {
            return []
        }
        return feedbacks
    }
}

// MARK: - Data Models

struct GameRecordEntry: Codable {
    let achievedScore: Int
    let selectedDifficulty: Int
    let timestampDate: Date
    let maximumCombo: Int

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestampDate)
    }
}

struct FeedbackEntry: Codable {
    let feedbackContent: String
    let submissionDate: Date
}
