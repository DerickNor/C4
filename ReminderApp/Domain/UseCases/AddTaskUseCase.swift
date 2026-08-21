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
//  Status: stub TDD 🔴 — execute() belum diisi (fatalError), menunggu
//  AddTaskUseCaseTests jadi merah dulu sebelum logic aslinya ditulis.

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
        fatalError("not implemented")
    }
}
