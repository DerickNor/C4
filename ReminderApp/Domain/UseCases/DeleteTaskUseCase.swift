//
//  DeleteTaskUseCase.swift
//  ReminderApp · Domain
//
//  TUGAS
//  Membatalkan reminder LEBIH DULU, baru menghapus datanya.
//  Urutan ini requirement, bukan selera: kalau delete gagal setelah cancel,
//  yang tersisa hanya data — bukan notifikasi hantu yang berbunyi tanpa task.
//
//  PERAN DI SOLID
//  • SRP — hanya mengurus alur penghapusan.
//  • DIP — memakai dua protocol, tidak tahu SwiftData maupun UNUserNotificationCenter.
//

nonisolated struct DeleteTaskUseCase {
    private let repository: TaskRepositoryProtocol
    private let scheduler: NotificationSchedulerProtocol

    init(repository: TaskRepositoryProtocol, scheduler: NotificationSchedulerProtocol) {
        self.repository = repository
        self.scheduler = scheduler
    }

    func execute(_ task: ReminderTask) throws {
        fatalError("not implemented")
    }
}
