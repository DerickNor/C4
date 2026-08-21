//
//  MockTaskRepository.swift
//  ReminderApp · Data
//
//  TUGAS
//  Implementasi in-memory yang mencatat method apa saja yang dipanggil dan urutannya.
//  Dipakai unit test dan SwiftUI Preview.
//
//  Catatan urutan ditulis ke MockCallLog, bukan array privat sendiri —
//  supaya bisa berbagi satu timeline dengan MockNotificationScheduler
//  waktu keduanya disuntik ke DeleteTaskUseCase yang sama (lihat
//  MockCallLog.swift). Kalau tidak disuntik log khusus, tiap instance
//  otomatis dapat log sendiri — cukup untuk test yang cuma perlu satu Mock.
//
//  PERAN DI SOLID
//  • LSP — inilah buktinya. Bisa menggantikan SwiftDataTaskRepository
//    tanpa mengubah satu baris pun di pemanggilnya.
//  • DIP — bukti bahwa UseCase memang bergantung ke protocol, bukan ke SwiftData.
//

final class MockTaskRepository: TaskRepositoryProtocol {
    private let log: MockCallLog
    private var tasks: [ReminderTask]

    var calls: [MockCallLog.Entry] { log.entries }

    init(tasks: [ReminderTask] = [], log: MockCallLog = MockCallLog()) {
        self.tasks = tasks
        self.log = log
    }

    func fetchAll() throws -> [ReminderTask] {
        log.record(.fetchAll)   // ← tercatat di timeline bersama (lihat MockCallLog.swift)
        return tasks
    }

    func save(_ task: ReminderTask) throws {
        log.record(.save(task))   // ← tercatat DULU, baru upsert — urutan record = urutan panggilan asli
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task   // update: id sudah ada
        } else {
            tasks.append(task)   // insert: id baru
        }
    }

    func delete(_ task: ReminderTask) throws {
        log.record(.delete(task))   // ← titik ini yang dibaca test ordering cancel-vs-delete
        tasks.removeAll { $0.id == task.id }
    }
}
