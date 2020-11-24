//
//  APIConnection.swift
//  Deloitte Challenge
//
//  Created by Lu Quoc Man on 11/23/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import Foundation


// Basic Config
var malFunctionedAPIResponses = [APIEndpoint]()

// Enpoint URL's
enum APIEndpoint: String {
    
    // Set Domain
    case void = "Deloitte"
    struct Domain {
        
        static let baseUrl: String = "http://www.omdbapi.com"
        enum Name {
            case Primary
        }
    }
    // SURVEY CHECKING
    case root =  ""
    var url: URL? {
        
        return URL(string: self.rawValue)
    }
    
    var string: String {
        return self.rawValue
    }
}
