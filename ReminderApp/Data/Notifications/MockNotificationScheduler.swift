//
//  MockNotificationScheduler.swift
//  ReminderApp · Data
//
//  TUGAS
//  Implementasi in-memory dari NotificationSchedulerProtocol. Mencatat id
//  yang dijadwalkan/dibatalkan ke MockCallLog yang sama dipakai
//  MockTaskRepository (lihat file itu), supaya urutan cancel-vs-delete
//  bisa dibandingkan lintas dua Mock.
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

    var calls: [MockCallLog.Entry] { log.entries }

    init(log: MockCallLog = MockCallLog()) {
        self.log = log
    }

    func schedule(for task: ReminderTask) async throws {
        log.record(.schedule(task))
    }

    // Dipanggil DeleteTaskUseCase SEBELUM repository.delete(_:). Karena
    // dua-duanya menulis ke MockCallLog yang sama, DeleteTaskUseCaseTests
    // nanti tinggal cek log.entries dan pastikan .cancel muncul sebelum
    // .delete — bukan cuma cek dua-duanya kepanggil.
    func cancel(for task: ReminderTask) {
        log.record(.cancel(task))
    }
}
