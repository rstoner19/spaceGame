//
//  Constants.swift
//  Space Cat
//
//  Created by Rick Stoner on 12/19/16.
//  Copyright © 2016 Rick Stoner. All rights reserved.
//

import Foundation

struct Constants {
    static let ProjectileSpeed: Float = 400
    static let SpaceDogMaxSpeed = -50
    static let SpaceDogMinSpeed = -100
    static let pointPerHit = 100
    static let lives = 3
    static let fontText = "Futura-CondensedExtraBold"
    
    // creates a bitmask that assigns a bit for each node that you can use to help with detection of collisions.  Think of it as a grid, where you havee 0001, 0010... ect.
    struct CollisionCategory: OptionSet {
        let rawValue: UInt32
        
        static let Enemy = CollisionCategory(rawValue: 1 << 0)
        static let Projectile = CollisionCategory(rawValue: 1 << 1)
        static let Debris = CollisionCategory(rawValue: 1 << 2)
        static let Ground = CollisionCategory(rawValue: 1 << 3)
    }
    
    static func randomWithMin(max: Int, min: Int) -> (Int) {
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
}

