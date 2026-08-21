//
//  MockNotificationScheduler.swift
//  ReminderApp · Data
//
//  TUGAS
//  Mencatat id mana yang dijadwalkan dan mana yang dibatalkan, lengkap dengan urutannya.
//  Ditulis lebih dulu (TDD) — file ini dan test-nya ada duluan, baru
//  DeleteTaskUseCase diimplementasikan menyesuaikan kontrak yang sudah dites.
//
//  Catatan urutan ditulis ke MockCallLog yang sama dipakai MockTaskRepository
//  — begitu keduanya disuntik dengan log yang sama ke DeleteTaskUseCase, urutan
//  cancel-vs-delete kebaca dari satu array, bukan dua log yang tidak bisa
//  dibandingkan (lihat MockCallLog.swift).
//
//  PERAN DI SOLID
//  • DIP — DeleteTaskUseCase cuma kenal NotificationSchedulerProtocol (jabatan),
//    disuntikkan lewat init(). Karena itu, versi asli dan Mock bisa gantian
//    dipasang tanpa DeleteTaskUseCase berubah.
//  • LSP — supaya penggantian itu SAH, Mock wajib berperilaku sama persis
//    dengan versi asli: cancel tidak throwing, tidak minta urutan panggilan
//    khusus.
//
//  DIP bikin penggantian ini mungkin, LSP bikin hasilnya bisa dipercaya.
//

final class MockNotificationScheduler: NotificationSchedulerProtocol {
    private let log: MockCallLog

    init(log: MockCallLog = MockCallLog()) {
        self.log = log
    }

    func schedule(for task: ReminderTask) async throws {
        log.record(.schedule(task))   // ← tercatat di timeline bersama (lihat MockCallLog.swift)
    }

    func cancel(for task: ReminderTask) {
        log.record(.cancel(task))   // ← titik ini yang dibaca test ordering cancel-vs-delete
    }
}
