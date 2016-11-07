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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: ContextKeys.REDCap_record) == nil {
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


}

