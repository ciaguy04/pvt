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
    
    var context: Context = Context()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pid.text = context.record
        self.specialty.selectedSegmentIndex = context.arm - 1

        // #### Debugging code ########
        //let defaults = UserDefaults.standard
        //defaults.removeObject(forKey: "pvt_event_names")
        //defaults.removeObject(forKey: "pvt_index")
        //defaults.synchronize()
        //print(defaults.dictionaryRepresentation().debugDescription)
       

        
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
    
    //TODO: Add save to nav bar
    @IBAction func save_settings_and_return(_ sender: Any) {
        context.record = pid.text!                          //TODO: -Add Validation
        context.arm = (specialty.selectedSegmentIndex + 1)  //REDCap arm =(specialty index+1).
    }

}
