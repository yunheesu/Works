//
//  ViewController.swift
//  Works
//
//  Created by Heesu Yun on 4/20/20.
//  Copyright © 2020 Heesu Yun. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseUI
import GoogleSignIn

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var works: [WorksItem] = []
    var authUI: FUIAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initializing the authUI var and setting the delegate are step [3]
          authUI = FUIAuth.defaultAuthUI()
          authUI?.delegate = self
       
        tableView.delegate = self
        tableView.dataSource = self
    }
    // Be sure to call this from viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }

    // VITAL: This gist includes key changes to make sure "cancel" works with iOS 13.
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
        ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            let loginViewController = authUI.authViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true, completion: nil)
        } else {
            tableView.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "ShowDetail" {
             let destination = segue.destination as! DetailTableViewController
             let selectedIndexPath = tableView.indexPathForSelectedRow!
             destination.worksItem = works[selectedIndexPath.row]
         }else{
             if let selectedIndexPath = tableView.indexPathForSelectedRow { //not nil
                 tableView.deselectRow(at: selectedIndexPath, animated: true)
             }
            
         }
     }
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            tableView.isHidden = true
            signIn()
        } catch {
            tableView.isHidden = true
            print("*** ERROR: Couldn't sign out")
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
        cell.textLabel?.text = "\(indexPath.row + 1) \(works[indexPath.row].work)"
         print("👍🏻 dequeueing the table view cell for indexPath.row = \(indexPath.row) where the cell contains item \(works[indexPath.row])")
         return cell
        
    }
    
    
}
// Name of the extension is likely the only thing that needs to change in new projects
extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            // Assumes data will be isplayed in a tableView that was hidden until login was verified so unauthorized users can't see data.
            tableView.isHidden = false
            print("^^^ We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        
        // Create a frame for a UIImageView to hold our logo
        let marginInsets: CGFloat = 16 // logo will be 16 points from L and R margins
        let imageHeight: CGFloat = 225 // the height of our logo
        let imageY = self.view.center.y - imageHeight // places bottom of UIImageView in the center of the login screen
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        
        // Create the UIImageView using the frame created above & add the "logo" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "login")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
}
