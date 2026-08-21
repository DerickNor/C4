//
//  TaskListViewModelTests.swift
//  ReminderApp · Tests · Presentation
//
//  TUGAS
//  loadTasks() mengisi dari repository, onPinTapped menyimpan,
//  dan urutan ditentukan MURNI oleh strategy yang disuntik.
//  Catatan: masih di dalam app target; akan dipindah ke target test terpisah.
//
//  PERAN DI SOLID
//  • OCP — ini bukti OCP-nya. Menyuntik strategy berbeda mengubah urutan
//    tanpa satu pun baris TaskListViewModel disentuh. Kalau tesnya tetap
//    menampilkan urutan lama, berarti ViewModel menyortir sendiri diam-diam.
//
