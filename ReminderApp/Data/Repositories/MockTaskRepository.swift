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
        log.record(.fetchAll)
        return tasks
    }

    func save(_ task: ReminderTask) throws {
        log.record(.save(task))
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            tasks.append(task)
        }
    }

    func delete(_ task: ReminderTask) throws {
        log.record(.delete(task))
        tasks.removeAll { $0.id == task.id }
    }
}
