//
//  EndPoints.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 1.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import Foundation

struct EndPoints {
    static let feed = "https://apiuat.casino.com/lobby/gamefeeds/au/mobile/notflix/?env=stg"
    
    struct Images {
        static let baseUrl = "https://cache.mansion.com/shared/lobby/web/games/"
        
        enum Size:String {
            case small  = "200x200/"
            case medium = "251x147/"
            case large  = "545x255/"
        }
        
        enum ResourceType:String {
            case jpg = ".jpg"
        }
    }
    
    static let game = "https://devplay.casino.com/igaming/"
}


extension EndPoints {
    public static func getFeedURL() -> URL {
        return URL(string: EndPoints.feed)!
    }
    
    public static func getImageUrl(size:EndPoints.Images.Size, gameCode:String) -> URL? {
        let urlString = EndPoints.Images.baseUrl + size.rawValue + EndPoints.Images.ResourceType.jpg.rawValue
        return URL(string:urlString)
    }
    
    public static func getGameUrl(gameCode:String) -> URL? {
        let urlString = EndPoints.game + gameCode + "/"
        return URL(string: urlString)
    }
}
