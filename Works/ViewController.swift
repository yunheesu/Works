//
//  ViewController.swift
//  Works
//
//  Created by Heesu Yun on 4/20/20.
//  Copyright © 2020 Heesu Yun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var works: [WorksItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "ShowDetail" {
             let destination = segue.destination as! DetailViewController
             let selectedIndexPath = tableView.indexPathForSelectedRow!
             destination.worksItem = works[selectedIndexPath.row]
         }else{
             if let selectedIndexPath = tableView.indexPathForSelectedRow { //not nil
                 tableView.deselectRow(at: selectedIndexPath, animated: true)
             }
         }
     }
//    func loadData() {
//        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let documentURL = directoryURL.appendingPathComponent("students").appendingPathExtension("json")
//
//        guard let data = try? Data(contentsOf: documentURL) else {return}
//        let jsonDecoder = JSONDecoder()
//        do {
//            works = try jsonDecoder.decode(Array<String>.self, from: data)
//            tableView.reloadData()
//        } catch {
//            print("*** decoding during loadData failed")
//        }
//    }
//
//    func saveData() { // saving data!
//        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let documentURL = directoryURL.appendingPathComponent("students").appendingPathExtension("json")
//
//        let jsonEncoder = JSONEncoder()
//        let data = try? jsonEncoder.encode(works)
//        do {
//            try data?.write(to: documentURL, options: .noFileProtection)
//        } catch {
//            print("*** Couldn't saveData")
//        }
//    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ShowSegue", for: indexPath)
         cell.textLabel?.text = works[indexPath.row].work
         print("👍🏻 dequeueing the table view cell for indexPath.row = \(indexPath.row) where the cell contains item \(works[indexPath.row])")
         return cell
        
    }
    
    
}
