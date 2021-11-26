//
//  PlayerMO.swift
//  WalkIt
//
//  Created by Bilal Amir on 2021-11-08.
//

import Foundation
import CoreData

@objc(PlayerMO)
final class PlayerMO: NSManagedObject{
    @NSManaged var id: UUID?
    @NSManaged var username: String
    @NSManaged var email: String
    @NSManaged var password: String
    @NSManaged var tokencount: Int
}

extension PlayerMO{
    func convertToPlayer() -> Player{
        Player(username: username, email: email, password: password)
    }
}

