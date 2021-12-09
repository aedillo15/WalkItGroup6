//
//  CoreDBHelper.swift
//  WalkIt
//
//  Created by Bilal Amir on 2021-11-08.
//
import Foundation
import CoreData


class CoreDBHelper : ObservableObject{
    
    @Published var playerList = [PlayerMO]()
    
    private let ENTITY_NAME = "PlayerMO"
    private let MOC : NSManagedObjectContext
    
    //singleton instance
    private static var shared: CoreDBHelper?
    
    static func getInstance() -> CoreDBHelper{
        if shared == nil{
            shared = CoreDBHelper(context: PersistenceController.preview.container.viewContext)
        }
        return shared!
    }
    
    init(context: NSManagedObjectContext) {
        self.MOC = context
    }
    
    func insertPlayer(newPlayer: Player){
        do{
            
            
            let playerInsert = NSEntityDescription.insertNewObject(forEntityName: self.ENTITY_NAME, into: self.MOC) as! PlayerMO
            
           
            playerInsert.username = newPlayer.username
            playerInsert.email = newPlayer.email
            playerInsert.password = newPlayer.password
            playerInsert.id = UUID()
            
            
            if self.MOC.hasChanges{
                try self.MOC.save()
                print(#function, "Player has been added")
            }
            
        }catch let error as NSError{
            print(#function, "Player has not been added  \(error)")
        }
    }
    
    private func searchPlayer(playerID : UUID) -> PlayerMO?{
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        let predicateID = NSPredicate(format: "id == %@", playerID as CVarArg)

        fetchRequest.predicate = predicateID
        
        do{
            let result = try self.MOC.fetch(fetchRequest)
            
            if result.count > 0{
                return result.first as? PlayerMO
            }
            
        }catch let error as NSError{
            print(#function, "Unable to search for given ID \(error)")
        }
        
        return nil
    }
    
    func updatePlayer(updatedPlayer: PlayerMO){
        let searchResult = self.searchPlayer(playerID: updatedPlayer.id! as UUID)
        
        if (searchResult != nil){
            do{
                
                let playerToUpdate = searchResult!
                playerToUpdate.username = updatedPlayer.username
                playerToUpdate.email = updatedPlayer.email
                playerToUpdate.password = updatedPlayer.password
                
                try self.MOC.save()
                
                print(#function, "Player details updated successfully")
                
            }catch let error as NSError{
                print(#function, "Unable to search for given ID \(error)")
            }
        }else{
            print(#function, "No matching record found for given playerID \(updatedPlayer.id!)")
        }
    }
    func loginAs(username: String, password: String) -> PlayerMO?{
        let predicateID = NSPredicate(format: "username == %@ && password == %@", username, password)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        fetchRequest.predicate = predicateID
        
        var playerEntity: PlayerMO
        
        
        do{
            let result = try self.MOC.fetch(fetchRequest)

            playerEntity = result.first as! PlayerMO
            return playerEntity
  
            
        }catch let error as NSError{
            print(#function, "Unable to search for given ID \(error)")
        }
        return nil
    }
    
    
    func verifyUserExists(username: String, password: String) -> Bool{
        
        let predicateID = NSPredicate(format: "username == %@ && password == %@", username, password)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)

        fetchRequest.predicate = predicateID

        do{
            let result = try self.MOC.fetch(fetchRequest)

            if result.count > 0{
                  var playerEntity: PlayerMO = result.first as! PlayerMO
                if (playerEntity.username == username && playerEntity.password == password){
                    return true
                } else {
                    return false
                }
            }
            
        }catch let error as NSError{
            print(#function, "Unable to search for given ID \(error)")
        }

        return false
    }
        
}
    
    

