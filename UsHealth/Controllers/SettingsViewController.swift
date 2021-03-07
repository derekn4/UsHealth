//
//  SettingsViewController.swift
//  UsHealth
//
//  Created by Derek Nguyen on 3/7/21.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SettingsViewController: UIViewController, UIPickerViewDelegate {
    
    var user: GIDGoogleUser!
    
    
    
    @IBOutlet weak var IntensityPicker: UIPickerView!
    
    @IBOutlet weak var WorkoutPicker: UIPickerView!
    private let ref = Database.database().reference()
    let IntensityData = ["Low", "Medium", "High"]
    let WorkoutTypeData = ["Indoor", "Outdoor"]
    let WorkoutNumData = ["1", "2", "3", "4", "5", "6", "7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IntensityPicker.dataSource = self
        IntensityPicker.delegate = self
        WorkoutPicker.dataSource = self
        WorkoutPicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateSettings(_ sender: Any) {
        let intensity = IntensityData[IntensityPicker.selectedRow(inComponent: 0)] as NSString
        let childUpdatesIntensity = ["/users/\(self.user.userID!)/Intensity": intensity]
        self.ref.updateChildValues(childUpdatesIntensity)
        
        
        let workoutType = WorkoutTypeData[WorkoutPicker.selectedRow(inComponent: 0)]  as NSString
        let childUpdatesWorkout = ["/users/\(self.user.userID!)/WorkoutType": workoutType]
        self.ref.updateChildValues(childUpdatesWorkout)
        
        
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
extension SettingsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == IntensityPicker {
            return IntensityData.count
        } else if pickerView == WorkoutPicker {
            return WorkoutTypeData.count
        } else {
            return WorkoutNumData.count
        }
    }
}


extension SettingsViewController: UIDocumentPickerDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == IntensityPicker {
            return IntensityData[row]
        } else if pickerView == WorkoutPicker {
            return WorkoutTypeData[row]
        } else {
            return WorkoutNumData[row]
        }
    }
}
