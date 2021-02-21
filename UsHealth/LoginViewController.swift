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
            NotificationCenter.default.addObserver(self, selector: #selector(newuserDidSignInGoogle(_:)), name: NSNotification.Name("newSIGNIN"), object: nil)
        }
    }
    
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        self.performSegue(withIdentifier: "directHome", sender: self)
        //self.performSegue(withIdentifier: "starterQs", sender: self)
    }
    
    @objc private func newuserDidSignInGoogle(_ notification: Notification) {
        //self.performSegue(withIdentifier: "directHome", sender: self)
        self.performSegue(withIdentifier: "starterQs", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="starterQs"){
            let user = GIDSignIn.sharedInstance()?.currentUser
            let destVC = segue.destination as! QuestionsViewController
            destVC.user = user
        } else {
            let user = GIDSignIn.sharedInstance()?.currentUser
            if let nav = segue.destination as? UINavigationController,
                let destVC = nav.topViewController as? HomeViewController {
                destVC.user = user
            }
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
