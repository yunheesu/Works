//
//  DetailTableViewController.swift
//  Works
//
//  Created by Heesu Yun on 4/24/20.
//  Copyright © 2020 Heesu Yun. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    @IBOutlet weak var workField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var availableTimeField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    
    var workItem: WorkItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if workItem == nil { // passing empty string for starter
            workItem = WorkItem(dictionary: [String : Any])
            
        }
        updateUserInterface()
        
    }
    
    func updateUserInterface() {
        workField.text = workItem.work
        nameField.text = workItem.name
        availableTimeField.text = workItem.time
        locationField.text = workItem.location
        phoneNumberField.text = workItem.number
        noteTextView.text = workItem.notes
    }
    
    func updateFromUserInterface() {
        workItem.work = workField.text!
        workItem.name = nameField.text!
        workItem.location = locationField.text!
        workItem.time = availableTimeField.text!
        workItem.number = phoneNumberField.text!
        workItem.notes = noteTextView.text!
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        // When reusing this code, the only changes required may be to spot.saveData (you'll likley have a different object, and it is possible that you might pass in parameters if you're saving to a longer document reference path
        workItem.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    
}
