//
//  ExerciceRepositoryTests.swift
//  AristaTests
//
//  Created by Sarah Maimoun on 28/03/2026.
//
import XCTest
import CoreData
@testable import Arista

final class ExerciseRepositoryTests: XCTestCase {

    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Exercise.fetchRequest()

        let objects = try! context.fetch(fetchRequest)

        for exercise in objects {
            context.delete(exercise)
        }

        try! context.save()
    }

    private func addExercise(
        context: NSManagedObjectContext,
        category: String,
        duration: Int,
        intensity: Int,
        startDate: Date,
        userFirstName: String,
        userLastName: String
    ) {
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName

        try! context.save()

        let newExercise = Exercise(context: context)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.startDate = startDate
        newExercise.user = newUser

        try! context.save()
    }

    func test_WhenNoExerciseIsInDatabase_GetExercise_ReturnEmptyList() {
        let persistenceController = PersistenceController(inMemory: true)

        emptyEntities(context: persistenceController.container.viewContext)

        let data = ExerciseRepository(viewContext: persistenceController.container.viewContext)

        let exercises = try! data.getExercise()

        XCTAssertTrue(exercises.isEmpty)
    }

    func test_WhenAddingOneExerciseInDatabase_GetExercise_ReturnAListContainingTheExercise() {
        let persistenceController = PersistenceController(inMemory: true)

        emptyEntities(context: persistenceController.container.viewContext)

        let date = Date()

        addExercise(
            context: persistenceController.container.viewContext,
            category: "Football",
            duration: 10,
            intensity: 5,
            startDate: date,
            userFirstName: "Eric",
            userLastName: "Marcus"
        )

        let data = ExerciseRepository(viewContext: persistenceController.container.viewContext)

        let exercises = try! data.getExercise()

        XCTAssertFalse(exercises.isEmpty)
        XCTAssertEqual(exercises.first?.category, "Football")
        XCTAssertEqual(exercises.first?.duration, 10)
        XCTAssertEqual(exercises.first?.intensity, 5)
        XCTAssertEqual(exercises.first?.startDate, date)
    }

    func test_WhenAddingMultipleExerciseInDatabase_GetExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        let persistenceController = PersistenceController(inMemory: true)

        emptyEntities(context: persistenceController.container.viewContext)

        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60 * 60 * 24))
        let date3 = Date(timeIntervalSinceNow: -(60 * 60 * 24 * 2))

        addExercise(
            context: persistenceController.container.viewContext,
            category: "Football",
            duration: 10,
            intensity: 5,
            startDate: date1,
            userFirstName: "Erica",
            userLastName: "Marcusi"
        )

        addExercise(
            context: persistenceController.container.viewContext,
            category: "Running",
            duration: 120,
            intensity: 1,
            startDate: date3,
            userFirstName: "Erice",
            userLastName: "Marceau"
        )

        addExercise(
            context: persistenceController.container.viewContext,
            category: "Fitness",
            duration: 30,
            intensity: 5,
            startDate: date2,
            userFirstName: "Frédéricd",
            userLastName: "Marcus"
        )

        let data = ExerciseRepository(viewContext: persistenceController.container.viewContext)

        let exercises = try! data.getExercise()

        XCTAssertEqual(exercises.count, 3)
        XCTAssertEqual(exercises[0].category, "Football")
        XCTAssertEqual(exercises[1].category, "Fitness")
        XCTAssertEqual(exercises[2].category, "Running")
    }

    func test_WhenUsingAddExercise_Method_ExerciseIsSavedInDatabase() {
        let persistenceController = PersistenceController(inMemory: true)

        emptyEntities(context: persistenceController.container.viewContext)

        let repository = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        let date = Date()

        try! repository.addExercise(
            category: "Natation",
            duration: 45,
            intensity: 7,
            startDate: date
        )

        let exercises = try! repository.getExercise()

        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.category, "Natation")
        XCTAssertEqual(exercises.first?.duration, 45)
        XCTAssertEqual(exercises.first?.intensity, 7)
        XCTAssertEqual(exercises.first?.startDate, date)
    }
    func test_WhenDeletingOneExercise_TheExerciseIsRemovedFromDatabase() {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext

        emptyEntities(context: context)

        addExercise(
            context: context,
            category: "Football",
            duration: 10,
            intensity: 5,
            startDate: Date(),
            userFirstName: "Eric",
            userLastName: "Marcus"
        )

        let repository = ExerciseRepository(viewContext: context)
        let exercisesBeforeDelete = try! repository.getExercise()

        XCTAssertEqual(exercisesBeforeDelete.count, 1)

        try! repository.deleteExercise(exercisesBeforeDelete[0])

        let exercisesAfterDelete = try! repository.getExercise()

        XCTAssertTrue(exercisesAfterDelete.isEmpty)
    }
}
