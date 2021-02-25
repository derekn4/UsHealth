//
//  QuestionsViewController.swift
//  UsHealth
//
//  Created by Derek Nguyen on 2/20/21.
//

import UIKit
import GoogleSignIn
import FirebaseDatabase

class QuestionsViewController: UIViewController, UIPickerViewDelegate {

    let IntensityData = ["Low", "Medium", "High"]
    let WorkoutTypeData = ["Indoor", "Outdoor"]
    let WorkoutNumData = ["1", "2", "3", "4", "5", "6", "7"]
    
    @IBOutlet weak var CurrentWeightTextField: UITextField!
    @IBOutlet weak var GoalWeightTextField: UITextField!
    @IBOutlet weak var AgeTextField: UITextField!
    @IBOutlet weak var FeetTextField: UITextField!
    @IBOutlet weak var InchesTextField: UITextField!
    @IBOutlet weak var IntensityPicker: UIPickerView!
    @IBOutlet weak var WorkoutPicker: UIPickerView!
    @IBOutlet weak var WorkoutNumPicker: UIPickerView!
    private let database = Database.database().reference()
    
    @IBOutlet weak var submit: UIButton!
    var user: GIDGoogleUser!
    var signin: GIDSignIn!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IntensityPicker.dataSource = self
        IntensityPicker.delegate = self
        WorkoutPicker.dataSource = self
        WorkoutPicker.delegate = self
        WorkoutNumPicker.dataSource = self
        WorkoutNumPicker.delegate = self
        // Do any additional setup after loading the view.
        
//        NotificationCenter.default.addObserver(self, selector: #selector(signOutUser(_:)), name: NSNotification.Name("signOut"), object: nil)
    }

//    @objc private func signOutUser(_ notification: Notification) {
//        self.dismiss(animated: true, completion: nil)
//    }

    
    @IBAction func sendToDash(_ sender: Any) {
        print("Finished questions, go to Home")
        //print(user.profile?.email! as Any)
        
        let object: [String: Any] = [
            "CurrentWeight": CurrentWeightTextField.text! as NSString,
            "GoalWeight": GoalWeightTextField.text! as NSString,
            "Age": AgeTextField.text! as NSString,
            "Feet": FeetTextField.text! as NSString,
            "Inches": FeetTextField.text! as NSString,
            "Intensity": IntensityData[IntensityPicker.selectedRow(inComponent: 0)] as NSString,
            "WorkoutType": WorkoutTypeData[WorkoutPicker.selectedRow(inComponent: 0)]  as NSString,
            "NumWorkoutsWeekly": WorkoutNumData[WorkoutNumPicker.selectedRow(inComponent: 0)] as NSString
        ]
        database.child("users").child(user.userID!).setValue(object)
        self.performSegue(withIdentifier: "postQsHome", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let destVC = nav.topViewController as? HomeViewController {
            destVC.user = self.user
            destVC.signin = self.signin
        }
    }
    

}

extension QuestionsViewController: UIPickerViewDataSource {
    
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


extension QuestionsViewController: UIDocumentPickerDelegate{
    
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
