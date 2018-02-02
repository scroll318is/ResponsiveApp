//
//  Game.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 1.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import Foundation

struct Game:Codable {
    let id:Int
    let name:String
    let gameCode:String
    let displayOrder:Int
    
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case name = "name"
        case gameCode = "game_code"
        case displayOrder = "display_order"
    }
}
