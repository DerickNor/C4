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
//  Status: stub TDD 🔴 — sengaja TIDAK ditandai nonisolated seperti tipe
//  Domain. Ini ViewModel sungguhan (@Published), jadi @MainActor bawaan
//  modul memang tepat di sini. Yang disesuaikan untuk Swift Testing adalah
//  test suite-nya (ditandai @MainActor), bukan tipe ini.

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
        sortStrategy: TaskSortStrategy
    ) {
        self.repository = repository
        self.togglePinUseCase = togglePinUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
        self.sortStrategy = sortStrategy
    }

    func loadTasks() {
        fatalError("not implemented")
    }

    func onPinTapped(_ task: ReminderTask) {
        fatalError("not implemented")
    }

    func onCompleteTapped(_ task: ReminderTask) {
        fatalError("not implemented")
    }

    func onDeleteTapped(_ task: ReminderTask) {
        fatalError("not implemented")
    }
}
