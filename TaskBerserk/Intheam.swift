//
//  Intheam.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation

struct Intheam {
    static let apiURL = "https://inthe.am/api/v1/"
    
    static var requestParameters: [String: AnyObject] {
        return [
            "Authorization": Config.apiKey
        ]
    }
}

extension Intheam {
    struct Config {
        static let apiKey = Intheam.getAppKey()
    }
    
    // Searchs in AppKey.plist key Intheam and returns it
    private static func getAppKey() -> String {
        guard let path = NSBundle.mainBundle().pathForResource("AppKey", ofType: "plist") else {
            fatalError("App should provide Intheam API key in the AppKey.plist:Intheam")
        }

        let key = NSDictionary(contentsOfFile: path)?["Intheam"]
        
        guard let apiKey = key as? String else {
            fatalError("App should provide Intheam API key in the AppKey.plist:Intheam")
        }
        
        return apiKey
    }
}
