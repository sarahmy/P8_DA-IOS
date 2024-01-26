//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct UserDataView: View {
    @ObservedObject var viewModel: UserDataViewModel

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                Text("Mon profil")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.primary)

                VStack(alignment: .leading, spacing: 16) {

                    Label("Utilisateur", systemImage: "person.crop.circle.fill")
                        .foregroundColor(AppTheme.primary)
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Prénom")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)

                        Text(viewModel.firstName.isEmpty ? "Non renseigné" : viewModel.firstName)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)

                        Text(viewModel.email.isEmpty ? "Non renseigné" : viewModel.email)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nom")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)

                        Text(viewModel.lastName.isEmpty ? "Non renseigné" : viewModel.lastName)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
                .aristaCard()

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    UserDataView(viewModel: UserDataViewModel(context: PersistenceController.preview.container.viewContext))
}
