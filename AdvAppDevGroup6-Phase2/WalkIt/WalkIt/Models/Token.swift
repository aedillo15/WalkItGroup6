//
//  Token.swift
//  WalkIt
//
//  Created by user on 2021-10-29.
//

import Foundation

class Token{
    var id = UUID()
    var xPos: Double = 0
    var yPos : Double = 0
    var isAvailable = true //I made this variable assuming when a user collects a token, they will not be able to collect that token again for x amount of time.  This bariable determines at any point if the variable is collectable
    
    init() {
        
    }
    
    init(xPos: Double, yPos: Double) {
        self.xPos = xPos
        self.yPos = yPos
        self.isAvailable = true // All tokens default to available upon their creation
    }
    
    func collect(player: Player){
        //When player is in range of a token, they can click on it to invoke this function
        if (inRange(player: player)){
            self.isAvailable = false
        }
        
    }
            
    func inRange(player: Player) -> Bool {
                //Coordinate calculations on player.xPos/yPos and self.xPos/yPos to determine if its in range
                //Return true or false
                return false
            }
}
