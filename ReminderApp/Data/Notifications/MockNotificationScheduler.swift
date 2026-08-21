//
//  MockNotificationScheduler.swift
//  ReminderApp · Data
//
//  TUGAS
//  Mencatat id mana yang dijadwalkan dan mana yang dibatalkan, lengkap dengan urutannya.
//  Ditulis lebih dulu (TDD) — file ini dan test-nya ada duluan, baru
//  DeleteTaskUseCase diimplementasikan menyesuaikan kontrak yang sudah dites.
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
