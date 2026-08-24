//
//  UNNotificationScheduler.swift
//  ReminderApp · Data
//
//  TUGAS
//  Implementasi asli scheduler memakai UNUserNotificationCenter.
//  Memakai task.id.uuidString sebagai identifier request, supaya cancel bisa menemukannya lagi.
//
//  PERAN DI SOLID
//  • SRP — hanya urusan notifikasi.
//  • LSP — kontraknya harus sama dengan MockNotificationScheduler.
//

import Foundation
import UserNotifications

final class UNNotificationScheduler: NotificationSchedulerProtocol {
    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    /// Diminta sekali di composition root saat app launch (lihat `design.md` § Open
    /// Questions — resolusi: at launch, bukan lazy di first task creation, supaya
    /// `AddTaskUseCase` tidak perlu failure mode baru di luar `ValidationError`).
    /// Bukan bagian dari `NotificationSchedulerProtocol`: ini urusan konkret
    /// `UNUserNotificationCenter`, dan `MockNotificationScheduler` tidak butuh
    /// meniru API izin sungguhan untuk tetap LSP-compliant.
    func requestAuthorization() async {
        _ = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    func schedule(for task: ReminderTask) async throws {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.sound = .default

        let interval = max(task.dueDate.timeIntervalSinceNow, 1)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)

        let request = UNNotificationRequest(
            identifier: task.id.uuidString,
            content: content,
            trigger: trigger
        )
        try await center.add(request)
    }

    func cancel(for task: ReminderTask) {
        center.removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
    }
}
