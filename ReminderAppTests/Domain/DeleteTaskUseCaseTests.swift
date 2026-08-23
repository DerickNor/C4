//
//  DeleteTaskUseCaseTests.swift
//  ReminderApp · Tests · Domain
//
//  TUGAS
//  Task benar-benar terhapus, DAN cancel tercatat sebelum delete.
//  Menguji urutan, bukan sekadar 'keduanya terpanggil'.
//
//  PERAN DI SOLID
//  • DIP — urutan dibaca dari catatan milik Mock.
//    Tanpa protocol, urutan ini mustahil diperiksa dari luar.
//
//  Status: TDD 🔴 — ditulis sebelum DeleteTaskUseCase asli ada, jadi harus
//  merah dulu (fatalError) sebelum TASK-016 mengisi logic-nya sampai hijau.

import Testing
import Foundation
@testable import ReminderApp

struct DeleteTaskUseCaseTests {
    @Test("Task terhapus dari repository")
    func execute_removesTaskFromRepository() throws {
        let task = ReminderTask(title: "Bayar listrik", dueDate: Date().addingTimeInterval(3600))
        let repository = MockTaskRepository(tasks: [task])
        let scheduler = MockNotificationScheduler()
        let sut = DeleteTaskUseCase(repository: repository, scheduler: scheduler)

        try sut.execute(task)

        #expect(try repository.fetchAll().isEmpty)
    }

    // Log yang sama disuntik ke repository DAN scheduler — kalau
    // DeleteTaskUseCase membalik urutan (delete dulu, baru cancel),
    // log.entries akan berbeda dan test ini gagal.
    @Test("cancel tercatat sebelum delete di log bersama")
    func execute_cancelsBeforeDeleting() throws {
        let task = ReminderTask(title: "Bayar listrik", dueDate: Date().addingTimeInterval(3600))
        let log = MockCallLog()
        let repository = MockTaskRepository(tasks: [task], log: log)
        let scheduler = MockNotificationScheduler(log: log)
        let sut = DeleteTaskUseCase(repository: repository, scheduler: scheduler)

        try sut.execute(task)

        #expect(log.entries == [.cancel(task), .delete(task)])
    }
}
