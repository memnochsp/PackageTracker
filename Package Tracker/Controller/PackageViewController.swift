//
//  PackageViewController.swift
//  Package Tracker
//
//  Created by Sean Ogden Power on 12/6/18.
//  Copyright © 2018 Sean Ogden Power. All rights reserved.
//

import UIKit

class PackageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    @IBOutlet weak var packageTableView: UITableView!
    @IBOutlet weak var pendingButton: UITabBarItem!
    @IBOutlet weak var outForDeliveryButton: UITabBarItem!
    @IBOutlet weak var deliveredButton: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    
    var packages = [Package]()
    var displayPackages = [Package]()
    var selectedStatus = Status.pending
    var selectedIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        packageTableView.delegate = self
        packageTableView.dataSource = self
    
        tabBar.delegate = self
        
        if let savedPackages = Package.loadPackages() {
            packages = savedPackages
        }
 
        initUI()
        updateUI()
    }
    
    func updateUI ()
    {
        //remove any old packages
        packages = Package.deleteOldPackages(packages: packages)
        displayPackages = packages.filter ({$0.status == selectedStatus})
        packageTableView.reloadData()
    }
    
    func initUI ()
    {
        self.view.setGradientBackground(colorOne: Utils.lightTeal, colorTwo: Utils.darkTeal)
        tabBar.selectedItem = pendingButton
        
        pendingButton.title = Status.pending.rawValue
        outForDeliveryButton.title = Status.onroute.rawValue
        deliveredButton.title = Status.delivered.rawValue
    }
    
    //MARK: - Table Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayPackages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = packageTableView.dequeueReusableCell(withIdentifier: "packageCell", for: indexPath) as? PackageListTableViewCell else {fatalError("Could not deque cell")}

        let package = displayPackages[indexPath.row]
        //Make it look better
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        let whiteBGView : UIView = UIView(frame: CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 60))
        
        whiteBGView.layer.backgroundColor = Utils.whiteOverlay.cgColor
        whiteBGView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteBGView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteBGView)
        cell.contentView.sendSubview(toBack: whiteBGView)
        
        //set the select colour
        let selectedBG = UIView()
        selectedBG.backgroundColor = Utils.whiteOverlay
        cell.selectedBackgroundView = selectedBG
        
        //set the values
        cell.titleLabel?.text = package.recipientName
        cell.descriptionLabel?.text = package.deliveryAddress.description
        cell.dateLabel.text = Utils.dateFormatter.string (from: package.statusUpdated!)

        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let pendingAction = UIContextualAction(style: .normal, title:  nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.updateSelectedStatus(forRowAt: indexPath, status: .pending)
            success(true)
        })
        pendingAction.image = UIImage(named: "pending")
        pendingAction.backgroundColor = Utils.darkGrey
        
        let outForDeliveryAction = UIContextualAction(style: .normal, title:  nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.updateSelectedStatus(forRowAt: indexPath, status: .onroute)
            success(true)
        })
        outForDeliveryAction.image = UIImage(named: "outForDelivery")
        outForDeliveryAction.backgroundColor = Utils.darkTeal
        
        let deliveredAction = UIContextualAction(style: .normal, title:  nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.updateSelectedStatus(forRowAt: indexPath, status: .delivered)
            success(true)
        })
        deliveredAction.image = UIImage(named: "delivered")
        deliveredAction.backgroundColor = Utils.darkBlue
        
        var actionsArray = [UIContextualAction]()
        switch selectedStatus
        {
        case .pending:
            actionsArray.append (outForDeliveryAction)
            actionsArray.append (deliveredAction)
        case .delivered:
            actionsArray.append (pendingAction)
            actionsArray.append (outForDeliveryAction)
        case .onroute:
            actionsArray.append (pendingAction)
            actionsArray.append (deliveredAction)
        }
        
        return UISwipeActionsConfiguration(actions: actionsArray)
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //we want to store the index of the selected package in the MAIN package array, not the dispayArray
        let package = displayPackages[packageTableView.indexPathForSelectedRow!.row]
        selectedIndex = packages.index(where: {$0 === package})
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confrimDelete(forRowAt: indexPath)
        }
    }

    // MARK: - Tab Bar Functions
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == deliveredButton
        {
            selectedStatus = Status.delivered
        } else if item == outForDeliveryButton {
            selectedStatus = Status.onroute
        }else{
            selectedStatus = Status.pending
        }
        updateUI()
    }
    
    //MARK:- User Actions
    func updateSelectedStatus (forRowAt indexPath: IndexPath, status: Status)
    {
        let package = displayPackages[indexPath.row]
        if let selectedIndex = packages.index(where: {$0 === package}){
            package.status = status
            package.statusUpdated = Date()
            
            if status == .delivered {
                package.deliveredDate = Date ()
            }
            
            packages[selectedIndex] = package
        }
        updateUI()
        Package.savePackages(packages)
    }
    
    func confrimDelete (forRowAt indexPath: IndexPath)
    {
        let confirmMessage = UIAlertController(title: "Delete Package?", message: "You cannot undo this action", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            let package = self.displayPackages[indexPath.row]
            if let selectedIndex = self.packages.index(where: {$0 === package}){
                       self.packages.remove(at: selectedIndex)
            }
            self.updateUI()
            Package.savePackages(self.packages)
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Add OK and Cancel button to dialog message
        confirmMessage.addAction(ok)
        confirmMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(confirmMessage, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editPackageSegue" else {return}
        
        let packageController = segue.destination as! EditPackageTableViewController
        let indexPath = packageTableView.indexPathForSelectedRow!
        packageController.package = displayPackages [indexPath.row]
    }
 
    
    //unwind from the edit/new storyboard
    @IBAction func unwindFromEdit (for unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "savePackageSegue" || unwindSegue.identifier == "trashSegue" else {
            selectedIndex = nil
            return
        }
        
        if unwindSegue.identifier == "savePackageSegue" {
            //add or update the package
            let packageController = unwindSegue.source as? EditPackageTableViewController
            if let newPackage = packageController?.package {
                if let index = selectedIndex {
                    packages[index] = newPackage
                } else {
                    packages.append(newPackage)
                }
            }
        }else{
            //delete the package
            packages.remove(at: selectedIndex!)
        }
        selectedIndex = nil
        updateUI()
        Package.savePackages(packages)
    }

}
