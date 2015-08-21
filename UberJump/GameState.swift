//
//  GameState.swift
//  UberJump
//
//  Created by Alexander Frolov on 04/02/15.
//  Copyright (c) 2015 Alexander Frolov. All rights reserved.
//

import Foundation

class GameState {
    var score = 0
    var highScore = 0
    var stars = 0
    
    class var sharedInstance: GameState {
        struct Singleton {
            static let instance = GameState()
        }
        return Singleton.instance
    }
    
    init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        highScore = defaults.integerForKey("highScore")
        stars     = defaults.integerForKey("stars")
    }
    
    func saveState() {
        highScore = max(score, highScore)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(highScore, forKey: "highScore")
        defaults.setInteger(stars, forKey: "stars")
        defaults.synchronize()
    }
}
