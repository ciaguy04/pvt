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
    @IBOutlet weak var invalid_pid_label: UILabel!
    
    var context: Context = Context()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pid.text = context.record
        self.specialty.selectedSegmentIndex = context.arm - 1

        // #### Debugging code ########
        //let defaults = UserDefaults.standard
        //defaults.removeObject(forKey: ContextKeys.pvt_index)
        //defaults.removeObject(forKey: ContextKeys.REDCap_record)
        //defaults.removeObject(forKey: ContextKeys.specialty)
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
    

    @IBAction func save_and_return(_ sender: Any) {
        context.arm = (specialty.selectedSegmentIndex + 1)  //REDCap arm =(specialty index+1).
        
        //pid validation
        let pid_validation_int = Int(pid.text!)
        if pid.text!.characters.count == 6 && pid_validation_int != nil {
            context.record = pid.text!
            presentingViewController!.dismiss(animated: false)
        } else {
            invalid_pid_label.text = "Please enter a valid ID!"
        }
        
        
    }
    
    @IBAction func cancel_settings(_ sender: Any) {
        presentingViewController!.dismiss(animated: false)
    }
    

}
