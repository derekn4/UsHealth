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
import Firebase

class HomeViewController: UITableViewController {
    
    var user: GIDGoogleUser!
    var signin: GIDSignIn!
    
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var progressInfo: UILabel!
    
    
    //times that many people work out at
    let workoutTimes = ["06:00:00", "10:00:00", "14:00:00", "17:00:00", "19:00:00", "18:00:00"]
    let workouts = ["HIIT", "Walk", "Jog", "Swim"]
    
    private let ref = Database.database().reference()
    var databaseHandle: DatabaseHandle = 0
    var progress = 0
    var userData = [String]()
    var workoutFreq: Int = 0
    var firstLoad = 0
    
    private func retrieveProgress() {
        self.ref.child("users/\(user.userID ?? "")").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let prog = value?["progress"] as? Int ?? 0
            self.progress = prog
        }) { (error) in
            print(error.localizedDescription)
        }
        self.progressBar.reloadInputViews()
    }
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.progressBar.value = 0

        }
        
        //NEXT STEPS:
            //Immediately set calendar dates from arrays above
            //schedule into Apple Calendar
            //set row labels as Workouts + length of time?
        
        //TODO:
            //Check if date is start of week
            //Get Workout data from Database OR hard code workouts (LOL)
    
    
    override func viewWillAppear(_ animated: Bool) {
        //retrieveProgress()
        let db = Database.database().reference().child("users")
                db.observe(.value) { (snapshot) in
                    // Parse database for what you want. It's all in a giant dictionary
                    let val = snapshot.value as! NSDictionary
                    
                    
                    // Find what you need
                    for v in val
                    {
                        if v.key as! String == self.user.userID!{
                            let dict = v.value as! NSDictionary
                            //print(dict)
                            //print(dict["progress"]!)
                            let num = (dict["NumWorkoutsWeekly"] as? NSString)?.integerValue
                            self.progress = dict["progress"] as! Int
                            self.workoutFreq = num ?? 5
                            //let ID = self.user.userID!
                        }
                    }
                    UIView.animate(withDuration: 1.0){
                        //get value from firebase Database
                        self.progressBar.value = CGFloat(self.progress)
                    }
                    self.progressInfo.text = "You are \(self.progressBar.value)% complete!"
                    // Reload your tableview
                    if self.firstLoad == 0 {
                        self.tableView.reloadData()
                        self.firstLoad = self.firstLoad + 1
                    }
//                    print("should have reload")
                }
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
    }
    
    //UPDATE USER PROGRESS IN FIREBASE
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
        if self.progress < 100 {
            self.progressInfo.text = "You are \(self.progress)% complete!"
            let childUpdates = ["/users/\(self.user.userID!)/progress": self.progress]
            self.ref.updateChildValues(childUpdates)
        }
        else if self.progress == 100{
            self.progressInfo.text = "You Finished! Great Work!"
            let childUpdates = ["/users/\(self.user.userID!)/progress": self.progress]
            self.ref.updateChildValues(childUpdates)
        }
        else {
            //Wait until end of Week, then reset progress to 0\
            self.progress = self.progress - 100
            self.progressInfo.text = "You are \(self.progress)% complete!"
            let childUpdates = ["/users/\(self.user.userID!)/progress": self.progress]
            self.ref.updateChildValues(childUpdates)
            
        }
        UIView.animate(withDuration: 1.0){
            //get value from firebase Database
            self.progressBar.value = CGFloat(self.progress)
            
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //self.ref.child("users/\(user.userID ?? "")/NumWorkoutsWeekly")
        return self.workoutFreq
    }


    @IBAction func RefreshView(_ sender: Any) {
        print("This shoudl refresh the ProgressBar")
        retrieveProgress()
        print("refresh \(self.progress)")
        UIView.animate(withDuration: 1.0){
            //get value from firebase Database
            self.progressBar.value = CGFloat(self.progress)
        }
        self.progressInfo.text = "You are \(self.progress)% complete!"
    }
    
    //Calendar Functions
        //KEEP THIS TO REMEMBER HOW TO ADD EVENTS AT SPECIFIC TIMES
//        print("THIS SHOULD ADD EVENTS")
//        let date = Date()
//        let calendarDate = Calendar.current.dateComponents([.day, .month, .year], from: date)
//        let year = calendarDate.year!
//        let month = calendarDate.month!
//        let day = String(Int(calendarDate.day!) + 1) //probably change to var to be able to change to days of the week
//        self.check_permission(start_date: formatter.date(from: "\(year)-\(month)-\(day) 16:00:00") ?? Date(), event_name: "Testing")
    //}
    
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
