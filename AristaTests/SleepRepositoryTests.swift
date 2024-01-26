//
//  SleepRepositoryTests.swift
//  AristaTests
//
//  Created by Sarah Maimoun on 29/03/2026.
//
import XCTest
import CoreData
@testable import Arista

final class SleepRepositoryTests: XCTestCase {

    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Sleep.fetchRequest()

        let objects = try! context.fetch(fetchRequest)

        for sleep in objects {
            context.delete(sleep)
        }

        try! context.save()
    }

    private func addSleepSession(
        context: NSManagedObjectContext,
        duration: Int,
        quality: Int,
        startDate: Date
    ) {
        let sleep = Sleep(context: context)
        sleep.duration = Int64(duration)
        sleep.quality = Int64(quality)
        sleep.startDate = startDate

        try! context.save()
    }

    func test_WhenNoSleepSessionIsInDatabase_GetSleepSessions_ReturnEmptyList() {
        let persistenceController = PersistenceController(inMemory: true)

        emptyEntities(context: persistenceController.container.viewContext)

        let repository = SleepRepository(viewContext: persistenceController.container.viewContext)

        let sessions = try! repository.getSleepSessions()

        XCTAssertTrue(sessions.isEmpty)
    }

    func test_WhenAddingOneSleepSessionInDatabase_GetSleepSessions_ReturnAListContainingTheSleepSession() {
        let persistenceController = PersistenceController(inMemory: true)

        emptyEntities(context: persistenceController.container.viewContext)

        let date = Date()

        addSleepSession(
            context: persistenceController.container.viewContext,
            duration: 480,
            quality: 8,
            startDate: date
        )

        let repository = SleepRepository(viewContext: persistenceController.container.viewContext)

        let sessions = try! repository.getSleepSessions()

        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.duration, 480)
        XCTAssertEqual(sessions.first?.quality, 8)
        XCTAssertEqual(sessions.first?.startDate, date)
    }

    func test_WhenAddingMultipleSleepSessionsInDatabase_GetSleepSessions_ReturnAListInTheRightOrder() {
        let persistenceController = PersistenceController(inMemory: true)

        emptyEntities(context: persistenceController.container.viewContext)

        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60 * 60 * 24))
        let date3 = Date(timeIntervalSinceNow: -(60 * 60 * 24 * 2))

        addSleepSession(
            context: persistenceController.container.viewContext,
            duration: 500,
            quality: 9,
            startDate: date1
        )

        addSleepSession(
            context: persistenceController.container.viewContext,
            duration: 420,
            quality: 6,
            startDate: date3
        )

        addSleepSession(
            context: persistenceController.container.viewContext,
            duration: 460,
            quality: 7,
            startDate: date2
        )

        let repository = SleepRepository(viewContext: persistenceController.container.viewContext)

        let sessions = try! repository.getSleepSessions()

        XCTAssertEqual(sessions.count, 3)
        XCTAssertEqual(sessions[0].startDate, date1)
        XCTAssertEqual(sessions[1].startDate, date2)
        XCTAssertEqual(sessions[2].startDate, date3)
    }
}
