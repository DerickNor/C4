//
//  MockTaskRepository.swift
//  ReminderApp · Data
//
//  TUGAS
//  Implementasi in-memory yang mencatat method apa saja yang dipanggil dan urutannya.
//  Dipakai unit test dan SwiftUI Preview.
//
//  PERAN DI SOLID
//  • LSP — inilah buktinya. Bisa menggantikan SwiftDataTaskRepository
//    tanpa mengubah satu baris pun di pemanggilnya.
//  • DIP — bukti bahwa UseCase memang bergantung ke protocol, bukan ke SwiftData.
//
