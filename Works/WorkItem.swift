//
//  WorkItem.swift
//  Works
//
//  Created by Heesu Yun on 4/25/20.
//  Copyright © 2020 Heesu Yun. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class WorkItem {
    var name: String
    var work: String
    var time: String
    var location: String
    var number: String
    var notes: String
    var appImage: UIImage
    var appImageUUID: String 
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name": name, "work": work, "time": time, "location": location, "number": number, "notes": notes, "appImageUUID": appImageUUID, "postingUserID": postingUserID, "documentID": documentID]
    }
    init(name: String, work: String, time: String, location: String, number: String, notes: String, appImage: UIImage, appImageUUID: String, postingUserID: String, documentID: String) {
        self.name = name
        self.work = work
        self.time = time
        self.location = location
        self.number = number
        self.notes = notes
        self.appImage = appImage
        self.appImageUUID = appImageUUID
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let work = dictionary["work"] as! String? ?? ""
        let time = dictionary["time"] as! String? ?? ""
        let location = dictionary["location"] as! String? ?? ""
        let number = dictionary["number"] as! String? ?? ""
        let notes = dictionary["notes"] as! String? ?? ""
        let appImageUUID = dictionary["appImageUUID"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        self.init(name: name, work: work, time: time, location: location , number: number, notes: notes, appImage:UIImage(), appImageUUID: appImageUUID, postingUserID: postingUserID, documentID: "")
        
    }
    
    // NOTE: If you keep the same programming conventions (e.g. a calculated property .dictionary that converts class properties to String: Any pairs, the name of the document stored in the class as .documentID) then the only thing you'll need to change is the document path (i.e. the lines containing "works" below.
    func saveData(completion: @escaping (Bool) -> ())  {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID
        if self.documentID != "" {
            let ref = db.collection("works").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked!
                    completion(true)
                }
            }
        } else { // Otherwise create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will creat a new ID for us
            ref = db.collection("works").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked! Save the documentID in Work's documentID property
                    self.documentID = ref!.documentID
                    completion(true)
                }
            }
        }
    }
    func saveImage(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        //conver appImage to a Data Type so it can be saved by Firebase storage
        guard let imageToSave = self.appImage.jpegData(compressionQuality: 0.5) else {
            print("ERROR: could not convert image to data format")
            return completed(false)
        }
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        if appImageUUID == "" {
            //if there;s no UUID, then create one
            appImageUUID = UUID().uuidString
            
        }
        //create a ref to upload storage with the UUID we created
        let storageRef = storage.reference().child(documentID).child(self.appImageUUID)
        let uploadTask = storageRef.putData(imageToSave, metadata: uploadMetaData) { (metaData, error) in
            guard error == nil else {
                print("ERROR: during .putData storage upload for reference \(storageRef). Error = \(error?.localizedDescription ?? "<unknwon error>")")
                return completed(false)
            }
            print("Upload Worked! Matadata is \(metaData)")
        }
        uploadTask.observe(.success) { (snapshot) in
            let dataToSave = self.dictionary
            let ref = db.collection("teams").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: saving document \(self.documentID) in success observer. ERROR \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print ("ERROR: \(error.localizedDescription) upload task for file \(self.appImageUUID)")
            }
            return completed(false)
        }
    }
    
    
    func loadImage(completed: @escaping () -> ()) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(self.documentID).child(self.appImageUUID)
        //5MB = 5* 1024 * 1024
        storageRef.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
            guard error == nil else {
                print("ERROR: could not load image from bucket \(self.documentID) for file \(self.appImageUUID).")
                return completed()
            }
            guard let downloadedImage = UIImage(data: data!) else {
                print("ERROR: could not convert data to image from bucket \(self.documentID) for file \(self.appImageUUID).")
                return completed()
            }
            self.appImage = downloadedImage
            completed()
        }
    }
}
