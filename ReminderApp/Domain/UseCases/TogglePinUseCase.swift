//
//  TogglePinUseCase.swift
//  ReminderApp · Domain
//
//  TUGAS
//  Membalik nilai isPinned lalu menyimpannya kembali.
//  title, dueDate, dan isCompleted tidak boleh ikut berubah.
//
//  PERAN DI SOLID
//  • SRP — satu aksi, satu alasan untuk berubah.
//  • ISP — cukup menerima TaskRepositoryProtocol saja, tanpa scheduler.
//

nonisolated struct TogglePinUseCase {
    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }

    func execute(_ task: ReminderTask) throws {
        var updated = task
        updated.isPinned.toggle()
        try repository.save(updated)
    }
}
