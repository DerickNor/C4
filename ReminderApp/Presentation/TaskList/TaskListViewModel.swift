//
//  TaskListViewModel.swift
//  ReminderApp · Presentation
//
//  TUGAS
//  Memegang state daftar task dan meneruskan aksi user:
//  loadTasks(), onPinTapped(), onCompleteTapped(), onDeleteTapped().
//
//  PERAN DI SOLID
//  • DIP — repository, use case, dan strategy semuanya masuk lewat init().
//  • OCP — urutan ditentukan strategy yang disuntik; tidak ada switch di sini.
//  • SRP — hanya state UI. Aturan bisnis tetap di UseCase.
//
