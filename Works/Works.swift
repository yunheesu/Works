//
//  WorksItem.swift
//  Works
//
//  Created by Heesu Yun on 4/23/20.
//  Copyright © 2020 Heesu Yun. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Works {
    var name: String
    var work: String
    var time: String
    var location: String
    var number: String
    var notes: String
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name": name, "work": work, "time": time, "location": location, "number": number, "notes": notes, "postingUserID": postingUserID, "documentID": documentID]
    }
    init(name: String, work: String, time: String, location: String, number: String, notes: String, postingUserID: String, documentID: String) {
        self.name = name
        self.work = work
        self.time = time
        self.location = location
        self.number = number
        self.notes = notes
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
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        self.init(name: name, work: work, time: time, location: location, number: number, notes: notes, postingUserID: postingUserID, documentID: documentID)
        
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

}
