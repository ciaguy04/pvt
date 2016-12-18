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
    static let event_list = "event_list"
    static let start_date = "start_date"
}

class Context {
//TODO: Convert into a singleton object to encapsulate persistence
    
    let PVT_DATA_COMPLETE = 1               //constant denotes '1' (unverified) status in REDCap Project
    
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
    
    var event_list: [[String:String]] {
        get { let defaults = UserDefaults.standard
            return defaults.array(forKey: ContextKeys.event_list) as! [[String : String]]
        } set {
            let defaults = UserDefaults.standard
            print("Setting event_list")
            defaults.set(newValue, forKey: ContextKeys.event_list)
            defaults.synchronize()
        }
    }
    
    var start_date: String? {
        get { let defaults = UserDefaults.standard
            return defaults.string(forKey: ContextKeys.start_date)
        } set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: ContextKeys.start_date)
            defaults.synchronize()
        }
    }

    var event_name: String {
        print ("pvt_" + String(pvt_index) + "_arm_" + String(arm))                //debugging
        return "pvt_" + String(pvt_index) + "_arm_" + String(arm)
    }
    
    //MARK: -Methods
    func increment_pvt_index(){
        self.pvt_index += 1
    }
}
