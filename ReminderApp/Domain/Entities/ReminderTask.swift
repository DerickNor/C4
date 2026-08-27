//
//  ReminderTask.swift
//  ReminderApp · Domain
//
//  TUGAS
//  Model data satu task: id, title, dueDate, isPinned, isCompleted.
//  Struct Swift murni — tidak tahu cara menyimpan, menjadwalkan, atau menampilkan dirinya.
//
//  PERAN DI SOLID
//  • SRP — hanya memegang data. Menyimpan, menjadwalkan, dan menggambar
//    adalah tugas tipe lain.
//

import Foundation

nonisolated struct ReminderTask: Identifiable, Equatable {
    let id: UUID
    // title dan dueDate sengaja `let` — mengedit task setelah dibuat di luar
    // scope (lihat requirements.md § Out of Scope). Hanya pin/complete yang
    // boleh berubah, jadi cuma keduanya yang `var`.
    let title: String
    let dueDate: Date
    var isPinned: Bool
    var isCompleted: Bool

    init(
        id: UUID = UUID(),
        title: String,
        dueDate: Date,
        isPinned: Bool = false,
        isCompleted: Bool = false,
    ) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.isPinned = isPinned
        self.isCompleted = isCompleted
    }
}
