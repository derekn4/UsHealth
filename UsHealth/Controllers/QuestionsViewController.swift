//
//  QuestionsViewController.swift
//  UsHealth
//
//  Created by Derek Nguyen on 2/20/21.
//

import UIKit
import GoogleSignIn

class QuestionsViewController: UIViewController {

    @IBOutlet weak var submit: UIButton!
    var user: GIDGoogleUser!
    var signin: GIDSignIn!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        NotificationCenter.default.addObserver(self, selector: #selector(signOutUser(_:)), name: NSNotification.Name("signOut"), object: nil)
    }

//    @objc private func signOutUser(_ notification: Notification) {
//        self.dismiss(animated: true, completion: nil)
//    }

    
    @IBAction func sendToDash(_ sender: Any) {
        print("Finished questions, go to Home")
        print(user.profile?.email! as Any)
        self.performSegue(withIdentifier: "postQsHome", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let destVC = nav.topViewController as? HomeViewController {
            destVC.user = self.user
            destVC.signin = self.signin
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
