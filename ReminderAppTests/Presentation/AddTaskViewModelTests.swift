//
//  AddTaskViewModelTests.swift
//  ReminderApp · Tests · Presentation
//
//  TUGAS
//  Submit valid mengosongkan errorMessage; judul kosong dan dueDate lampau
//  masing-masing memberi pesan yang berbeda.
//
//  PERAN DI SOLID
//  • SRP — memastikan ViewModel hanya MEMETAKAN error,
//    bukan ikut memutuskan apa yang salah.
//
//  Status: TDD 🔴 — ditulis sebelum AddTaskViewModel asli ada, jadi harus
//  merah dulu (fatalError) sebelum TASK-027 mengisi logic-nya sampai hijau.

import Testing
import Foundation
@testable import ReminderApp

@MainActor
struct AddTaskViewModelTests {
    private struct Environment {
        let viewModel: AddTaskViewModel
        let repository: MockTaskRepository
    }

    private func makeSUT() -> Environment {
        let repository = MockTaskRepository()
        let scheduler = MockNotificationScheduler()
        let useCase = AddTaskUseCase(repository: repository, scheduler: scheduler)
        let viewModel = AddTaskViewModel(addTaskUseCase: useCase)
        return Environment(viewModel: viewModel, repository: repository)
    }

    @Test("Submit valid mengosongkan errorMessage")
    func submit_validInput_clearsErrorMessage() async {
        let env = makeSUT()
        env.viewModel.title = "Bayar listrik"
        env.viewModel.dueDate = Date().addingTimeInterval(3600)

        await env.viewModel.submit()

        #expect(env.viewModel.errorMessage == nil)
    }

    @Test("Submit judul kosong mengisi errorMessage")
    func submit_emptyTitle_setsErrorMessage() async {
        let env = makeSUT()
        env.viewModel.title = ""
        env.viewModel.dueDate = Date().addingTimeInterval(3600)

        await env.viewModel.submit()

        #expect(env.viewModel.errorMessage != nil)
    }

    @Test("Submit dueDate lampau mengisi errorMessage")
    func submit_pastDueDate_setsErrorMessage() async {
        let env = makeSUT()
        env.viewModel.title = "Valid"
        env.viewModel.dueDate = Date().addingTimeInterval(-3600)

        await env.viewModel.submit()

        #expect(env.viewModel.errorMessage != nil)
    }

    // Ini yang sesungguhnya diminta REQ-014: dua pesan error harus BISA
    // DIBEDAKAN, bukan cuma sama-sama "ada pesan error".
    @Test("Pesan error judul kosong dan dueDate lampau harus berbeda")
    func submit_emptyTitleAndPastDueDate_produceDistinctMessages() async {
        let emptyTitleEnv = makeSUT()
        emptyTitleEnv.viewModel.title = ""
        emptyTitleEnv.viewModel.dueDate = Date().addingTimeInterval(3600)
        await emptyTitleEnv.viewModel.submit()

        let pastDueEnv = makeSUT()
        pastDueEnv.viewModel.title = "Valid"
        pastDueEnv.viewModel.dueDate = Date().addingTimeInterval(-3600)
        await pastDueEnv.viewModel.submit()

        #expect(emptyTitleEnv.viewModel.errorMessage != pastDueEnv.viewModel.errorMessage)
    }
}
