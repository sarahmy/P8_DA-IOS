//
//  SleepRepository.swift
//  Arista
//
//  Created by Sarah Maimoun on 22/03/2026.
//


import Foundation
import CoreData

struct SleepRepository {
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }

    func getSleepSessions() throws -> [Sleep] {
        let request = Sleep.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: false)
        ]
        return try viewContext.fetch(request)
    }
}

