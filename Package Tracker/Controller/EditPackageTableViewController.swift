//
//  EditPackageTableViewController.swift
//  Package Tracker
//
//  Created by Sean Ogden Power on 16/6/18.
//  Copyright © 2018 Sean Ogden Power. All rights reserved.
//

import UIKit

class EditPackageTableViewController: UITableViewController {
    @IBOutlet weak var statusControl: UISegmentedControl!
    @IBOutlet weak var recipientNameText: UITextField!
    @IBOutlet weak var streetAddressText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var postcodeText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var notesText: UITextView!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var updateDatePicker: UIDatePicker!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var deliveryDatePicker: UIDatePicker!
    @IBOutlet weak var trackingNoText: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet var trashButton: UIBarButtonItem!
    
    var selectedStatus : Status = .pending
    var package : Package?
    var blankUpdateDate : Bool = true
    var blankDeliveredDate : Bool = true
    
    var trackNoIsShown : Bool = false {
        didSet {
            trackingNoText.isHidden = !trackNoIsShown
        }
    }
    
    var updateDateIsShown : Bool = false {
        didSet {
            updateDatePicker.isHidden = !updateDateIsShown
        }
    }
    
    var deliveryDateIsShown : Bool = false {
        didSet {
            deliveryDatePicker.isHidden = !deliveryDateIsShown
        }
    }
    
    var deliveryLabelShown : Bool = false {
        didSet {
            deliveryDateLabel.isHidden = !deliveryLabelShown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setGradientBackground (colorOne: Utils.lightTeal, colorTwo: Utils.darkTeal)
        statusControl.setTitle(Status.pending.rawValue, forSegmentAt: 0)
        statusControl.setTitle(Status.onroute.rawValue, forSegmentAt: 1)
        statusControl.setTitle(Status.delivered.rawValue, forSegmentAt: 2)
        
        //You can't set the dates to after the current date/time - it wouldn't be possible!
        deliveryDatePicker.maximumDate = Date()
        updateDatePicker.maximumDate = Date ()
        
        //can't set the delivery date to earlier than 7 days ago (if you do it will disapear straight away because
        //we clear out packages delivered > 7 days
        deliveryDatePicker.minimumDate = Date().addingTimeInterval(-604800)
        
        hideTrashButton()
        displayPackage()
        updateSaveButtonState ()
        updateDateViews()
    }
  
    //MARK: - Update UI
    func updateSaveButtonState ()
    {
        if recipientNameText.text?.isEmpty ?? true || streetAddressText.text?.isEmpty ?? true || cityText.text?.isEmpty ?? true || stateText.text?.isEmpty ?? true || postcodeText.text?.isEmpty ?? true{
            saveButton.isEnabled = false
            return
        }
        
        saveButton.isEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = Utils.darkTeal
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func displayPackage ()
    {
        if let package = package {
            showTrashButton()
            navigationItem.title = "Edit Package"
            recipientNameText.text = package.recipientName
            trackingNoText.text = package.trackingNo
            streetAddressText.text = package.deliveryAddress.streetAddress
            cityText.text = package.deliveryAddress.suburb
            stateText.text = package.deliveryAddress.state
            postcodeText.text = package.deliveryAddress.postcode
            selectedStatus = package.status
            notesText.text = package.notes
            
            switch selectedStatus
            {
            case .pending:
                statusControl.selectedSegmentIndex = 0
            case .onroute:
                statusControl.selectedSegmentIndex = 1
                trackNoIsShown = true
            case .delivered:
                statusControl.selectedSegmentIndex = 2
                if let deliveryDate = package.deliveredDate {
                    deliveryDatePicker.date = deliveryDate
                    blankDeliveredDate = false
                }
                deliveryLabelShown = true
                trackNoIsShown = true
            }
            
            if let updateDate = package.statusUpdated {
                updateDatePicker.date = updateDate
                blankUpdateDate = false
            }
        }
    }
    
    // hide the trash icon (we dont want it on new packages)
    func hideTrashButton ()
    {
        if let index = navigationItem.rightBarButtonItems?.index(of: trashButton){
            navigationItem.rightBarButtonItems?.remove(at: index)
        }
    }
    
    //show the trash icon (we want it only on packages we're editing)
    func showTrashButton ()
    {
        if navigationItem.rightBarButtonItems?.index(of: trashButton) == nil {
            //I want the icon to be right most
             navigationItem.rightBarButtonItems?.insert(trashButton, at: 0)
         }
       
    }
    
    //update the date labels.
    func updateDateViews (){
        if blankUpdateDate {
          updateDateLabel.text = "Select Date"
        } else {
          updateDateLabel.text = Utils.dateFormatter.string(from: updateDatePicker.date)
        }
        if blankDeliveredDate {
            deliveryDateLabel.text = "Select Date"
        }else{
            deliveryDateLabel.text = Utils.dateFormatter.string(from: deliveryDatePicker.date)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    //show or hide the date pickers.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0,2):
            if updateDateIsShown {
                return 216.0
            } else {
                return 0.0
            }
        case (0,3):
            if deliveryLabelShown {
                return 44.0
            } else {
                return 0.0
            }
        case (0,4):
            if deliveryDateIsShown {
                return 216.0
            } else {
                return 0.0
            }
        case (0,5):
            if trackNoIsShown {
                return 44.0
            }else{
                return 0.0
            }
        case (2,0):
            return 150.0
        default:
            return 44.0
        }
    }

    //set the date pickers to be closed
    func closeDatePickers ()
    {
        deliveryDateIsShown = false
        updateDateIsShown = false
    }
    
    // MARK: - User Actions
    @IBAction func statusChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            selectedStatus = .pending
            blankDeliveredDate = true
            deliveryLabelShown = false
            trackNoIsShown = false
        case 1:
            selectedStatus = .onroute
            blankDeliveredDate = true
            deliveryLabelShown = false
            trackNoIsShown = true
        case 2:
            selectedStatus = .delivered
            deliveryLabelShown = true
            trackNoIsShown = true
        default:
            selectedStatus = .pending
        }
        closeDatePickers()
        updateDateViews()
     }
    
 
    @IBAction func trashIconPressed(_ sender: UIBarButtonItem) {
        let confirmMessage = UIAlertController(title: "Delete Package", message: "You cannot undo this action", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "trashSegue", sender: self)
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            return
        }
        
        //Add OK and Cancel button to dialog message
        confirmMessage.addAction(ok)
        confirmMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(confirmMessage, animated: true, completion: nil)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateViews ()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0,1):
            blankUpdateDate = false
            updateDateIsShown = !updateDateIsShown
            deliveryDateIsShown = false
        case (0,3):
            blankDeliveredDate = false
            deliveryDateIsShown = !deliveryDateIsShown
            updateDateIsShown = false
        default:
            break
        }
        updateDateViews ()
    }
 
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "savePackageSegue" else {return}
        let streetAddress = streetAddressText.text!
        let city = cityText.text!
        let state = stateText.text!
        let postcode = postcodeText.text!
        let deliveryAddress = Address (streetAddress: streetAddress, suburb: city, state: state, postcode: postcode)
        
        let trackingNo = trackingNoText.text
        let recipientName = recipientNameText.text!
    
        package = Package (status: selectedStatus, statusUpdated: updateDatePicker.date, trackingNo: trackingNo, recipientName: recipientName, deliveryAddress: deliveryAddress, notes: notesText.text)
        
        if (selectedStatus == .delivered){
            package!.deliveredDate = deliveryDatePicker.date
        }else{
            package!.deliveredDate = nil
        }
        
    }
    
  

}
