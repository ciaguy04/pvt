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
        
        if defaults.array(forKey:"pvt_event_names") == nil {
            defaults.set(["pre_day_1",
                          "post_day_1",
                          "pre_day_2",
                          "post_day_2",
                          "pre_day_3",
                          "post_day_3",
                          "pre_day_4",
                          "post_day_4",
                          "pre_day_5",
                          "post_day_5",
                          "pre_day_6",
                          "post_day_6",
                          "pre_day_7",
                          "post_day_7",
                          "pre_night_1",
                          "post_night_1",
                          "pre_night_2",
                          "post_night_2",
                          "pre_night_3",
                          "post_night_3",
                          "pre_night_4",
                          "post_night_4",
                          "pre_night_5",
                          "post_night_5"], forKey: "pvt_event_names")
            
            defaults.set(0, forKey: "pvt_index")
            defaults.synchronize()
        } else {
            print("pvt_event_names has already been initialized!")
            /*
            //Debugging code
            defaults.removeObject(forKey: "pvt_event_names")
            defaults.removeObject(forKey: "pvt_index")
            defaults.synchronize() */
            
        }
        //if it doesn't already exist, create array of pvt names:
        //redcap_event_name:  (pre | post)_(day | night)_([1-5]|[1-7])_pvt_arm_[1-3]
        
        print(defaults.dictionaryRepresentation().debugDescription)
        
        self.pid.text = defaults.string(forKey:"REDCap_record")         //TODO: -Add Validation
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
        defaults.set(specialty.selectedSegmentIndex, forKey: "specialty")
        defaults.synchronize()
    }

}
