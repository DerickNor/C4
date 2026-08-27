//
//  TaskListViewModelTests.swift
//  ReminderApp · Tests · Presentation
//
//  TUGAS
//  loadTasks() mengisi dari repository, onPinTapped menyimpan,
//  dan urutan ditentukan MURNI oleh strategy yang disuntik.
//
//  PERAN DI SOLID
//  • OCP — ini bukti OCP-nya. Menyuntik strategy berbeda mengubah urutan
//    tanpa satu pun baris TaskListViewModel disentuh. Kalau tesnya tetap
//    menampilkan urutan lama, berarti ViewModel menyortir sendiri diam-diam.
//
//  Status: TDD 🔴 — ditulis sebelum TaskListViewModel asli ada, jadi harus
//  merah dulu (fatalError) sebelum TASK-024 mengisi logic-nya sampai hijau.
//
//  @MainActor di suite ini, BUKAN nonisolated di TaskListViewModel — beda
//  perlakuan dari test Domain, karena ViewModel ini memang seharusnya
//  terikat UI thread (lihat header TaskListViewModel.swift).

import Foundation
@testable import ReminderApp
import Testing

@MainActor
struct TaskListViewModelTests {
    private struct Environment {
        let viewModel: TaskListViewModel
        let repository: MockTaskRepository
    }

    private func makeSUT(
        tasks: [ReminderTask] = [],
        sortStrategy: TaskSortStrategy = SpySortStrategy(),
    ) -> Environment {
        let repository = MockTaskRepository(tasks: tasks)
        let scheduler = MockNotificationScheduler()
        let viewModel = TaskListViewModel(
            repository: repository,
            togglePinUseCase: TogglePinUseCase(repository: repository),
            deleteTaskUseCase: DeleteTaskUseCase(repository: repository, scheduler: scheduler),
            sortStrategy: sortStrategy,
        )
        return Environment(viewModel: viewModel, repository: repository)
    }

    @Test
    func `loadTasks() mengisi tasks dari repository`() {
        let task = ReminderTask(title: "Bayar listrik", dueDate: Date().addingTimeInterval(3600))
        let env = makeSUT(tasks: [task])

        env.viewModel.loadTasks()

        #expect(env.viewModel.tasks == [task])
    }

    @Test
    func `onPinTapped menyimpan perubahan lewat repository dan me-refresh tasks`() throws {
        let task = ReminderTask(
            title: "Bayar listrik", dueDate: Date().addingTimeInterval(3600), isPinned: false,
        )
        let env = makeSUT(tasks: [task])
        env.viewModel.loadTasks()

        env.viewModel.onPinTapped(task)

        var expected = task
        expected.isPinned = true
        #expect(try env.repository.fetchAll() == [expected])
        #expect(env.viewModel.tasks.first?.isPinned == true)
    }

    /// Bukti OCP: SpySortStrategy membalik urutan, bukan mengurutkannya.
    /// Kalau TaskListViewModel diam-diam menyortir sendiri (bukan lewat
    /// strategy yang disuntik), hasilnya TIDAK akan terbalik seperti ini.
    @Test
    func `Menyuntik SpySortStrategy membalik urutan tanpa mengubah ViewModel`() {
        let taskA = ReminderTask(title: "A", dueDate: Date().addingTimeInterval(3600))
        let taskB = ReminderTask(title: "B", dueDate: Date().addingTimeInterval(7200))
        let spy = SpySortStrategy()
        let env = makeSUT(tasks: [taskA, taskB], sortStrategy: spy)

        env.viewModel.loadTasks()

        #expect(env.viewModel.tasks == [taskB, taskA])
    }
}
