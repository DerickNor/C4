//
//  SpySortStrategy.swift
//  ReminderApp · Tests · Doubles
//
//  TUGAS
//  Mencatat array yang diterima, lalu mengembalikannya TERBALIK — bukan
//  diurutkan sungguhan. Pembalikan ini sengaja: hasilnya mustahil kebetulan
//  sama dengan PinnedFirstSortStrategy, jadi kalau test ViewModel nanti
//  masih menampilkan urutan pinned-first, itu bukti ViewModel mengabaikan
//  strategy yang disuntikkan — bukan benar-benar memakainya.
//
//  PERAN DI SOLID
//  • OCP — bukti konkretnya. Menggantikan PinnedFirstSortStrategy di
//    TaskListViewModel tanpa mengubah satu baris pun kode ViewModel-nya.
//

@testable import ReminderApp

final class SpySortStrategy: TaskSortStrategy {
    private(set) var receivedTasks: [ReminderTask]?

    func sort(_ tasks: [ReminderTask]) -> [ReminderTask] {
        receivedTasks = tasks
        return tasks.reversed()
    }
}
