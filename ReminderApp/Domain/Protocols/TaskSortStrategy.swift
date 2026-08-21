//
//  TaskSortStrategy.swift
//  ReminderApp · Domain
//
//  TUGAS
//  Kontrak pengurutan daftar task: sort([ReminderTask]) -> [ReminderTask].
//  Satu method, tanpa state — murni mengubah urutan.
//
//  PERAN DI SOLID
//  • OCP — ini jantungnya. Menambah urutan baru = bikin file baru;
//    TaskListViewModel tidak pernah dibuka lagi. Tanpa protocol ini,
//    setiap urutan baru berarti menambah case di switch.
//

protocol TaskSortStrategy {
    func sort(_ tasks: [ReminderTask]) -> [ReminderTask]
}
