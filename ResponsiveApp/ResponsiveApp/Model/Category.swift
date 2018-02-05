//
//  Category.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 1.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import Foundation

struct GameCategory: Codable {
    let categoryId:Int
    let name:String
    let definition:String
    let displayOrder:Int
    let games:[Game]
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case name = "name"
        case definition = "description"
        case displayOrder = "display_order"
        case games
    }
    
    func encode(to encoder: Encoder) throws {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.categoryId = try container.decode(Int.self, forKey: .categoryId)
        self.name = try container.decode(String.self, forKey: .name)
        self.definition = try container.decode(String.self, forKey: .definition)
        self.displayOrder = try container.decode(Int.self, forKey: .displayOrder)
        self.games = try container.decode([Game].self, forKey: .games)
    }
}
