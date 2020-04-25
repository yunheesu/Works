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
    
    
    var worksItem: Works!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if worksItem == nil { // passing empty string for starter
            worksItem = Works()
            //Look at Heckathon App에 있다! (UIImage())
        }
        
        
    }
    
    func updateUserInterface() {
        workField.text = worksItem.work
        nameField.text = worksItem.name
        availableTimeField.text = worksItem.time
        locationField.text = worksItem.location
        phoneNumberField.text = worksItem.number
        noteTextView.text = worksItem.notes
    }
    
    func updateFromUserInterface() {
        worksItem.work = workField.text!
        worksItem.name = nameField.text!
        worksItem.location = locationField.text!
        worksItem.time = availableTimeField.text!
        worksItem.number = phoneNumberField.text!
        worksItem.notes = noteTextView.text!
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        worksItem.work = workField.text!
//        worksItem.name = nameField.text!
//        worksItem.location = locationField.text!
//        worksItem.time = availableTimeField.text!
//        worksItem.number = phoneNumberField.text!
//        worksItem.notes = noteTextView.text!
//
//
//    }
    
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
        worksItem.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    
}
