//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by Sarah Maimoun on 29/03/2026.
//
import XCTest
import CoreData
@testable import Arista

final class UserDataViewModelTests: XCTestCase {

    func test_WhenOneUserExistsInDatabase_FetchUserData_ReturnUserStrings() {
        let persistenceController = PersistenceController(inMemory: true)

        addUser(
            context: persistenceController.container.viewContext,
            firstName: "Sarah",
            lastName: "Maimoun"
        )

        let viewModel = UserDataViewModel(
            context: persistenceController.container.viewContext
        )

        XCTAssertEqual(viewModel.firstName, "Sarah")
        XCTAssertEqual(viewModel.lastName, "Maimoun")
    }

    func test_WhenUserHasNilFirstNameAndLastName_FetchUserData_ReturnEmptyStrings() {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext

        let user = User(context: context)
        user.firstName = nil
        user.lastName = nil

        try! context.save()

        let viewModel = UserDataViewModel(context: context)

        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")
    }

    func test_WhenUserHasNilFirstNameOnly_FetchUserData_ReturnEmptyFirstNameAndValidLastName() {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext

        let user = User(context: context)
        user.firstName = nil
        user.lastName = "Maimoun"

        try! context.save()

        let viewModel = UserDataViewModel(context: context)

        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "Maimoun")
    }
    func test_WhenUserHasNilLastNameOnly_FetchUserData_ReturnValidFirstNameAndEmptyLastName() {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext

        let user = User(context: context)
        user.firstName = "Sarah"
        user.lastName = nil

        try! context.save()

        let viewModel = UserDataViewModel(context: context)

        XCTAssertEqual(viewModel.firstName, "Sarah")
        XCTAssertEqual(viewModel.lastName, "")
    }
    func test_WhenNoUserInDatabase_FetchUserData_ReturnEmptyStrings() {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext

        // IMPORTANT : ne rien ajouter en base

        let viewModel = UserDataViewModel(context: context)

        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")
    }
    // MARK: - Helpers

    private func addUser(
        context: NSManagedObjectContext,
        firstName: String,
        lastName: String
    ) {
        let user = User(context: context)
        user.firstName = firstName
        user.lastName = lastName

        try! context.save()
    }
}
