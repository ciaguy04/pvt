//
//  ViewController.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/27/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        print(defaults.debugDescription)
        
        //Reminder to setup Participant ID (if pid is nil)
        if defaults.string(forKey: ContextKeys.REDCap_record) == "" {
            let message = "You have not set your Participant ID.  Please navigate to Settings and enter your Participant ID and specialty."
            let alert = UIAlertController(title: "Preferences Not Set!", message: message, preferredStyle: .alert)
            let default_action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(default_action)
            self.present(alert, animated: true, completion: nil)
        }
        print(defaults.dictionaryRepresentation().debugDescription)
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
}

