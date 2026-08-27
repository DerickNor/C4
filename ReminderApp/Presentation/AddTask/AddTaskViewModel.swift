//
//  AddTaskViewModel.swift
//  ReminderApp · Presentation
//
//  TUGAS
//  Memegang state title, dueDate, errorMessage, dan submit() yang memanggil AddTaskUseCase.
//  Menerjemahkan tiap kasus ValidationError jadi pesan yang bisa dibaca manusia.
//
//  PERAN DI SOLID
//  • SRP — kata-kata pesan itu urusan presentasi; ATURANnya tetap milik UseCase.
//    Memindahkan validasi ke sini akan menduplikasi aturan di dua tempat.
//  • DIP — menerima use case lewat init(), bukan membuatnya sendiri.
//

import Combine
import Foundation

final class AddTaskViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var dueDate: Date = .init().addingTimeInterval(3600)
    @Published private(set) var errorMessage: String?

    private let addTaskUseCase: AddTaskUseCase

    init(addTaskUseCase: AddTaskUseCase) {
        self.addTaskUseCase = addTaskUseCase
    }

    func submit() async {
        do {
            _ = try await addTaskUseCase.execute(title: title, dueDate: dueDate)
            errorMessage = nil
        } catch ValidationError.emptyTitle {
            errorMessage = "Judul tidak boleh kosong."
        } catch ValidationError.pastDueDate {
            errorMessage = "Waktu pengingat tidak boleh di masa lalu."
        } catch {
            errorMessage = "Terjadi kesalahan tak terduga."
        }
    }
}
