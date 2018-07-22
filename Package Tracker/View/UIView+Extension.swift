//
//  UIView+Extension.swift
//
//  Created by Sean Ogden Power
//  Copyright © 2018 Sean Ogden Power. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func setGradientBackground (colorOne: UIColor, colorTwo: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint (x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint (x: 0.0, y: 0.0)
        
        if let tableView = self as? UITableView {
            let backgroundView = UIView(frame: tableView.bounds)
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            tableView.backgroundView = backgroundView
        }else{
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
   
    
    func roundCorners (){
        self.layer.cornerRadius = 8
    }
    
}
