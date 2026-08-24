//
//  PinnedFirstSortStrategy.swift
//  ReminderApp · Data
//
//  TUGAS
//  Task yang di-pin naik ke atas; masing-masing grup diurutkan dueDate menaik.
//  Satu-satunya urutan yang dipakai aplikasi.
//
//  PERAN DI SOLID
//  • OCP — TaskListViewModel tidak tahu file ini ada. Menambah urutan lain
//    cukup bikin file baru yang ikut TaskSortStrategy.
//

nonisolated struct PinnedFirstSortStrategy: TaskSortStrategy {
    func sort(_ tasks: [ReminderTask]) -> [ReminderTask] {
        tasks.sorted { lhs, rhs in
            if lhs.isPinned != rhs.isPinned {
                return lhs.isPinned
            }
            return lhs.dueDate < rhs.dueDate
        }
    }
}
