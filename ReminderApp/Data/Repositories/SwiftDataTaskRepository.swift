//
//  SwiftDataTaskRepository.swift
//  ReminderApp · Data
//
//  TUGAS
//  Implementasi asli TaskRepositoryProtocol memakai SwiftData ModelContext.
//  Menerjemahkan lewat ReminderTaskRecord di setiap perbatasan.
//
//  PERAN DI SOLID
//  • LSP — wajib berperilaku sama persis dengan MockTaskRepository.
//  • SRP — hanya menyimpan dan mengambil, tidak memvalidasi apa pun.
//

import Foundation
import SwiftData

final class SwiftDataTaskRepository: TaskRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() throws -> [ReminderTask] {
        let descriptor = FetchDescriptor<ReminderTaskRecord>()
        return try modelContext.fetch(descriptor).map { $0.toDomain() }
    }

    func save(_ task: ReminderTask) throws {
        let taskID = task.id
        let descriptor = FetchDescriptor<ReminderTaskRecord>(
            predicate: #Predicate { $0.id == taskID }
        )
        if let existing = try modelContext.fetch(descriptor).first {
            existing.title = task.title
            existing.dueDate = task.dueDate
            existing.isPinned = task.isPinned
            existing.isCompleted = task.isCompleted
        } else {
            modelContext.insert(ReminderTaskRecord(from: task))
        }
        try modelContext.save()
    }

    func delete(_ task: ReminderTask) throws {
        let taskID = task.id
        let descriptor = FetchDescriptor<ReminderTaskRecord>(
            predicate: #Predicate { $0.id == taskID }
        )
        if let existing = try modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
            try modelContext.save()
        }
    }
}
