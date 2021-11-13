//
//  Persistence.swift
//  WalkIt
//
//  Created by Bilal Amir on 2021-11-08.
//


import Foundation
import CoreData

struct PersistenceController {
    //singleton instance
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        return result
    }()
    
    let container : NSPersistentContainer
    
    init(inMemory: Bool = false){
        container = NSPersistentContainer(name: "WalkIt")
        
        if inMemory{
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?{
                print("Unable to access CoreData UserDB. \(error)")
            }
        })
    }
    
}
