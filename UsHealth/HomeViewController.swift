//
//  HomeViewController.swift
//  UsHealth
//
//  Created by Derek Nguyen on 2/20/21.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class HomeViewController: UITableViewController {
    
    var user: GIDGoogleUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user.profile.familyName as Any)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Log Out success!")
        } catch let signOutError as NSError {
            print("Error Signing out: %@", signOutError)
        }
//        do {
//            try GIDSignIn.sharedInstance()?.signOut()
//            print("Log Out success!")
//        } catch let signOutError as NSError {
//            print("Error Signing out: %@", signOutError)
//        }
        self.dismiss(animated: true, completion: nil)
    }
    //    override func numberofSections(in tableView: UITableView) -> Int {
//        return 0
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
