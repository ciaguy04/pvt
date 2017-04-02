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
    @IBOutlet weak var invalid_pid_label: UILabel!
    @IBOutlet weak var submission_pending: UIActivityIndicatorView!

    private var event_update_timer = Timer()
    private var start_date_update_timer = Timer()
    private var start_pid: String?
    private var can_save_and_return = true
    var rc_delegate: [String: RCDelegate] = [:]
    var context: Context = Context()
    
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
    
    //MARK: - Custom
    private func initialize_views() {
        pid.delegate = self
        if let pid_text = context.record {
            self.pid.text = pid_text
            self.start_pid = pid_text
            print("Start PID: \(self.start_pid!)")
        }
    }
    
    private func validate_pid() -> Bool {
        let pid_validation_int = Int(pid.text!)
        if pid.text!.characters.count == 6 && pid_validation_int != nil {
            return true
        } else {
            return false
        }
    }
    
    //MARK: Update Event API Call Methods
    private func update_events() {
        self.rc_delegate[ContextKeys.event_list] = RCDelegate()
        REDCapAPI.export_events(fromArm: 1, withDelegate: self.rc_delegate[ContextKeys.event_list]!)
        print("RC API called!!")
    }
    
    private func check_for_event_api_call() {             //########%%
        self.event_update_timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(update_event_status), userInfo: nil, repeats: true)
    }
    
    @objc private func update_event_status () {
        print("Async Loop: running update_event_status()")
        print("Submission status: \(self.rc_delegate[ContextKeys.event_list]!.submission_status?.rawValue)")
        self.submission_pending.startAnimating()
        if let status = self.rc_delegate[ContextKeys.event_list]!.submission_status {
            self.submission_pending.hidesWhenStopped = true
            self.submission_pending.stopAnimating()
            self.event_update_timer.invalidate()
            if status == SubmissionStatus.success {
                self.rc_delegate[ContextKeys.event_list]!.persist_event_data(self.context)
                invalid_pid_label.textColor = UIColor.green
                invalid_pid_label.text = "Successfully updated."
                self.can_save_and_return = true
            } else {
                let alert = UIAlertController(title: "Error!", message: status.rawValue, preferredStyle: .alert)
                let default_action = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(default_action)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            print("Awaiting API response")
        }
    }
    
    //MARK: Start Date API Call Methods
    private func pid_has_changed() -> Bool {
        if self.start_pid! != self.pid.text! {
            print("pid changed!")
            return true
        } else {
            return false
        }
    }
    
    private func find_start_date() {
        self.rc_delegate[ContextKeys.start_date] = RCDelegate()
        REDCapAPI.export_record(fromID: self.context.record!, withDelegate: self.rc_delegate[ContextKeys.start_date]!)
    }
    
    private func check_for_start_date_api_call() {
        self.start_date_update_timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(update_start_date_status), userInfo: nil, repeats: true)
    }
    
    @objc private func update_start_date_status () {
        print("Async Loop: running update_start_date_status()")
        print("Submission status: \(self.rc_delegate[ContextKeys.start_date]!.submission_status?.rawValue)")
        if let status = self.rc_delegate[ContextKeys.start_date]!.submission_status {
            self.submission_pending.hidesWhenStopped = true
            self.submission_pending.stopAnimating()
            self.start_date_update_timer.invalidate()
            if status == SubmissionStatus.success {
                self.rc_delegate[ContextKeys.start_date]!.persist_start_date_data(self.context)
                self.start_pid = pid.text!
                self.context.record = pid.text!
                invalid_pid_label.textColor = UIColor.green                 //TODO: Consider merging this check with event
                invalid_pid_label.text = "Successfully updated."
                self.can_save_and_return = true                             //### Ditto to ^^^^
            } else {
                print(self.rc_delegate[ContextKeys.start_date]!.submission_status?.rawValue ?? "Not sure what happened...")
                let alert = UIAlertController(title: "Error!", message: status.rawValue, preferredStyle: .alert)
                let default_action = UIAlertAction(title: "OK", style: .default) {
                    _ in
                    self.pid!.text = self.start_pid!
                    self.context.record = self.start_pid!
                    self.can_save_and_return = true
                }
                alert.addAction(default_action)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            print("Awaiting API response")
        }
    }
    
    //MARK: - Actions
    @IBAction func sync_changes(_ sender: Any) {
        
        //specialty changed? -> update event dictionary
        if validate_pid() {
            if context.start_date == nil || pid_has_changed() {
                self.can_save_and_return = false
                context.record = pid!.text
                self.submission_pending.startAnimating()
                find_start_date()
                check_for_start_date_api_call()
                print("Start Date: \(self.context.start_date)")
            }
        } else {
            invalid_pid_label.textColor = UIColor.red
            invalid_pid_label.text = "Please enter a valid ID!"
        }
        if context.event_list == nil  {
            self.submission_pending.startAnimating()
            self.can_save_and_return = false
            update_events()
            check_for_event_api_call()
        }
    }
    
    @IBAction func save_and_return(_ sender: Any) {
        if context.start_date != nil || !pid_has_changed() {
            if self.can_save_and_return{
                if validate_pid() {
                    context.record = pid.text!
                    navigationController!.popToRootViewController(animated: true)
                } else {
                    invalid_pid_label.textColor = UIColor.red
                    invalid_pid_label.text = "Please enter a valid ID!"
                }
            } else {
                invalid_pid_label.textColor = UIColor.red
                invalid_pid_label.text = "Please wait for application to update or go back to cancel."
            }
        } else {
            invalid_pid_label.textColor = UIColor.red
            invalid_pid_label.text = "Please enter valid ID and sync with REDCap."
        }
    }
}
