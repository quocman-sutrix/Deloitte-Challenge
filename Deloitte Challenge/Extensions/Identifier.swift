//
//  Identifier.swift
//  Deloitte Challenge
//
//  Created by Lu Quoc Man on 11/25/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    
    // Fetch controller name
    static var identifier: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

/*extension UICollectionViewCell {
    
    // Fetch controller name
    static var identifier: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

extension UIViewController {
    
    // Fetch controller name
    static var identifier: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}*/
