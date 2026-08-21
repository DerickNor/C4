//
//  AddTaskUseCase.swift
//  ReminderApp · Domain
//
//  TUGAS
//  Aturan bisnis pembuatan task: trim judul, tolak judul kosong, tolak dueDate lampau.
//  Kalau lolos: simpan lewat repository, lalu jadwalkan reminder lewat scheduler.
//
//  PERAN DI SOLID
//  • SRP — hanya aturan bisnis. Menyimpan milik Repository,
//    menjadwalkan milik Scheduler.
//  • DIP — kedua dependency masuk lewat init() sebagai protocol.
//
