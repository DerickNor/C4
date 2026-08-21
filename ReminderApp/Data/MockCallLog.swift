//
//  MockCallLog.swift
//  ReminderApp · Data
//
//  TUGAS
//  Satu timeline bersama untuk MockTaskRepository dan MockNotificationScheduler,
//  supaya urutan panggilan ANTAR keduanya bisa dibuktikan — bukan cuma
//  masing-masing dibuktikan terpisah.
//
//  PERAN DI SOLID
//  • DIP — kedua Mock sama-sama cuma implementasi protocol; log ini tidak
//    tahu-menahu SwiftData atau UNUserNotificationCenter.
//
//  Contoh pemakaian:
//
//      let log = MockCallLog()
//      let repository = MockTaskRepository(log: log)
//      let scheduler = MockNotificationScheduler(log: log)
//      scheduler.cancel(for: task)
//      try repository.delete(task)
//      log.entries   // [.cancel(task), .delete(task)]
//

final class MockCallLog {
    enum Entry: Equatable {
        case fetchAll
        case save(ReminderTask)
        case delete(ReminderTask)
        case schedule(ReminderTask)
        case cancel(ReminderTask)
    }

    /// Timeline aktualnya. Urutan array = urutan kejadian sebenarnya,
    /// karena `record(_:)` cuma append — tidak pernah insert/reorder.
    private(set) var entries: [Entry] = []

    /// Dipanggil dari dalam MockTaskRepository & MockNotificationScheduler
    /// setiap method protocol-nya jalan. Inilah satu-satunya titik tulis.
    func record(_ entry: Entry) {
        entries.append(entry)
    }
}
