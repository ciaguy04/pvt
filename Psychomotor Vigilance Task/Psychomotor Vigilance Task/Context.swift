//
//  Context.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/29/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import Foundation

class Context {
    let pvt_data_complete = 1               //hardcoded value to denote '1' (unverified) status in REDCap Project
    
    //MARK: - Computed Properties
    var record: String {
        let defaults = UserDefaults.standard
        return defaults.string(forKey:"REDCap_record")!
    }
    
    var arm: Int {
        let defaults = UserDefaults.standard
        return (defaults.integer(forKey:"specialty")+1)         //REDCap arm = (specialty index + 1).
    }
    
    var pvt_index: Int {
        let defaults = UserDefaults.standard
        //
        return defaults.integer(forKey: "pvt_index")            //return currently due pvt index
    }
    
    var pvt_name: String {
        let defaults = UserDefaults.standard
        let names = defaults.array(forKey: "pvt_event_names") as! Array<String>
        return names[pvt_index]
    }
    
    var event_name: String {
        return "pre_night_4" + "_pvt_arm_" + String(arm)                //debugging
        //return self.pvt_name + "_pvt_arm_" + String(arm)            //redcap_event_name:  (pre | post)_(day | night)_[1-5]_pvt_arm_[1-3]
    }
    
    
    init(){
    }
    
    func increment_pvt(){
        //increment pvt_index
        //update user defaults
    }
}
