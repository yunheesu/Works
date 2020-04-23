//
//  WorksItem.swift
//  Works
//
//  Created by Heesu Yun on 4/23/20.
//  Copyright © 2020 Heesu Yun. All rights reserved.
//

import Foundation
import UIKit

struct WorksItem {
    var name: String
    var work: String
    var time: String
    var number: String
    var notes: String
    var image: UIImage
    
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first!
         let documentURL = directoryURL.appendingPathComponent("works").appendingPathExtension("json")
         
         let jsonEncoder = JSONEncoder ()
         let data = try? jsonEncoder.encode(itemsArray)
         do {
             try data?.write(to: documentURL, options: .noFileProtection)
         } catch{
             print("😡 ERROR: Could not save data \(error.localizedDescription)")
         
    }
}

}
