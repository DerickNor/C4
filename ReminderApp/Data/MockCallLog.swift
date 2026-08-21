//
//  MockCallLog.swift
//  ReminderApp · Data
//
//  TUGAS
//  Buku catatan bersama untuk semua Mock — satu timeline tunggal yang
//  merekam kejadian dari MockTaskRepository DAN MockNotificationScheduler
//  sekaligus, bukan dua catatan terpisah.
//
//  Kenapa harus satu: DeleteTaskUseCase memanggil scheduler.cancel(for:)
//  lalu repository.delete(_:). Kalau masing-masing Mock punya buku
//  catatannya sendiri, tidak ada cara membuktikan urutan ANTAR keduanya —
//  paling jauh cuma bisa membuktikan "cancel kepanggil" dan "delete
//  kepanggil" secara terpisah, bukan cancel-lah-yang-lebih-dulu. Dengan
//  satu log yang disuntik ke dua Mock sekaligus, urutan aslinya kebaca
//  langsung dari satu array.
//
//  PERAN DI SOLID
//  • DIP — ada karena kedua Mock sama-sama cuma implementasi dari
//    protocol; log ini tidak tahu-menahu SwiftData atau UNUserNotificationCenter.
//
//  CONTOH PEMAKAIAN — begini cara kerjanya secara konkret:
//
//      let log = MockCallLog()
//      let repository = MockTaskRepository(log: log)        // ← log yang sama...
//      let scheduler = MockNotificationScheduler(log: log)   // ← ...disuntik ke dua-duanya
//
//      scheduler.cancel(for: task)
//      try repository.delete(task)
//
//      log.entries   // [.cancel(task), .delete(task)] — urutan ASLI kebaca dari sini
//
//  Tanpa `log:` disuntik, tiap Mock otomatis dapat MockCallLog kosong miliknya
//  sendiri (lihat default value di init masing-masing) — cukup untuk test yang
//  cuma butuh satu Mock dan tidak peduli urutan lintas-Mock.
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
