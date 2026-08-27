//
//  AddTaskUseCaseTests.swift
//  ReminderApp · Tests · Domain
//
//  TUGAS
//  Enam kasus: judul kosong, judul spasi saja, trim spasi,
//  dueDate lampau, input valid tersimpan, dan reminder dijadwalkan tepat sekali.
//
//  PERAN DI SOLID
//  • DIP — ini bukti utamanya. Seluruh jalur berjalan hanya dengan Mock,
//    tanpa menyentuh SwiftData atau UNUserNotificationCenter sama sekali.
//
//  Status: TDD 🔴 — ditulis sebelum AddTaskUseCase asli ada, jadi harus
//  merah dulu (fatalError) sebelum TASK-012 mengisi logic-nya sampai hijau.
//
//  Pakai Swift Testing (import Testing), bukan XCTest.

import Foundation
@testable import ReminderApp
import Testing

struct AddTaskUseCaseTests {
    /// Instance baru tiap test lewat factory ini, bukan properti suite —
    /// supaya tiap @Test dapat Mock yang bersih dan terisolasi.
    private struct Environment {
        let sut: AddTaskUseCase
        let repository: MockTaskRepository
        let scheduler: MockNotificationScheduler
    }

    private func makeSUT() -> Environment {
        let repository = MockTaskRepository()
        let scheduler = MockNotificationScheduler()
        let sut = AddTaskUseCase(repository: repository, scheduler: scheduler)
        return Environment(sut: sut, repository: repository, scheduler: scheduler)
    }

    @Test
    func `Judul kosong throw emptyTitle, tidak menyimpan, tidak menjadwalkan`() async throws {
        let env = makeSUT()
        await #expect(throws: ValidationError.emptyTitle) {
            _ = try await env.sut.execute(title: "", dueDate: Date().addingTimeInterval(3600))
        }
        #expect(try env.repository.fetchAll().isEmpty)
        #expect(env.scheduler.calls.isEmpty)
    }

    @Test
    func `Judul spasi saja throw emptyTitle`() async throws {
        let env = makeSUT()
        await #expect(throws: ValidationError.emptyTitle) {
            _ = try await env.sut.execute(title: "   ", dueDate: Date().addingTimeInterval(3600))
        }
    }

    @Test
    func `Spasi di awal/akhir judul di-trim sebelum disimpan`() async throws {
        let env = makeSUT()
        let task = try await env.sut.execute(title: "  Buy milk  ", dueDate: Date().addingTimeInterval(3600))
        #expect(task.title == "Buy milk")
    }

    @Test
    func `dueDate di masa lalu throw pastDueDate, tidak menyimpan, tidak menjadwalkan`() async throws {
        let env = makeSUT()
        await #expect(throws: ValidationError.pastDueDate) {
            _ = try await env.sut.execute(title: "Valid", dueDate: Date().addingTimeInterval(-3600))
        }
        #expect(try env.repository.fetchAll().isEmpty)
        #expect(env.scheduler.calls.isEmpty)
    }

    @Test
    func `Input valid tersimpan dengan isPinned/isCompleted false`() async throws {
        let env = makeSUT()
        let dueDate = Date().addingTimeInterval(3600)
        let task = try await env.sut.execute(title: "Bayar listrik", dueDate: dueDate)

        #expect(!task.isPinned)
        #expect(!task.isCompleted)
        #expect(try env.repository.fetchAll() == [task])
    }

    @Test
    func `Input valid menjadwalkan reminder tepat sekali`() async throws {
        let env = makeSUT()
        let task = try await env.sut.execute(title: "Bayar listrik", dueDate: Date().addingTimeInterval(3600))
        #expect(env.scheduler.calls == [.schedule(task)])
    }
}
