//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

import CoreData


class ExerciseListViewModel: ObservableObject {
    @Published var exercises = [Exercise]()
    var viewContext: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchExercises()
    }
    func fetchExercises() {
        do {
            let data = ExerciseRepository(viewContext: viewContext)
            exercises = try data.getExercise()
        } catch {
            
        }
       
    }
    func deleteExercise(at offsets: IndexSet) {
        do {
            let repository = ExerciseRepository(viewContext: viewContext)

            for index in offsets {
                let exercise = exercises[index]
                try repository.deleteExercise(exercise)
            }

            fetchExercises()
        } catch {
            print("Erreur suppression exercice : \(error)")
        }
    }

    func reload() {
        fetchExercises()
    }
    }


