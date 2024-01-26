//
//  UserRepositoryTests.swift
//  AristaTests
//
//  Created by Sarah Maimoun on 29/03/2026.
//

import XCTest
import CoreData
@testable import Arista

final class UserRepositoryTests: XCTestCase {

    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = User.fetchRequest()

        let objects = try! context.fetch(fetchRequest)

        for user in objects {
            context.delete(user)
        }

        try! context.save()
    }

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

    func test_WhenNoUserIsInDatabase_GetUser_ReturnNil() {
        let persistenceController = PersistenceController(inMemory: true)

        emptyEntities(context: persistenceController.container.viewContext)

        let repository = UserRepository(viewContext: persistenceController.container.viewContext)

        let user = try! repository.getUser()

        XCTAssertNil(user)
    }

    func test_WhenOneUserIsInDatabase_GetUser_ReturnTheUser() {
        let persistenceController = PersistenceController(inMemory: true)

        emptyEntities(context: persistenceController.container.viewContext)

        addUser(
            context: persistenceController.container.viewContext,
            firstName: "Sarah",
            lastName: "Maimoun"
        )

        let repository = UserRepository(viewContext: persistenceController.container.viewContext)

        let user = try! repository.getUser()

        XCTAssertNotNil(user)
        XCTAssertEqual(user?.firstName, "Sarah")
        XCTAssertEqual(user?.lastName, "Maimoun")
    }
}
