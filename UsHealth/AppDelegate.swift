//
//  AppDelegate.swift
//  UsHealth
//
//  Created by Derek Nguyen on 2/20/21.
//

import UIKit
import Firebase
import GoogleSignIn


@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
//    var userData: UserInfo! {
//        didSet {
//            NotificationCenter.default.post(name: NSNotification.Name("refreshView"),  object: nil)
//        }
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }else {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("Log Out success!")
            } catch let signOutError as NSError {
                print("Error Signing out: %@", signOutError)
            }
        }
    }
        
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let user = user else {return}
                
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken,
                                                       accessToken: user.authentication.accessToken)
        //Signin to Google via firebase stuff
        Auth.auth().signIn(with: credential) { (result, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            else {
                
                print(user.profile.email ?? "No Email")
                
                if let newUser: Bool = result?.additionalUserInfo?.isNewUser {
                    if newUser {
                        NotificationCenter.default.post(name: NSNotification.Name("newSIGNIN"),  object: nil)
                    }
                    else {
                        NotificationCenter.default.post(name: NSNotification.Name("SIGNIN"),  object: nil)
                    }
                }
            }
        }
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

