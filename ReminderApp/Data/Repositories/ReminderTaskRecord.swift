//
//  ReminderTaskRecord.swift
//  ReminderApp · Data
//
//  TUGAS
//  Model SwiftData (@Model class) + pemetaan ke/dari ReminderTask.
//  Satu baris tersimpan di disk. Tidak pernah keluar dari folder Data/ —
//  begitu melewati repository, bentuknya sudah jadi ReminderTask.
//
//  PERAN DI SOLID
//  • DIP — @Model wajib class dan menyuntik metadata SwiftData. Kalau ditempel
//    ke entity Domain, Domain jadi harus import SwiftData dan batas layernya jebol.
//  • SRP — hanya memetakan; validasi tetap milik UseCase.
//

import Foundation
import SwiftData

@Model
final class ReminderTaskRecord {
    @Attribute(.unique) var id: UUID
    var title: String
    var dueDate: Date
    var isPinned: Bool
    var isCompleted: Bool

    init(from task: ReminderTask) {
        self.id = task.id
        self.title = task.title
        self.dueDate = task.dueDate
        self.isPinned = task.isPinned
        self.isCompleted = task.isCompleted
    }

    func toDomain() -> ReminderTask {
        ReminderTask(id: id, title: title, dueDate: dueDate, isPinned: isPinned, isCompleted: isCompleted)
    }
}
