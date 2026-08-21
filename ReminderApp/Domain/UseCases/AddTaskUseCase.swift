//
//  AddTaskUseCase.swift
//  ReminderApp · Domain
//
//  TUGAS
//  Aturan bisnis pembuatan task: trim judul, tolak judul kosong, tolak dueDate lampau.
//  Kalau lolos: simpan lewat repository, lalu jadwalkan reminder lewat scheduler.
//
//  PERAN DI SOLID
//  • SRP — hanya aturan bisnis. Menyimpan milik Repository,
//    menjadwalkan milik Scheduler.
//  • DIP — kedua dependency masuk lewat init() sebagai protocol.
//
import Foundation

enum ValidationError: Error, Equatable {
    case emptyTitle
    case pastDueDate
}

struct AddTaskUseCase {
    private let repository: TaskRepositoryProtocol
    private let scheduler: NotificationSchedulerProtocol

    init(repository: TaskRepositoryProtocol, scheduler: NotificationSchedulerProtocol) {
        self.repository = repository
        self.scheduler = scheduler
    }

    func execute(title: String, dueDate: Date) async throws -> ReminderTask {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            throw ValidationError.emptyTitle
        }
        guard dueDate >= Date() else {
            throw ValidationError.pastDueDate
        }

        let task = ReminderTask(title: trimmedTitle, dueDate: dueDate)
        try repository.save(task)
        try await scheduler.schedule(for: task)
        return task
    }
}
