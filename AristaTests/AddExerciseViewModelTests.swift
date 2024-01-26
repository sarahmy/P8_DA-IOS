//
//  AddExerciseViewModelTests.swift
//  AristaTests
//
//  Created by Sarah Maimoun on 29/03/2026.
//

import XCTest
import CoreData
@testable import Arista

final class FailingManagedObjectContext: NSManagedObjectContext {
    override func save() throws {
        throw NSError(domain: "TestError", code: 999, userInfo: nil)
    }
}
final class AddExerciseViewModelTests: XCTestCase {

    func test_WhenViewModelIsCreated_DefaultValuesAreCorrect() {
        let persistenceController = PersistenceController(inMemory: true)

        let viewModel = AddExerciseViewModel(
            context: persistenceController.container.viewContext
        )

        XCTAssertEqual(viewModel.category, "")
        XCTAssertEqual(viewModel.duration, 0)
        XCTAssertEqual(viewModel.intensity, 0)
    }

    func test_WhenAddingExerciseWithValidData_AddExerciseReturnsTrue() {
        let persistenceController = PersistenceController(inMemory: true)

        emptyExercises(context: persistenceController.container.viewContext)

        let viewModel = AddExerciseViewModel(
            context: persistenceController.container.viewContext
        )

        viewModel.category = "Football"
        viewModel.duration = 45
        viewModel.intensity = 7
        viewModel.startTime = Date()

        let result = viewModel.addExercise()

        XCTAssertEqual(result, true)

        let repository = ExerciseRepository(
            viewContext: persistenceController.container.viewContext
        )
        let exercises = try! repository.getExercise()

        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.category, "Football")
        XCTAssertEqual(exercises.first?.duration, 45)
        XCTAssertEqual(exercises.first?.intensity, 7)
    }

    func test_WhenAddingExerciseWithEmptyCategory_AddExerciseReturnsTrue() {
        let persistenceController = PersistenceController(inMemory: true)

        emptyExercises(context: persistenceController.container.viewContext)

        let viewModel = AddExerciseViewModel(
            context: persistenceController.container.viewContext
        )

        viewModel.category = ""
        viewModel.duration = 30
        viewModel.intensity = 5
        viewModel.startTime = Date()

        let result = viewModel.addExercise()

        XCTAssertEqual(result, false)

        let repository = ExerciseRepository(
            viewContext: persistenceController.container.viewContext
        )
        let exercises = try! repository.getExercise()

        XCTAssertEqual(exercises.count, 0)
        XCTAssertNil(exercises.first)
    }
    
    func test_WhenDurationIsZero_AddExercise_ReturnFalse() {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext

        emptyExercises(context: context)

        let viewModel = AddExerciseViewModel(context: context)
        viewModel.category = "Running"
        viewModel.duration = 0
        viewModel.intensity = 5
        viewModel.startTime = Date()

        let result = viewModel.addExercise()

        XCTAssertFalse(result)

        let request = Exercise.fetchRequest()
        let exercises = try! context.fetch(request)

        XCTAssertEqual(exercises.count, 0)
        XCTAssertNil(exercises.first)
    }
    func test_WhenIntensityIsZero_AddExercise_ReturnTrue() {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext

        emptyExercises(context: context)

        let viewModel = AddExerciseViewModel(context: context)
        viewModel.category = "Cycling"
        viewModel.duration = 30
        viewModel.intensity = 0
        viewModel.startTime = Date()

        let result = viewModel.addExercise()

        XCTAssertTrue(result)

        let request = Exercise.fetchRequest()
        let exercises = try! context.fetch(request)

        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.intensity, 0)
    }

    func test_WhenContextSaveFails_AddExercise_ReturnFalse() {
        let persistenceController = PersistenceController(inMemory: true)

        let failingContext = FailingManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType
        )
        failingContext.persistentStoreCoordinator =
            persistenceController.container.persistentStoreCoordinator

        let viewModel = AddExerciseViewModel(context: failingContext)
        viewModel.category = "Football"
        viewModel.duration = 45
        viewModel.intensity = 5
        viewModel.startTime = Date()

        let result = viewModel.addExercise()

        XCTAssertFalse(result)
    }
    // MARK: - Helpers

    private func emptyExercises(context: NSManagedObjectContext) {
        let request = Exercise.fetchRequest()
        let exercises = try! context.fetch(request)

        for exercise in exercises {
            context.delete(exercise)
        }

        try! context.save()
    }
    func test_WhenExerciseDataIsValid_AddExercise_ReturnTrue() {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext

        emptyExercises(context: context)

        let viewModel = AddExerciseViewModel(context: context)
        viewModel.category = "Football"
        viewModel.duration = 45
        viewModel.intensity = 5
        viewModel.startTime = Date()

        let result = viewModel.addExercise()

        XCTAssertTrue(result)

        let request = Exercise.fetchRequest()
        let exercises = try! context.fetch(request)

        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.category, "Football")
        XCTAssertEqual(exercises.first?.duration, 45)
        XCTAssertEqual(exercises.first?.intensity, 5)
    }
}
