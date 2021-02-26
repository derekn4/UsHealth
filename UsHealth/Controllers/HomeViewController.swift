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
import MBCircularProgressBar

class HomeViewController: UITableViewController {
    
    var user: GIDGoogleUser!
    var signin: GIDSignIn!
    
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var progressInfo: UILabel!
    
    //let eventsCalendarManager: EventCalendarManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user.profile.familyName as Any)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 10.0){
            //get value from firebase Database
            self.progressBar.value = 60
        }
        self.progressInfo.text = "You are \(self.progressBar.value)% complete!"
    }
    
    @IBAction func onLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            signin.disconnect()
            print("Log Out success!")
        } catch let signOutError as NSError {
            print("Error Signing out: %@", signOutError)
        }
        NotificationCenter.default.post(name: NSNotification.Name("signOut"),  object: nil)
        self.dismiss(animated: true, completion: nil)
        //UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    //    override func numberofSections(in tableView: UITableView) -> Int {
//        return 0
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    @IBAction func AddEventButton(_ sender: Any) {
        print("THIS SHOULD ADD EVENTS")
        self.check_permission(start_date: Date(), event_name: "Testing")
//        let eventsCalendarManager: EventsCalendarManager!
//        let event_ = EKEvent.init()
//        event_.title = "MyLocation"
//        eventsCalendarManager.addEventToCalendar(event: event_) { (result) in
//            switch result {
//            case .success:
//                self.view?.showEventAddedToCalendarAlert()
//            case .failure(let error):
//                switch error {
//                case .calendarAccessDeniedOrRestricted:
//                    self.view?.showSettingsAlert()
//                case .eventNotAddedToCalendar:
//                    self.view?.showEventNotAddedToCalendarAlert()
//                case .eventAlreadyExistsInCalendar:
//                    self.view?.showEventAlreadyExistsInCalendarAlert()
//                default: ()
//                }
//            }
//        }
    }
    
    func check_permission(start_date: Date, event_name: String) {
        let event_store = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            event_store.requestAccess(to: .event) { (status, error) in
                if status {
                    self.insert_event(store: event_store, start_date: start_date, event_name: event_name)
                } else {
                    print(error?.localizedDescription)
                }
            }
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorized:
            print("authorized")
            self.insert_event(store: event_store, start_date: start_date, event_name: event_name)
        @unknown default:
            print("Unknown")
        }
    }
    
    func insert_event(store: EKEventStore, start_date: Date, event_name: String){
        let calendars = store.calendars(for: .event)
        for calendar in calendars {
            if calendar.title == "Calendar" {
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                event.startDate = start_date
                event.title = event_name
                event.endDate = event.startDate.addingTimeInterval(60*30)
//                event.recurrenceRules = [EKRecurrenceRule(recurrenceWith)]
                let reminder1 = EKAlarm(relativeOffset: -60)
                let reminder2 = EKAlarm(relativeOffset: -30)
                event.alarms = [reminder1, reminder2]
                do {
                    try store.save(event, span: .thisEvent)
                    print("event insert")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
