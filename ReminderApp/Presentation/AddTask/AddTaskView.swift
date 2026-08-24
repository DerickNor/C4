//
//  AddTaskView.swift
//  ReminderApp · Presentation
//
//  TUGAS
//  Form input: kolom judul, date picker, tombol simpan, dan tampilan pesan error.
//
//  PERAN DI SOLID
//  • SRP — tidak memvalidasi ulang apa pun. Kalau View ikut mengecek
//    judul kosong, aturan yang sama jadi hidup di dua tempat dan pasti berbeda nanti.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: AddTaskViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            TextField("Judul", text: $viewModel.title)
            DatePicker("Tanggal", selection: $viewModel.dueDate)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            Button("Simpan") {
                Task {
                    await viewModel.submit()
                    if viewModel.errorMessage == nil {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let repository = MockTaskRepository()
    let scheduler = MockNotificationScheduler()
    let useCase = AddTaskUseCase(repository: repository, scheduler: scheduler)
    return AddTaskView(viewModel: AddTaskViewModel(addTaskUseCase: useCase))
}
