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

    private var manual_update_requested = false
    private var start_segment_index: Int?
    var rc_delegate = RCDelegate()
    var context: Context = Context()
    
    //TODO: create User class and factor out relevant properties
    //TODO: create date picker object for first
    
    // MARK: - VC Lifecycle Mgmt
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize_views()
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
    
    //MARK: - Custom
    private func initialize_views() {
        pid.delegate = self
        if let pid_text = context.record {
            self.pid.text = pid_text
        }
        self.specialty.selectedSegmentIndex = context.arm - 1
        self.start_segment_index = context.arm-1
        print("Start Segment Index: \(self.start_segment_index!)")
    }
    
    func update_events() {
        let defaults = UserDefaults.standard
        let root_vc = self.navigationController?.viewControllers.first
        let delegate = (root_vc as! ViewController).rc_delegate
        delegate.submission_status = nil
        (root_vc as! ViewController).submission_pending.isHidden = false
        (root_vc as! ViewController).submission_pending.startAnimating()
        (root_vc as! ViewController).hide_start_pvt()
        REDCapAPI.export_events(fromArm: defaults.integer(forKey:ContextKeys.arm), withDelegate: delegate)
        print("RC API called!!")
    }
    
    private func needs_updating () -> Bool {
        let defaults = UserDefaults.standard
        if self.specialty.selectedSegmentIndex != self.start_segment_index! {
            print("Specialty Changed!!")
            return true
        } else if defaults.bool(forKey: ContextKeys.is_first_run)  {
            return true
        } else {
            return self.manual_update_requested
        }
    }
    
    //MARK: - Actions
    @IBAction func reset_pvt_index(_ sender: Any) {
        //#### Debugging code for beta testing ########
        //#### Used to resent pvt index and initialize arm
        //TODO: Remove when project goes to deployment
        context.pvt_index = 1
        context.arm = 1
        context.record = ""
        
        navigationController!.popToRootViewController(animated: true)
    }
    
    @IBAction func save_and_return(_ sender: Any) {
        //same arm?
        context.arm = (specialty.selectedSegmentIndex + 1)  //REDCap arm =(specialty index+1).
        
        //start pid validation
        let pid_validation_int = Int(pid.text!)
        if pid.text!.characters.count == 6 && pid_validation_int != nil {
            context.record = pid.text!
            
            //specialty changed? -> update event dictionary
            context.is_first_run = false
            if self.needs_updating() {
                update_events()
            }
            navigationController!.popToRootViewController(animated: true)
        } else {
            invalid_pid_label.text = "Please enter a valid ID!"
        }
        //end pid validation
    }
}
