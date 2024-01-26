//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI
import CoreData

class UserDataViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserData()
    }

    private func fetchUserData() {
        do {
            guard let user = try UserRepository(viewContext: viewContext).getUser() else {
                return
            }

            firstName = user.firstName ?? ""
            lastName = user.lastName ?? ""
            email = user.email ?? ""
        } catch {
        }
    }
}
