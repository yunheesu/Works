//
//  WorksItems.swift
//  Works
//
//  Created by Heesu Yun on 4/25/20.
//  Copyright © 2020 Heesu Yun. All rights reserved.
//

import Foundation
import Firebase

class WorksItems {
    var workArray: [WorksItem] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("works").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.workArray = []
            // there are querySnapshot!.documents.count documents in teh spots snapshot
            for document in querySnapshot!.documents {
              // You'll have to be sure you've created an initializer in the singular class (Spot, below) that acepts a dictionary.
                let work = WorksItem(dictionary: document.data())
                work.documentID = document.documentID
                self.workArray.append(work)
            }
            completed()
        }
    }
}
