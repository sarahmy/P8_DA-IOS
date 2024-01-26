//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import SwiftUI

struct SleepHistoryView: View {
    @ObservedObject var viewModel: SleepHistoryViewModel

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                List(viewModel.sleepSessions) { session in
                    HStack(alignment: .top, spacing: 14) {

                        QualityIndicator(quality: Int(session.quality))

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Sommeil")
                                .font(.headline)

                            Text("Début : \(session.startDate?.formatted() ?? "")")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.textSecondary)

                            Text("Durée : \(Int(session.duration) / 60) heures")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.textSecondary)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(AppTheme.cardBackground)
                }
                .scrollContentBackground(.hidden)
                .background(AppTheme.background)
            }
            .navigationTitle("Historique de sommeil")
        }
    }
}

// MARK: - Indicator

struct QualityIndicator: View {
    let quality: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(qualityColor(quality), lineWidth: 4)
                .frame(width: 32, height: 32)

            Text("\(quality)")
                .font(.caption)
                .foregroundColor(qualityColor(quality))
        }
    }

    func qualityColor(_ quality: Int) -> Color {
        switch quality {
        case 8...10:
            return AppTheme.primary
        case 5...7:
            return AppTheme.secondary
        case 0...4:
            return AppTheme.border
        default:
            return AppTheme.textSecondary
        }
    }
}

#Preview {
    SleepHistoryView(viewModel: SleepHistoryViewModel(context: PersistenceController.preview.container.viewContext))
}
