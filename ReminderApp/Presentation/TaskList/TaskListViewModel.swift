//
//  TaskListViewModel.swift
//  ReminderApp · Presentation
//
//  TUGAS
//  Memegang state daftar task dan meneruskan aksi user:
//  loadTasks(), onPinTapped(), onCompleteTapped(), onDeleteTapped().
//
//  PERAN DI SOLID
//  • DIP — repository, use case, dan strategy semuanya masuk lewat init().
//  • OCP — urutan ditentukan strategy yang disuntik; tidak ada switch di sini.
//  • SRP — hanya state UI. Aturan bisnis tetap di UseCase.
//
//  Sengaja TIDAK ditandai nonisolated seperti tipe Domain. Ini ViewModel
//  sungguhan (@Published), jadi @MainActor bawaan modul memang tepat di
//  sini. Yang disesuaikan untuk Swift Testing adalah test suite-nya
//  (ditandai @MainActor), bukan tipe ini.

import Combine
import Foundation

final class TaskListViewModel: ObservableObject {
    @Published private(set) var tasks: [ReminderTask] = []

    private let repository: TaskRepositoryProtocol
    private let togglePinUseCase: TogglePinUseCase
    private let deleteTaskUseCase: DeleteTaskUseCase
    private let sortStrategy: TaskSortStrategy

    init(
        repository: TaskRepositoryProtocol,
        togglePinUseCase: TogglePinUseCase,
        deleteTaskUseCase: DeleteTaskUseCase,
        sortStrategy: TaskSortStrategy,
    ) {
        self.repository = repository
        self.togglePinUseCase = togglePinUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
        self.sortStrategy = sortStrategy
    }

    func loadTasks() {
        guard let fetched = try? repository.fetchAll() else { return }
        tasks = sortStrategy.sort(fetched)
    }

    func onPinTapped(_ task: ReminderTask) {
        try? togglePinUseCase.execute(task)
        loadTasks()
    }

    func onCompleteTapped(_ task: ReminderTask) {
        var updated = task
        updated.isCompleted.toggle()
        try? repository.save(updated)
        loadTasks()
    }

    func onDeleteTapped(_ task: ReminderTask) {
        try? deleteTaskUseCase.execute(task)
        loadTasks()
    }
}
