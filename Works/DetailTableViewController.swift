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
    @IBOutlet weak var imageView: UIImageView!
    
    
    var workItem: WorkItem!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        if workItem == nil { // passing empty string for starter
            workItem = WorkItem(name: "", work: "", time: "", location: "", number: "", notes: "", appImage: UIImage(), appImageUUID: "", postingUserID: "", documentID: "")
            
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
                self.workItem.saveImage { (success) in
                    if !success {
                        print("Warning: Could not save image")
                    }
                self.leaveViewController()
                }
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        cameraOrLibaryAlert()
    }
    
}

extension DetailTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            workItem.appImage = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            workItem.appImage = originalImage
        }
        dismiss(animated: true) {
            self.imageView.image = self.workItem.appImage
        }
        } 
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func cameraOrLibaryAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.accessLibrary()
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.accessCamera()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
        
    }
    func accessLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }else{
            self.oneButtonAlert(title: "Camera Not Available", message: "There is no camera avilable on this device")
        }
    }
}

