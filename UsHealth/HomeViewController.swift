//
//  HomeViewController.swift
//  UsHealth
//
//  Created by Derek Nguyen on 2/20/21.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import EventKit
class HomeViewController: UITableViewController {
    
    var user: GIDGoogleUser!
    let eventsCalendarManager: EventCalendarManager!
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

    @IBAction func AddEventButton(_ sender: Any) {
        let event_ = EKEvent.init()
        event_.title = "MyLocation"
        eventsCalendarManager.addEventToCalendar(event: event_) { (result) in
            switch result {
            case .success:
                self.view?.showEventAddedToCalendarAlert()
            case .failure(let error):
                switch error {
                case .calendarAccessDeniedOrRestricted:
                    self.view?.showSettingsAlert()
                case .eventNotAddedToCalendar:
                    self.view?.showEventNotAddedToCalendarAlert()
                case .eventAlreadyExistsInCalendar:
                    self.view?.showEventAlreadyExistsInCalendarAlert()
                default: ()
                }
            }
        }
    }
}
