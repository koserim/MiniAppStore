//
//  PersistenceManager.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/01.
//

import Foundation
import CoreData
import Combine

class PersistenceManager {
    
    static var shared: PersistenceManager = PersistenceManager()
    
    let updated: PassthroughSubject<Void, Never> = .init()
    
    private lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "MiniAppStore")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private var result: [KeywordMO] {
        let request = KeywordMO.fetchRequest()
        return fetch(request: request)
    }
    
    private init() { }
    
    private func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print("fetch error \(error.localizedDescription)")
            return []
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @discardableResult
    func insert(keyword: Keyword) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Keyword", in: context)
        guard let entity = entity else { return false }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(keyword.value, forKey: "value")
        
        do {
            try context.save()
            updated.send()
            return true
        } catch {
            print("insert error \(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func delete(keyword: Keyword) -> Bool {
        let deleteObject = result.first { $0.value == keyword.value }
        
        if let deleteObject = deleteObject {
            return delete(object: deleteObject)
        } else {
            return false
        }
    }
    
    @discardableResult
    private func delete(object: NSManagedObject) -> Bool {
        context.delete(object)
        do {
            try context.save()
            updated.send()
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    private func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(delete)
            updated.send()
            return true
        } catch {
            print("delete all error \(error.localizedDescription)")
            return false
        }
    }
    
    func getKeywords() -> [Keyword] {
        return result.compactMap { getKeyword(from: $0) }
    }
    
    private func getKeyword(from data: KeywordMO) -> Keyword? {
        if let value = data.value(forKey: "value") as? String {
            return Keyword(value: value)
        }
        return nil
    }
    
}
