//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker("Catégorie", selection: $viewModel.category) {
                        Text("Football").tag("Football")
                        Text("Natation").tag("Natation")
                        Text("Running").tag("Running")
                        Text("Marche").tag("Marche")
                        Text("Cyclisme").tag("Cyclisme")
                    }
                    .pickerStyle(.menu)
                    
                    DatePicker(
                        "Heure de démarrage",
                        selection: $viewModel.startTime,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    
                    Stepper("Durée : \(viewModel.duration) min",
                            value: $viewModel.duration,
                            in: 0...300)
                    
                    Stepper("Intensité : \(viewModel.intensity)",
                            value: $viewModel.intensity,
                            in: 0...10)
                }
                .formStyle(.grouped)
                
                Spacer()
                
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button("Ajouter l'exercice") {
                    if viewModel.addExercise() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
