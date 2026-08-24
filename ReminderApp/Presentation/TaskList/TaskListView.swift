//
//  TaskListView.swift
//  ReminderApp · Presentation
//
//  TUGAS
//  Menggambar daftar task, tombol pin, swipe untuk hapus,
//  dan tampilan berbeda untuk task yang sudah selesai.
//
//  PERAN DI SOLID
//  • SRP — View hanya menggambar. Semua keputusan diambil ViewModel,
//    jadi tidak ada aturan bisnis yang menyelinap ke dalam body.
//
//  Tidak ada if/switch atas state bisnis di sini — isPinned/isCompleted
//  cuma dioper sebagai parameter ke modifier SwiftUI (ternary, bukan
//  percabangan kontrol alur).

import Foundation
import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskListViewModel

    var body: some View {
        List {
            ForEach(viewModel.tasks) { task in
                TaskRow(task: task, onPinTapped: { viewModel.onPinTapped(task) })
                    .onTapGesture { viewModel.onCompleteTapped(task) }
                    .swipeActions {
                        Button("Hapus", role: .destructive) {
                            viewModel.onDeleteTapped(task)
                        }
                    }
            }
        }
        .onAppear { viewModel.loadTasks() }
    }
}

private struct TaskRow: View {
    let task: ReminderTask
    let onPinTapped: () -> Void

    var body: some View {
        HStack {
            Button(action: onPinTapped) {
                Image(systemName: task.isPinned ? "pin.fill" : "pin")
            }
            .buttonStyle(.plain)

            Text(task.title)
                .strikethrough(task.isCompleted)
                .foregroundStyle(task.isCompleted ? .secondary : .primary)

            Spacer()
        }
    }
}

#Preview {
    let repository = MockTaskRepository(tasks: [
        ReminderTask(title: "Bayar listrik", dueDate: Date().addingTimeInterval(3600), isPinned: true),
        ReminderTask(title: "Rapat tim", dueDate: Date().addingTimeInterval(7200))
    ])
    let scheduler = MockNotificationScheduler()
    let viewModel = TaskListViewModel(
        repository: repository,
        togglePinUseCase: TogglePinUseCase(repository: repository),
        deleteTaskUseCase: DeleteTaskUseCase(repository: repository, scheduler: scheduler),
        sortStrategy: PinnedFirstSortStrategy()
    )
    return TaskListView(viewModel: viewModel)
}
