//
//  SleepHistoryViewModelTests.swift
//  AristaTests
//
//  Created by Sarah Maimoun on 29/03/2026.
//

import XCTest
import CoreData
@testable import Arista

final class SleepHistoryViewModelTests: XCTestCase {

    func test_WhenNoSleepSessionsInDatabase_FetchSleepSessions_ReturnEmptyList() {
        let persistenceController = PersistenceController(inMemory: true)

        emptySleepSessions(context: persistenceController.container.viewContext)

        let viewModel = SleepHistoryViewModel(
            context: persistenceController.container.viewContext
        )

        XCTAssertEqual(viewModel.sleepSessions.count, 0)
    }

    func test_WhenOneSleepSessionInDatabase_FetchSleepSessions_ReturnOneSleepSession() {
        let persistenceController = PersistenceController(inMemory: true)

        emptySleepSessions(context: persistenceController.container.viewContext)

        addSleepSession(
            context: persistenceController.container.viewContext,
            duration: 480,
            quality: 8,
            startDate: Date()
        )

        let viewModel = SleepHistoryViewModel(
            context: persistenceController.container.viewContext
        )

        XCTAssertEqual(viewModel.sleepSessions.count, 1)
        XCTAssertEqual(viewModel.sleepSessions.first?.duration, 480)
        XCTAssertEqual(viewModel.sleepSessions.first?.quality, 8)
    }

    func test_WhenSeveralSleepSessionsInDatabase_FetchSleepSessions_ReturnOrderedList() {
        let persistenceController = PersistenceController(inMemory: true)

        emptySleepSessions(context: persistenceController.container.viewContext)

        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60 * 60 * 24))
        let date3 = Date(timeIntervalSinceNow: -(60 * 60 * 24 * 2))

        addSleepSession(
            context: persistenceController.container.viewContext,
            duration: 480,
            quality: 8,
            startDate: date3
        )

        addSleepSession(
            context: persistenceController.container.viewContext,
            duration: 420,
            quality: 6,
            startDate: date1
        )

        addSleepSession(
            context: persistenceController.container.viewContext,
            duration: 450,
            quality: 7,
            startDate: date2
        )

        let viewModel = SleepHistoryViewModel(
            context: persistenceController.container.viewContext
        )

        XCTAssertEqual(viewModel.sleepSessions.count, 3)
        XCTAssertEqual(viewModel.sleepSessions[0].duration, 420)
        XCTAssertEqual(viewModel.sleepSessions[1].duration, 450)
        XCTAssertEqual(viewModel.sleepSessions[2].duration, 480)
    }

    // MARK: - Helpers

    private func emptySleepSessions(context: NSManagedObjectContext) {
        let request = Sleep.fetchRequest()
        let sleeps = try! context.fetch(request)

        for sleep in sleeps {
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
}
