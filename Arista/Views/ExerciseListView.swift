//
//  ExerciseListView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseListViewModel
    @State private var showingAddExerciseView = false

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                List {
                    ForEach(viewModel.exercises) { exercise in
                        HStack(alignment: .top, spacing: 12) {

                            Image(systemName: iconForCategory(exercise.category ?? ""))
                                .font(.title3)
                                .foregroundColor(AppTheme.primary)
                                .frame(width: 36, height: 36)
                                .background(AppTheme.secondary.opacity(0.2))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 6) {
                                Text(exercise.category ?? "Exercice")
                                    .font(.headline)

                                Text("Durée : \(Int(exercise.duration)) min")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.textSecondary)

                                Text(exercise.startDate?.formatted() ?? "")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(AppTheme.cardBackground)
                    }
                    .onDelete(perform: viewModel.deleteExercise)
                }
                .scrollContentBackground(.hidden)
                .background(AppTheme.background)
            }
            .navigationTitle("Exercices")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddExerciseView = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(AppTheme.primary)
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(isPresented: $showingAddExerciseView, onDismiss: {
                viewModel.reload()
            }) {
                AddExerciseView(
                    viewModel: AddExerciseViewModel(context: viewModel.viewContext)
                )
            }
            .onAppear {
                viewModel.reload()
            }
        }
    }

    func iconForCategory(_ category: String) -> String {
        switch category {
        case "Football":
            return "sportscourt"
        case "Natation":
            return "waveform.path.ecg"
        case "Running":
            return "figure.run"
        case "Marche":
            return "figure.walk"
        case "Cyclisme":
            return "bicycle"
        default:
            return "questionmark"
        }
    }
}

#Preview {
    ExerciseListView(viewModel: ExerciseListViewModel(context: PersistenceController.preview.container.viewContext))
}
