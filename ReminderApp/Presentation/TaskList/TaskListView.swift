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
        HStack(spacing: 12) {
            Button(action: onPinTapped) {
                Image(systemName: task.isPinned ? "pin.fill" : "pin")
                    .foregroundStyle(task.isPinned ? .orange : .secondary)
                    // Ikon boleh kecil, tapi area sentuh tetap wajib ≥44×44pt (HIG).
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)

                // Format sistem (bukan string manual) — otomatis ikut format
                // tanggal/jam lokal user, sesuai anjuran HIG.
                Text(task.dueDate, format: .dateTime.day().month(.abbreviated).year().hour().minute())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    let now = Date()
    let repository = MockTaskRepository(tasks: [
        ReminderTask(title: "Bayar listrik", dueDate: now.addingTimeInterval(3600), isPinned: true),
        ReminderTask(title: "Rapat tim", dueDate: now.addingTimeInterval(86400), isPinned: true),
        ReminderTask(title: "Beli susu", dueDate: now.addingTimeInterval(1800)),
        ReminderTask(title: "Cuci motor", dueDate: now.addingTimeInterval(172800), isCompleted: true)
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
