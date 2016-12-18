//
//  ViewController.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/27/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var submission_pending: UIActivityIndicatorView!             //##
    @IBOutlet weak var api_error_label: UILabel!             //##
    
    //MARK: - Properties
    private var status_update_timer = Timer()             //##
    var rc_delegate = RCDelegate()             //##
    var context = Context()             //##
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submission_pending.isHidden = true             //##
        self.rc_delegate.submission_status = SubmissionStatus.success             //##                //when view loads, assume no change was made to arm (specialty)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        //Reminder to setup Participant ID (if pid is nil)
        if defaults.string(forKey: ContextKeys.REDCap_record) == "" {
            let message = "You have not set your Participant ID.  Please navigate to Settings and enter your Participant ID and specialty."
            let alert = UIAlertController(title: "Preferences Not Set!", message: message, preferredStyle: .alert)
            let default_action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(default_action)
            self.present(alert, animated: true, completion: nil)
        }
        print(defaults.dictionaryRepresentation().debugDescription)
        
        check_for_api_result()             //##
        if self.rc_delegate.submission_status == SubmissionStatus.no_connectivity || self.rc_delegate.submission_status == SubmissionStatus.api_call_error {
            hide_start_pvt()             //##
        }
        

        //show_start_pvt()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hide_start_pvt() {
        self.view!.viewWithTag(10)?.isHidden = true
    }
    
    private func show_start_pvt() {
        self.view!.viewWithTag(10)?.isHidden = false
    }
    
    private func check_for_api_result() {             //##
        self.status_update_timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(update_status), userInfo: nil, repeats: true)
    }
    
    @objc private func update_status () {
        print("running update_status()")
        if let status = self.rc_delegate.submission_status {
            self.submission_pending.hidesWhenStopped = true
            self.submission_pending.stopAnimating()
            self.status_update_timer.invalidate()
            if status == SubmissionStatus.success {
                show_start_pvt()
                self.rc_delegate.persist_data(self.context)
                
            } else {
                print(rc_delegate.submission_status?.rawValue ?? "Not sure what happened...")
                self.api_error_label.textColor = UIColor.red
                self.api_error_label.text! = status.rawValue
            }
        } else {
            print("Awaiting API response")
        }
    }

}




