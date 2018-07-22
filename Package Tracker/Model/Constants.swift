//
//  Constants.swift
//
//  Created by Sean Ogden Power
//  Copyright © 2018 Sean Ogden Power. All rights reserved.
//

import Foundation
import UIKit

struct Utils {
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("packageTracker").appendingPathExtension("plist")
  
    static let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let lightBlue = UIColor (red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 0.95)
    static let turquoise = UIColor (red: 109.0/255.0, green: 215.0/255.0, blue: 186.0/255.0, alpha: 1.0)
    static let darkGrey = UIColor (red: 23.0/255.0, green: 30.0/255.0, blue: 38.0/255.0, alpha: 0.95)
    static let darkTeal = UIColor (red: 19.0/255.0, green: 57.0/255.0, blue: 62.0/255.0, alpha: 0.95)
    static let lightTeal = UIColor (red: 209.0/255.0, green: 240.0/255.0, blue: 247.0/255.0, alpha: 0.95)
    static let blue = UIColor (red: 56.0/255.0, green: 112/255.0, blue: 176/255.0, alpha: 1.0)
    static let darkBlue = UIColor (red: 61.0/255.0, green: 80/255.0, blue: 103/255.0, alpha: 1.0)
    static let darkTurquoise = UIColor (red: 85.0/255.0, green: 159/255.0, blue: 181/255.0, alpha: 1.0 )
    static let whiteOverlay = UIColor (red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
}
