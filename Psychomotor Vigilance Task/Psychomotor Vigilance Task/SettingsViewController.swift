//
//  SettingsViewController.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/31/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Properties
    @IBOutlet weak var pid: UITextField!
    @IBOutlet weak var specialty: UISegmentedControl!
    @IBOutlet weak var invalid_pid_label: UILabel!
    var context: Context = Context()
    
    // MARK: - VC Lifecycle Mgmt
    override func viewDidLoad() {
        super.viewDidLoad()
        pid.delegate = self
        if let pid_text = context.record {
            self.pid.text = pid_text
        }
        self.specialty.selectedSegmentIndex = context.arm - 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Actions
    @IBAction func reset_pvt_index(_ sender: Any) {
        //#### Debugging code for beta testing ########
        //TODO: Remove when project goes to deployment
        context.pvt_index = 1
        navigationController!.popToRootViewController(animated: true)
    }
    
    @IBAction func save_and_return(_ sender: Any) {
        context.arm = (specialty.selectedSegmentIndex + 1)  //REDCap arm =(specialty index+1).
        
        //pid validation
        let pid_validation_int = Int(pid.text!)
        if pid.text!.characters.count == 6 && pid_validation_int != nil {
            context.record = pid.text!
            navigationController!.popToRootViewController(animated: true)
        } else {
            invalid_pid_label.text = "Please enter a valid ID!"
        }
    }
}
