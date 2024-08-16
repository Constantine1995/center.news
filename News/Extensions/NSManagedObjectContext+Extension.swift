//
//  NSManagedObjectContext+Extension.swift
//  News
//
//  Created by Constantine Likhachov on 15.08.2024.
//

import CoreData

extension NSManagedObjectContext {
    func saveContext() {
        do {
            try save()
        } catch {
            print("Failure to save context: \(error)")
        }
    }
}
