//
//  LoginViewController.swift
//  UsHealth
//
//  Created by Derek Nguyen on 2/20/21.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            
        }
        else {
            GIDSignIn.sharedInstance()?.presentingViewController = self
            //GIDSignIn.sharedInstance()?.signIn()
            NotificationCenter.default.addObserver(self, selector: #selector(userDidSignInGoogle(_:)), name: NSNotification.Name("SIGNIN"), object: nil)
        }
    }
    
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        // Update screen after user successfully signed in
        let newUserRref = GIDSignIn.sharedInstance()?.hasPreviousSignIn()

         /*Check if the automatic creation time of the user is equal to the last
           sign in time (Which will be the first sign in time if it is indeed
           their first sign in)*/

        if newUserRref==true{
            self.performSegue(withIdentifier: "directHome", sender: self)
        } else {
            self.performSegue(withIdentifier: "starterQs", sender: self)
        }
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
