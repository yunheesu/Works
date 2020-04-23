//
//  DetailViewController.swift
//  Works
//
//  Created by Heesu Yun on 4/21/20.
//  Copyright © 2020 Heesu Yun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var workField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var availableField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var locationField: UITextField!
    
    var worksItem: WorksItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if worksItem == nil { // passing empty string for starter
            worksItem = WorksItem(name: "", work: "", time: "", number: "", notes: "", image: UIImage)
        }
        workField.text = worksItem.work
        nameField.text = worksItem.name
        availableField.text = worksItem.time
        phoneNumberField.text = worksItem.number
        notesView.text = worksItem.notes
        imageView.image = worksItem.image
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        worksItem.work = workField.text!
        worksItem.name = nameField.text!
        worksItem.time = availableField.text!
        worksItem.number = phoneNumberField.text!
        worksItem.notes = notesView.text!
        worksItem.image = imageView.image!
        
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }else{
            navigationController!.popViewController(animated: true)
        }
    }
    @IBAction func saveBarButtonPressed(_ sender: Any) {
        worksItem.work = workField.text!
        worksItem.name = nameField.text!
        worksItem.time = availableField.text!
        worksItem.number = phoneNumberField.text!
        worksItem.notes = notesView.text!
        worksItem.image = imageView.image!
        
        worksItem.saveData { success in
            if success {
                self.leaveViewController()
            }else{
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved")
            }
        }
    }
    
}
