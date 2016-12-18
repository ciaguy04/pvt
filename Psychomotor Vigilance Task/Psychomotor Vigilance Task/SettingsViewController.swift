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
    @IBOutlet weak var submission_pending: UIActivityIndicatorView!

    private var status_update_timer = Timer()
    private var can_save_and_return = true
    private var start_segment_index: Int?
    var rc_delegate: [String: RCDelegate] = [:]
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
        self.rc_delegate["event_list"] = RCDelegate()
        REDCapAPI.export_events(fromArm: context.arm, withDelegate: self.rc_delegate["event_list"]!)
        print("RC API called!!")
    }
    
    private func needs_updating () -> Bool {
        //TODO: Likely needs more work
        if self.specialty.selectedSegmentIndex != self.start_segment_index! {
            print("Specialty Changed!!")
            return true
        } else {
            //??return self.manual_update_requested
            return false
        }
    }
    
    private func find_start_date() {
        if context.start_date == nil {
            REDCapAPI.export_record(fromID: self.context.record!, withDelegate: self.rc_delegate)
        } else  {
            print(context.start_date?.debugDescription)
        }
    }
    
    //MARK: - Actions
    @IBAction func reset_pvt_index(_ sender: Any) {
        //#### Debugging code for beta testing ########
        //#### Used to reset pvt index and initialize arm
        //TODO: Remove when project goes to deployment
        context.pvt_index = 1
        context.arm = 1
        context.record = ""
        
        navigationController!.popToRootViewController(animated: true)
        //??let root_vc = self.navigationController?.viewControllers.first
    }
    
    @IBAction func sync_changes(_ sender: Any) {
        //specialty changed? -> update event dictionary
        if self.needs_updating() {
            self.submission_pending.startAnimating()
            self.can_save_and_return = false
            update_events()
            check_for_api_result()
        }
    }
    
    
    @IBAction func save_and_return(_ sender: Any) {
        if self.can_save_and_return {
            
            //start pid validation
            let pid_validation_int = Int(pid.text!)
            if pid.text!.characters.count == 6 && pid_validation_int != nil {
                context.record = pid.text!
                navigationController!.popToRootViewController(animated: true)
            } else {
                invalid_pid_label.textColor = UIColor.red
                invalid_pid_label.text = "Please enter a valid ID!"
            }
            //end pid validation
        } else {
            invalid_pid_label.textColor = UIColor.red
            invalid_pid_label.text = "Please wait for specialty to update or go home to cancel."
        }
    }
    
    //MARK: - Moved from View Controller
    @objc private func update_status () {
        print("running update_status()")
        print("Submission status: \(self.rc_delegate["event_list"]!.submission_status?.rawValue)")
        if let status = self.rc_delegate["event_list"]!.submission_status {
            self.submission_pending.hidesWhenStopped = true
            self.submission_pending.stopAnimating()
            self.status_update_timer.invalidate()
            if status == SubmissionStatus.success {
                context.arm = (specialty.selectedSegmentIndex + 1)  //REDCap arm =(specialty index+1).
                self.start_segment_index = specialty.selectedSegmentIndex
                self.rc_delegate["event_list"]!.persist_data(self.context)
                invalid_pid_label.textColor = UIColor.green
                invalid_pid_label.text = "Successfully updated."
                self.can_save_and_return = true
            } else {
                print(self.rc_delegate["event_list"]!.submission_status?.rawValue ?? "Not sure what happened...")
                let alert = UIAlertController(title: "Error!", message: status.rawValue, preferredStyle: .alert)
                let default_action = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(default_action)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            print("Awaiting API response")
        }
    }
    
    private func check_for_api_result() {             //##
        self.status_update_timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(update_status), userInfo: nil, repeats: true)
    }
}
