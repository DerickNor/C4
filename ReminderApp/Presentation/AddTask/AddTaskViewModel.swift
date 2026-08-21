//
//  AddTaskViewModel.swift
//  ReminderApp · Presentation
//
//  TUGAS
//  Memegang state title, dueDate, errorMessage, dan submit() yang memanggil AddTaskUseCase.
//  Menerjemahkan tiap kasus ValidationError jadi pesan yang bisa dibaca manusia.
//
//  PERAN DI SOLID
//  • SRP — kata-kata pesan itu urusan presentasi; ATURANnya tetap milik UseCase.
//    Memindahkan validasi ke sini akan menduplikasi aturan di dua tempat.
//  • DIP — menerima use case lewat init(), bukan membuatnya sendiri.
//
