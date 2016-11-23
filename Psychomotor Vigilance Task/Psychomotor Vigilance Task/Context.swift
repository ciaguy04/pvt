//
//  Context.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/29/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import Foundation

struct ContextKeys{
    static let REDCap_record = "REDCap_record"          // aka pid
    static let arm = "arm"                              // aka specialty + 1
    static let pvt_index = "pvt_index"
}

//TODO: - Convert into a 'singleton facade' to encapsulate persistence
class Context {
    let PVT_DATA_COMPLETE = 1               //constants denote '1' (unverified) status in REDCap Project
    static let PVT_NAMES = ["pre_day_1",    //constants for data fields in REDCap
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
                     "post_night_5"]
    
    //MARK: - Computed Properties
    var record: String? {
        get { let defaults = UserDefaults.standard
            return defaults.string(forKey:ContextKeys.REDCap_record)
        } set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: ContextKeys.REDCap_record)
            defaults.synchronize()
        }
    }
    
    var arm: Int {
        get { let defaults = UserDefaults.standard
            return defaults.integer(forKey:ContextKeys.arm)
        } set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: ContextKeys.arm)
            defaults.synchronize()
        }
    }
    
    var pvt_index: Int {                              //currently due pvt_index
        get { let defaults = UserDefaults.standard
            return defaults.integer(forKey: ContextKeys.pvt_index)
        } set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: ContextKeys.pvt_index)
            defaults.synchronize()
        }
    }

    var event_name: String {
        print (Context.PVT_NAMES[pvt_index] + "_pvt_arm_" + String(arm))                //debugging
        return Context.PVT_NAMES[pvt_index] + "_pvt_arm_" + String(arm)
    }
    
    //MARK: -Methods
    func increment_pvt_index(){
        self.pvt_index += 1
    }
}
