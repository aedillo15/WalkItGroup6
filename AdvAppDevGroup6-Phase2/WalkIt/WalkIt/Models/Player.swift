//
//  Player.swift
//  WalkIt
//
//  Created by user on 2021-10-29.
//

import Foundation

class Player: ObservableObject{
    var id = UUID()
    var username: String = ""
    var tokenCount : Int = 0 // Number of tokens (score) the player has
    var email: String = ""
    var password: String = ""

    
    init() {
        
    }
    
    init(username: String, email: String, password: String) {

        //self.tokenCount = 0
        self.username = username
        self.email = email
        self.password = password
    }
}
