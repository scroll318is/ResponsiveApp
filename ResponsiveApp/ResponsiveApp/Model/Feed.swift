//
//  Feed.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 1.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import Foundation

struct Feed: Codable {
    let feedID:Int
    let name:String
    let definition:String
    let platform:String
    
    enum CodingKeys:String, CodingKey {
        case feedID = "id"
        case name = "name"
        case definition = "description"
        case platform = "platform"
    }
}
