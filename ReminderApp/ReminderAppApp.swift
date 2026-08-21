//
//  ReminderAppApp.swift
//  ReminderApp
//
//  TUGAS
//  Composition root — satu-satunya file di app target yang boleh menyebut
//  tipe konkret (SwiftDataTaskRepository, UNNotificationScheduler, dsb).
//  Merakit semua dependency lalu menyuntikkannya ke ViewModel lewat init().
//
//  PERAN DI SOLID
//  • DIP — di sinilah protocol akhirnya "diisi" oleh implementasi asli.
//    Tidak ada file lain di app target yang boleh melakukan ini.
//
//  Catatan: root view masih placeholder. Wiring penuh (repository asli,
//  scheduler asli, TaskListView) baru terjadi setelah layer Domain, Data,
//  dan Presentation selesai diimplementasikan — bukan sekarang, supaya
//  tidak melompati urutan fase yang sudah ditetapkan di tasks.md.
//

import SwiftUI

@main
struct ReminderAppApp: App {
    var body: some Scene {
        WindowGroup {
            Text("ReminderApp")
        }
    }
}
