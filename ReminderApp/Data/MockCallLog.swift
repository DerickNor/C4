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

final class MockCallLog {
    enum Entry: Equatable {
        case fetchAll
        case save(ReminderTask)
        case delete(ReminderTask)
        case schedule(ReminderTask)
        case cancel(ReminderTask)
    }

    private(set) var entries: [Entry] = []

    func record(_ entry: Entry) {
        entries.append(entry)
    }
}
