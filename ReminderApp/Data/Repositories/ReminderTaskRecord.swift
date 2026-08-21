//
//  ReminderTaskRecord.swift
//  ReminderApp · Data
//
//  TUGAS
//  Model SwiftData (@Model class) + pemetaan ke/dari ReminderTask.
//  Satu baris tersimpan di disk. Tidak pernah keluar dari folder Data/ —
//  begitu melewati repository, bentuknya sudah jadi ReminderTask.
//
//  PERAN DI SOLID
//  • DIP — @Model wajib class dan menyuntik metadata SwiftData. Kalau ditempel
//    ke entity Domain, Domain jadi harus import SwiftData dan batas layernya jebol.
//  • SRP — hanya memetakan; validasi tetap milik UseCase.
//
