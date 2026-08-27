//
//  MockTaskRepository.swift
//  ReminderApp · Data
//
//  TUGAS
//  Implementasi in-memory dari TaskRepositoryProtocol. Dipakai unit test
//  dan SwiftUI Preview. Urutan panggilan dicatat ke MockCallLog (lihat
//  file itu) supaya bisa dibandingkan dengan panggilan di MockNotificationScheduler.
//
//  PERAN DI SOLID
//  • LSP — inilah buktinya. Bisa menggantikan SwiftDataTaskRepository
//    tanpa mengubah satu baris pun di pemanggilnya.
//  • DIP — bukti bahwa UseCase memang bergantung ke protocol, bukan ke SwiftData.
//

final nonisolated class MockTaskRepository: TaskRepositoryProtocol {
    private let log: MockCallLog
    private var tasks: [ReminderTask]

    var calls: [MockCallLog.Entry] {
        log.entries
    }

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
            tasks[index] = task // update: id sudah ada
        } else {
            tasks.append(task) // insert: id baru
        }
    }

    /// Dipanggil DeleteTaskUseCase setelah scheduler.cancel(for:). Karena
    /// dua-duanya menulis ke MockCallLog yang sama, DeleteTaskUseCaseTests
    /// nanti tinggal cek log.entries dan pastikan .cancel muncul sebelum
    /// .delete — bukan cuma cek dua-duanya kepanggil.
    func delete(_ task: ReminderTask) throws {
        log.record(.delete(task))
        tasks.removeAll { $0.id == task.id }
    }
}
