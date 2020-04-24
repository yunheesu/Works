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
    
    
    var worksItem: WorksItem!
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           if worksItem == nil { // passing empty string for starter
               worksItem = WorksItem(name: "", work: "", time: "", number: "", notes: "")
           }
           workField.text = worksItem.work
           nameField.text = worksItem.name
           availableTimeField.text = worksItem.time
           phoneNumberField.text = worksItem.number
           noteTextView.text = worksItem.notes
           
       }
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           worksItem.work = workField.text!
           worksItem.name = nameField.text!
           worksItem.time = availableTimeField.text!
           worksItem.number = phoneNumberField.text!
           worksItem.notes = noteTextView.text!

        
    }

    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }else{
            navigationController!.popViewController(animated: true)
        }
    }
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        //        worksItem.work = workField.text!
        //        worksItem.name = nameField.text!
        //        worksItem.time = availableField.text!
        //        worksItem.number = phoneNumberField.text!
        //        worksItem.notes = notesView.text!
        //
        //        worksItem.saveData { success in
        //            if success {
        //                self.leaveViewController()
        //            }else{
        //                print("*** ERROR: Couldn't leave this view controller because data wasn't saved")
        //            }
        //        }
        //    }
    }
    

}
