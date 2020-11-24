//
//  Parser.swift
//  Deloitte Challenge
//
//  Created by Lu Quoc Man on 11/23/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import Foundation

struct Parser {
    
    static func parse<T: Decodable>(_ data: Data?) -> T? {
        
        // Validation
        guard let _data = data else {
            print("Parse error")
            return nil
        }
        
        // Parsing
        do {
            let modal = try JSONDecoder().decode(T.self, from: _data)
            return modal
        } catch {
            
            print(error)
            return nil
        }
    }
}
