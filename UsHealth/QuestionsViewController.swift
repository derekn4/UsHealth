//
//  QuestionsViewController.swift
//  UsHealth
//
//  Created by Derek Nguyen on 2/20/21.
//

import UIKit

class QuestionsViewController: UIViewController {

    @IBOutlet weak var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendToDash(_ sender: Any) {
        print("Finished questions, go to Home")
        self.performSegue(withIdentifier: "postQsHome", sender: self)
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
