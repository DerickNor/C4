//
//  MockTaskRepository.swift
//  ReminderApp · Data
//
//  TUGAS
//  Implementasi in-memory yang mencatat method apa saja yang dipanggil dan urutannya.
//  Dipakai unit test dan SwiftUI Preview.
//
//  PERAN DI SOLID
//  • LSP — inilah buktinya. Bisa menggantikan SwiftDataTaskRepository
//    tanpa mengubah satu baris pun di pemanggilnya.
//  • DIP — bukti bahwa UseCase memang bergantung ke protocol, bukan ke SwiftData.
//

final class MockTaskRepository: TaskRepositoryProtocol {
    enum Call: Equatable {
        case fetchAll
        case save(ReminderTask)
        case delete(ReminderTask)
    }

    private(set) var calls: [Call] = []
    private var tasks: [ReminderTask]

    init(tasks: [ReminderTask] = []) {
        self.tasks = tasks
    }

    func fetchAll() throws -> [ReminderTask] {
        calls.append(.fetchAll)
        return tasks
    }

    func save(_ task: ReminderTask) throws {
        calls.append(.save(task))
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            tasks.append(task)
        }
    }

    func delete(_ task: ReminderTask) throws {
        calls.append(.delete(task))
        tasks.removeAll { $0.id == task.id }
    }
}
