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
    var progress = 0
    var workoutFreq: Int = 0
    var firstLoad = 0
    var setWorkouts = [String]()
    var firstCalendar = 0
    var lengthOfWorkout = 0
    
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
                            let num = (dict["NumWorkoutsWeekly"] as? NSString)?.integerValue
                            self.progress = dict["progress"] as? Int ?? 0
                            self.workoutFreq = num ?? 5
                            for _ in stride(from: 0, to: self.workoutFreq, by: 1){
                                let randomInt = Int.random(in: 0..<self.workouts.count)
                                self.setWorkouts.append(self.workouts[randomInt])
                            }
                            if dict["Intensity"] as! String == "Low" {
                                self.lengthOfWorkout = 60*10
                            } else if dict["Intensity"] as! String == "Medium" {
                                self.lengthOfWorkout = 60*20
                            } else if dict["Intensity"] as! String == "High" {
                                self.lengthOfWorkout = 60*30
                            }
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
        
        //add to calendar?
        var startWeek = Date().startOfWeek
        
        let currDay = Date()
        let calendarDate = Calendar.current.dateComponents([.day, .month, .year], from: currDay)
        let year = calendarDate.year!
        let month = calendarDate.month!
        let day = calendarDate.day!
        
        if startWeek[1]==2 && startWeek[2]>=28{
            //something about the date
            startWeek[1] = startWeek[1]+1
            startWeek[2] = 1
        }
        
        let checkEndWeek = Date().isEndofWeek
        
        let randomDay = Int.random(in: 0..<7)
        let randomTime = Int.random(in: 0..<self.workoutTimes.count)
        let workoutDate = formatter.date(from: "\(year)-\(month)-\(day+randomDay) \(self.workoutTimes[randomTime])") ?? Date()
        
        if self.firstCalendar==0{
            self.check_permission(start_date: workoutDate, event_name: self.setWorkouts[indexPath.row])
        }
    
        
        if checkEndWeek==true{
            self.firstCalendar = 0
        } else {
            self.firstCalendar = self.firstCalendar + 1
        }
        
        cell.workoutLabel.text = self.setWorkouts[indexPath.row] + " at \(month)/\(day+randomDay)/\(year) \(self.workoutTimes[randomTime])"
        cell.checkMarkImage.image = UIImage(named: "icons8-unchecked-checkbox-50")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? WorkoutCell else {return}
        
        cell.checkMarkImage.image = UIImage(named: "icons8-checked-checkbox-50")
        
        self.progress = self.progress + (100/self.workoutFreq)
        if self.progress == 99{
            self.progress = 100
        }
        
        if self.progress < 100 {
            self.progressInfo.text = "You are \(self.progress)% complete!"
            let childUpdates = ["/users/\(self.user.userID!)/progress": self.progress]
            self.ref.updateChildValues(childUpdates)
        }
        else if self.progress == 100{
            self.progress = 100
            self.progressInfo.text = "You Finished! Great Work!"
            let childUpdates = ["/users/\(self.user.userID!)/progress": self.progress]
            self.ref.updateChildValues(childUpdates)
        }
        else {
            //Wait until end of Week, then reset progress to 0\
            let checkEndofWeek = Date().isEndofWeek
            if checkEndofWeek==true{
                self.progress = self.progress - 100
                self.progressInfo.text = "You are \(self.progress)% complete!"
                let childUpdates = ["/users/\(self.user.userID!)/progress": self.progress]
                self.ref.updateChildValues(childUpdates)
            }
            
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
                event.endDate = event.startDate.addingTimeInterval(TimeInterval(self.lengthOfWorkout))
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
extension Date {
    var startOfWeek: [Int] {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return [0] }
        let calendarDate = Calendar.current.dateComponents([.day, .month, .year], from: sunday)
        let year = calendarDate.year!
        let month = calendarDate.month!
        let day = calendarDate.day!
        return [year, month, day]//gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: [Int]{
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return [0]}
        let calendarDate = gregorian.date(byAdding: .day, value: 7, to: sunday)
        let dayFormat = DateFormatter()
        dayFormat.dateFormat = "d"
        let endDay = Int(dayFormat.string(from: calendarDate!)) ?? 1
        let monthFormat = DateFormatter()
        monthFormat.dateFormat = "M"
        let endMonth = Int(monthFormat.string(from: calendarDate!)) ?? 3
        let yearFormat = DateFormatter()
        yearFormat.dateFormat = "yyyy"
        let endYear = Int(yearFormat.string(from: calendarDate!)) ?? 2021
        return [endYear, endMonth, endDay]
    }
    
    var isEndofWeek: Bool {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return false }
        let calendarDate = gregorian.date(byAdding: .day, value: 7, to: sunday)
        let dayFormat = DateFormatter()
        dayFormat.dateFormat = "d"
        let endDay = Int(dayFormat.string(from: calendarDate!)) ?? 1
        let monthFormat = DateFormatter()
        monthFormat.dateFormat = "M"
        let endMonth = Int(monthFormat.string(from: calendarDate!)) ?? 3
        let yearFormat = DateFormatter()
        yearFormat.dateFormat = "yyyy"
        _ = Int(yearFormat.string(from: calendarDate!)) ?? 2021
        
        let currDay = Date()
        let currDate = Calendar.current.dateComponents([.day, .month, .year], from: currDay)
        let currMonth = currDate.month!
        let curr_day = (Int(currDate.day!) + 1)
        return (endMonth==currMonth && endDay==curr_day)
    }
}
