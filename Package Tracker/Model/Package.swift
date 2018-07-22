//
//  Package.swift
//  Package Tracker
//
//  Created by Sean Ogden Power on 12/6/18.
//  Copyright © 2018 Sean Ogden Power. All rights reserved.
//

import Foundation

class Package: Codable {
    var status : Status
    var statusUpdated : Date?
    var trackingNo : String?
    var recipientName : String
    var deliveryAddress : Address
    var deliveredDate : Date?
    var notes : String?
    
    init (status: Status, statusUpdated : Date, trackingNo: String?, recipientName: String, deliveryAddress : Address, notes : String?)
    {
        self.status = status
        self.statusUpdated = statusUpdated
        self.trackingNo = trackingNo
        self.recipientName = recipientName
        self.deliveryAddress = deliveryAddress
        self.notes = notes
    }
    
    func updateStatus (to status: Status)
    {
        self.status = status
        statusUpdated = Date()
        if status == .delivered {deliveredDate = Date()}
    }
    
    func delivered ()
    {
        updateStatus (to: .delivered)
    }
    
    static func deleteOldPackages (packages: [Package]) -> [Package]
    {
        var compareDate = Date()
        compareDate.addTimeInterval(-604800)
        let returnPackages = packages.filter ({
            if let deliveredDate = $0.deliveredDate {
                return deliveredDate >= compareDate
            }else{return true}
        })
        return returnPackages
    }
    
    static func loadPackages() -> [Package]? {
        guard let packages = try? Data(contentsOf: Utils.ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder ()
        return try? propertyListDecoder.decode(Array<Package>.self, from: packages)
    }
    
    static func savePackages (_ packages: [Package]) {
        let propertyListEncoder = PropertyListEncoder ()
        let codedToDos = try? propertyListEncoder.encode(packages)
        try? codedToDos?.write (to: Utils.ArchiveURL, options: .noFileProtection)
    }
    
    //used for testing
    static func defaultPackages () -> [Package]
    {
        var packages : [Package] = []
        let package = Package (status: .pending,
                               statusUpdated: Date(),
                               trackingNo: "",
                               recipientName: "Peter Parker",
                               deliveryAddress: Address (streetAddress: "1 Avengers Way", suburb: "Manhattan", state: "VIC", postcode: "3000"),
                               notes: "")
        packages.append(package)
        
        return packages
        
    }
}

enum Status : String, Codable {
    case pending = "Awaiting Pickup"
    case onroute = "Out for Delivery"
    case delivered = "Delivered"
}
