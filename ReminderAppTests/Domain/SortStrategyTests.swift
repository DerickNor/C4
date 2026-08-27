//
//  SortStrategyTests.swift
//  ReminderApp · Tests · Domain
//
//  TUGAS
//  Empat kasus: campuran pinned/unpinned, dueDate yang sama persis (stable sort),
//  semua pinned, dan semua unpinned.
//
//  PERAN DI SOLID
//  • OCP — pengujian langsung terhadap PinnedFirstSortStrategy, tanpa Mock.
//    Fungsi murni [ReminderTask] -> [ReminderTask] tidak butuh test double.
//
//  Status: TDD 🔴 — ditulis sebelum PinnedFirstSortStrategy asli ada, jadi
//  harus merah dulu (stub identity) sebelum TASK-021 mengisi logic-nya.

import Foundation
@testable import ReminderApp
import Testing

struct SortStrategyTests {
    @Test
    func `Campuran: pinned dulu (dueDate menaik), baru unpinned (dueDate menaik)`() {
        let now = Date()
        let pinnedLater = ReminderTask(title: "Pinned lambat", dueDate: now.addingTimeInterval(7200), isPinned: true)
        let pinnedEarlier = ReminderTask(title: "Pinned cepat", dueDate: now.addingTimeInterval(3600), isPinned: true)
        let unpinnedLater = ReminderTask(
            title: "Unpinned lambat", dueDate: now.addingTimeInterval(10800), isPinned: false,
        )
        let unpinnedEarlier = ReminderTask(
            title: "Unpinned cepat", dueDate: now.addingTimeInterval(1800), isPinned: false,
        )

        let sut = PinnedFirstSortStrategy()
        let result = sut.sort([pinnedLater, unpinnedEarlier, unpinnedLater, pinnedEarlier])

        #expect(result == [pinnedEarlier, pinnedLater, unpinnedEarlier, unpinnedLater])
    }

    @Test
    func `dueDate sama persis: urutan asal dipertahankan (stable sort)`() {
        let sharedDate = Date().addingTimeInterval(3600)
        let second = ReminderTask(title: "B", dueDate: sharedDate)
        let first = ReminderTask(title: "A", dueDate: sharedDate)

        let sut = PinnedFirstSortStrategy()
        let result = sut.sort([second, first])

        #expect(result == [second, first])
    }

    @Test
    func `Semua pinned: cuma diurutkan dueDate, tidak ada grup unpinned`() {
        let now = Date()
        let later = ReminderTask(title: "Later", dueDate: now.addingTimeInterval(7200), isPinned: true)
        let earlier = ReminderTask(title: "Earlier", dueDate: now.addingTimeInterval(3600), isPinned: true)

        let sut = PinnedFirstSortStrategy()
        let result = sut.sort([later, earlier])

        #expect(result == [earlier, later])
    }

    @Test
    func `Semua unpinned: cuma diurutkan dueDate, tidak ada grup pinned`() {
        let now = Date()
        let later = ReminderTask(title: "Later", dueDate: now.addingTimeInterval(7200), isPinned: false)
        let earlier = ReminderTask(title: "Earlier", dueDate: now.addingTimeInterval(3600), isPinned: false)

        let sut = PinnedFirstSortStrategy()
        let result = sut.sort([later, earlier])

        #expect(result == [earlier, later])
    }
}
