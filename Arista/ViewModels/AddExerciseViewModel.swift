//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class AddExerciseViewModel: ObservableObject {
    @Published var category: String = ""
    @Published var startTime: Date = Date()
    @Published var duration: Int = 0
    @Published var intensity: Int = 0
    @Published var errorMessage: String = ""

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    private func isFormValid() -> Bool {
        if category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Veuillez choisir une catégorie."
            return false
        }

        if duration <= 0 {
            errorMessage = "La durée doit être supérieure à 0 minute."
            return false
        }

        if intensity < 0 || intensity > 10 {
            errorMessage = "L'intensité doit être comprise entre 0 et 10."
            return false
        }

        errorMessage = ""
        return true
    }

    func addExercise() -> Bool {
        guard isFormValid() else { return false }

        do {
            try ExerciseRepository(viewContext: viewContext).addExercise(
                category: category,
                duration: duration,
                intensity: intensity,
                startDate: startTime
            )
            errorMessage = ""
            return true
        } catch {
            errorMessage = "Impossible d'ajouter l'exercice."
            return false
        }
    }
}
