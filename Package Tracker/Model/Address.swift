//
//  Address.swift
//  Package Tracker
//
//  Created by Sean Ogden Power on 12/6/18.
//  Copyright © 2018 Sean Ogden Power. All rights reserved.
//

import Foundation
struct Address : Codable {
    var streetAddress : String
    var suburb : String
    var state : String
    var postcode : String
    
    var description :String {
        var description = "\(streetAddress)"
        if suburb != "" {
            description += ", \(suburb) \(state) \(postcode)"
        }
        return description
    }
}
