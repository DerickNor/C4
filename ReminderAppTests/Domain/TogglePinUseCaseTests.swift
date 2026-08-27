//
//  TogglePinUseCaseTests.swift
//  ReminderApp · Tests · Domain
//
//  TUGAS
//  Pin membalik nilai, unpin mengembalikannya, dan title/dueDate/isCompleted tidak ikut berubah.
//
//  PERAN DI SOLID
//  • DIP — berjalan penuh di atas MockTaskRepository.
//  • SRP — bagian 'field lain tidak berubah' inilah yang paling mudah rusak diam-diam.
//
//  Status: TDD 🔴 — ditulis sebelum TogglePinUseCase asli ada, jadi harus
//  merah dulu (fatalError) sebelum TASK-014 mengisi logic-nya sampai hijau.

import Foundation
@testable import ReminderApp
import Testing

struct TogglePinUseCaseTests {
    @Test
    func `Pin task: isPinned jadi true, field lain tidak berubah`() throws {
        let repository = MockTaskRepository()
        let sut = TogglePinUseCase(repository: repository)
        let original = ReminderTask(title: "Bayar listrik", dueDate: Date().addingTimeInterval(3600), isPinned: false)

        try sut.execute(original)

        var expected = original
        expected.isPinned = true
        #expect(try repository.fetchAll() == [expected])
    }

    @Test
    func `Unpin task: isPinned jadi false, field lain tidak berubah`() throws {
        let repository = MockTaskRepository()
        let sut = TogglePinUseCase(repository: repository)
        let original = ReminderTask(title: "Bayar listrik", dueDate: Date().addingTimeInterval(3600), isPinned: true)

        try sut.execute(original)

        var expected = original
        expected.isPinned = false
        #expect(try repository.fetchAll() == [expected])
    }

    @Test
    func `title, dueDate, dan isCompleted tidak berubah setelah toggle`() throws {
        let repository = MockTaskRepository()
        let sut = TogglePinUseCase(repository: repository)
        let dueDate = Date().addingTimeInterval(7200)
        let original = ReminderTask(title: "Rapat tim", dueDate: dueDate, isPinned: false, isCompleted: true)

        try sut.execute(original)

        let stored = try repository.fetchAll().first
        #expect(stored?.title == "Rapat tim")
        #expect(stored?.dueDate == dueDate)
        #expect(stored?.isCompleted == true)
    }
}
