//
//  SettingsViewController.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/31/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var pid: UITextField!
    @IBOutlet weak var specialty: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        self.pid.text = defaults.string(forKey:"REDCap_record")
        self.specialty.selectedSegmentIndex = defaults.integer(forKey:"specialty")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func save_settings_and_return(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(Int(pid.text!), forKey: "REDCap_record")
        //print(pid.text!)
        
        defaults.set(specialty.selectedSegmentIndex, forKey: "specialty")
        //print(specialty.selectedSegmentIndex)
        
        defaults.synchronize()
        
        print(defaults.dictionaryRepresentation().debugDescription)
        

    }

}
