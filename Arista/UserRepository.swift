//
//  UserRepository.swift
//  Arista
//
//  Created by Sarah Maimoun on 22/03/2026.
//

import Foundation
import CoreData


struct UserRepository {
    let viewContext: NSManagedObjectContext
    init (viewContext: NSManagedObjectContext =
          PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
        func getUser () throws -> User? {
        let request = User.fetchRequest ()
        request.fetchLimit = 1
        return try viewContext.fetch(request).first
    }}
