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
