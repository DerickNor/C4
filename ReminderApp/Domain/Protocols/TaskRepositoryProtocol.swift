//
//  TaskRepositoryProtocol.swift
//  ReminderApp · Domain
//
//  TUGAS
//  Kontrak penyimpanan task: fetchAll(), save(_:), delete(_:).
//  Mendefinisikan APA yang bisa dilakukan, bukan BAGAIMANA caranya.
//
//  PERAN DI SOLID
//  • DIP — UseCase bergantung ke protocol ini, bukan ke SwiftData.
//  • ISP — sengaja terpisah dari NotificationSchedulerProtocol.
//  • LSP — semua implementasinya wajib berperilaku sama terhadap kontrak ini.
//
