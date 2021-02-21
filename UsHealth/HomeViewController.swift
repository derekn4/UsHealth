//
//  HomeViewController.swift
//  UsHealth
//
//  Created by Derek Nguyen on 2/20/21.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOut(_ sender: Any) {
        print(GIDSignIn.sharedInstance()?.currentUser)
        GIDSignIn.sharedInstance()?.signOut()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
