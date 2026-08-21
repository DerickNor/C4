//
//  NotificationSchedulerProtocol.swift
//  ReminderApp · Domain
//
//  TUGAS
//  Kontrak penjadwalan reminder: schedule(for:) dan cancel(for:).
//  cancel sengaja tidak throwing supaya urutan di DeleteTaskUseCase tidak bisa putus di tengah.
//
//  PERAN DI SOLID
//  • ISP — dipisah dari TaskRepositoryProtocol. TogglePinUseCase hanya butuh
//    menyimpan, jadi tidak dipaksa menerima scheduler yang tak dipakainya.
//  • DIP — Domain tidak pernah menyentuh UNUserNotificationCenter langsung.
//
