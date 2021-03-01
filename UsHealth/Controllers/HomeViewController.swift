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
import FirebaseDatabase

class HomeViewController: UITableViewController {
    
    var user: GIDGoogleUser!
    var signin: GIDSignIn!
    
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var progressInfo: UILabel!
    
    
    //times that many people work out at
    let workoutTimes = ["06:00:00", "10:00:00", "14:00:00", "17:00:00", "19:00:00", "18:00:00"]
    let lightWorkouts = ["lw1"]
    let medWorkouts = ["mw1"]
    let hardWorkouts = ["hw1"]
    
    private let ref = Database.database().reference()
    var progress: Int = 0

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    //let eventsCalendarManager: EventCalendarManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(user.profile.familyName as Any)
        // Do any additional setup after loading the view.
        self.progressBar.value = CGFloat(self.progress)
        print(user.userID)
        self.ref.child("users/\(user.userID ?? "")/progress").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                self.progress = snapshot.value as! Int
            }
            else {
                print("No data available")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 30.0){
            //get value from firebase Database
            self.progressBar.value = CGFloat(self.progress)
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
    
    //TableView Functions
    override func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! WorkoutCell
        cell.workoutLabel.text = "Light Jog"
        cell.checkMarkImage.image = UIImage(named: "icons8-unchecked-checkbox-50")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? WorkoutCell else {return}
        
        cell.checkMarkImage.image = UIImage(named: "icons8-checked-checkbox-50")
        self.progress = self.progress + 10
        UIView.animate(withDuration: 1.0){
            //get value from firebase Database
            self.progressBar.value = self.progressBar.value + 10
        }
        self.progressInfo.text = "You are \(self.progressBar.value)% complete!"
        //self.ref.child("users/\(user.userID ?? "")/progress")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }

    
    //Calendar Functions
    @IBAction func AddEventButton(_ sender: Any) {
        print("THIS SHOULD ADD EVENTS")
        let date = Date()
        let calendarDate = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let year = calendarDate.year!
        let month = calendarDate.month!
        let day = String(Int(calendarDate.day!) + 1) //probably change to var to be able to change to days of the week
        self.check_permission(start_date: formatter.date(from: "\(year)-\(month)-\(day) 16:00:00") ?? Date(), event_name: "Testing")
        
    }
    
    func check_permission(start_date: Date, event_name: String) {
        let event_store = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            event_store.requestAccess(to: .event) { (status, error) in
                if status {
                    self.insert_event(store: event_store, start_date: start_date, event_name: event_name)
                } else {
                    print(error?.localizedDescription as Any)
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
