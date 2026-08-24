//
//  ReminderAppApp.swift
//  ReminderApp
//
//  TUGAS
//  Composition root — satu-satunya file di app target yang boleh menyebut
//  tipe konkret (SwiftDataTaskRepository, UNNotificationScheduler, dsb).
//  Merakit semua dependency lalu menyuntikkannya ke ViewModel lewat init().
//
//  PERAN DI SOLID
//  • DIP — di sinilah protocol akhirnya "diisi" oleh implementasi asli.
//    Tidak ada file lain di app target yang boleh melakukan ini.
//
//  Catatan: RootView (NavigationStack + tombol "+" + sheet AddTaskView)
//  tidak pernah tertulis eksplisit di design.md — celah perencanaan yang
//  ketahuan waktu mengerjakan task ini. Tanpa glue navigasi ini, tidak ada
//  jalan sama sekali untuk membuka AddTaskView dari app yang jalan, yang
//  bikin NFR-007 ("builds and runs") tidak bermakna dan TASK-032 (uji
//  manual end-to-end) mustahil dijalankan. Ditambahkan sebagai penyesuaian
//  sadar, bukan diam-diam.

import SwiftData
import SwiftUI

@main
struct ReminderAppApp: App {
    private let repository: SwiftDataTaskRepository
    private let scheduler: UNNotificationScheduler
    private let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: ReminderTaskRecord.self)
        } catch {
            fatalError("Gagal membuat ModelContainer: \(error)")
        }
        repository = SwiftDataTaskRepository(modelContext: modelContainer.mainContext)
        scheduler = UNNotificationScheduler()
    }

    var body: some Scene {
        WindowGroup {
            RootView(repository: repository, scheduler: scheduler)
        }
    }
}

private struct RootView: View {
    let repository: SwiftDataTaskRepository
    let scheduler: UNNotificationScheduler

    @StateObject private var taskListViewModel: TaskListViewModel
    @State private var isAddingTask = false

    init(repository: SwiftDataTaskRepository, scheduler: UNNotificationScheduler) {
        self.repository = repository
        self.scheduler = scheduler
        _taskListViewModel = StateObject(wrappedValue: TaskListViewModel(
            repository: repository,
            togglePinUseCase: TogglePinUseCase(repository: repository),
            deleteTaskUseCase: DeleteTaskUseCase(repository: repository, scheduler: scheduler),
            sortStrategy: PinnedFirstSortStrategy()
        ))
    }

    var body: some View {
        NavigationStack {
            TaskListView(viewModel: taskListViewModel)
                .navigationTitle("ReminderApp")
                .toolbar {
                    Button("Tambah", systemImage: "plus") {
                        isAddingTask = true
                    }
                }
                .sheet(isPresented: $isAddingTask) {
                    AddTaskView(
                        viewModel: AddTaskViewModel(
                            addTaskUseCase: AddTaskUseCase(repository: repository, scheduler: scheduler)
                        )
                    )
                    .onDisappear {
                        taskListViewModel.loadTasks()
                    }
                }
        }
    }
}
