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
    
    //let userDefault = UserDefaults()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }else {
            print("Log Out success!")
        }
    }
        
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        } else {
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
//            let str = email
//            let int = (str?.count ?? 0)-9
//            if (int>0){
//                let NewStr = str?.dropFirst(int)
//                print(NewStr)
//                var checkIn = 0
//            } else {return}
//
//            guard let authentication = user.authentication else {return}
//            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
//
//            Auth.auth().signIn(with: credential) { (result, error) in
//                if error != nil {
//                    print((error?.localizedDescription)!)
//                    return
//                }
//
//                else {
//                    UserDefaults.standard.set(true, forKey: "userSignedIn")
//                    NotificationCenter.default.post(name: NSNotification.Name("SIGNIN"),  object: nil)
//                    UserDefaults.standard.synchronize()
//
//                    //self.email = (result?.user.email)!
//                    print("User email: \(user.profile.email ?? "No Email")")
//            }
//
//        }
        if (error==nil) {
            guard let user = user else {return}

            guard let authentication = user.authentication else {return}

            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)

            //Signin to Firebase
            Auth.auth().signIn(with: credential) { (result, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }

                else {
                    UserDefaults.standard.set(true, forKey: "userSignedIn")
                    NotificationCenter.default.post(name: NSNotification.Name("SIGNIN"),  object: nil)
                    UserDefaults.standard.synchronize()

                    //self.email = (result?.user.email)!
                    print("User email: \(user.profile.email ?? "No Email")")
                }
            }
            
            let newUserRref = Auth.auth().currentUser?.metadata
            
            if newUserRref?.creationDate?.timeIntervalSince1970 == newUserRref?.lastSignInDate?.timeIntervalSince1970 {
                print("Hello new user")
                self.window?.rootViewController?.performSegue(withIdentifier: "starterQuestions", sender: self)
            } else {
                print("Welcome Back!")
                self.window?.rootViewController?.performSegue(withIdentifier: "directHome", sender: self)
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

