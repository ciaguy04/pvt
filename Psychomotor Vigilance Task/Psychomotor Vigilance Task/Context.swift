//
//  Context.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/29/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import Foundation

struct ContextKeys{
    static let REDCap_record = "REDCap_record"          // aka pid                             // aka specialty + 1
    static let pvt_index = "pvt_index"
    static let event_list = "event_list"
    static let start_date = "start_date"
}

enum TimeOfDay: Int {
    case am = 0
    case pm = 1
}

class Context {
//TODO: Convert into a singleton object to encapsulate persistence
    
    let PVT_DATA_COMPLETE = 1               //constant denotes '1' (unverified) status in REDCap Project
    let PVT_VECTOR = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1]
    
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
    
    var pvt_index: Int {                              //currently due pvt_index
        get {
            let vector_index = (2*(day_offset-1) + self.time_of_day.rawValue)
            print("Vector Index: \(vector_index), Day Offset: \(day_offset), PVT_VECTOR.count\(PVT_VECTOR.count)")
            if (vector_index > PVT_VECTOR.count) {         // Bounds check
                print("study ended")
                return -2
            } else if (day_offset-1 < 0) {
                print("too early!")
                return -1
            } else {
                return PVT_VECTOR[0...vector_index].reduce(0,{$0 + $1})
            }
        }
    }
    
    var event_list: [[String:String]]? {
        get { let defaults = UserDefaults.standard
            return defaults.array(forKey: ContextKeys.event_list) as! [[String : String]]?
        } set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: ContextKeys.event_list)
            defaults.synchronize()
        }
    }
    
    var start_date: Date? {
        get { let defaults = UserDefaults.standard
            return defaults.object(forKey: ContextKeys.start_date) as! Date?
        } set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: ContextKeys.start_date)
            defaults.synchronize()
        }
    }
    
    var day_offset: Int {
        get {
            let userCalendar = Calendar.current
            let nowComponents = userCalendar.dateComponents([.year, .month, .day], from: Date())
            let startComponents = userCalendar.dateComponents([.year, .month, .day], from: start_date!)
            let days_between = userCalendar.dateComponents([.day], from: startComponents, to: nowComponents)
            return days_between.day!
        }
    }
    
    var time_of_day: TimeOfDay {
        get {
            let userCalendar = Calendar.current
            let nowComponents = userCalendar.dateComponents([.year, .month, .day, .hour], from: Date())
            var noon_today_components = userCalendar.dateComponents([.year, .month, .day], from: Date())
            noon_today_components.hour = 12
            let time_between = userCalendar.dateComponents([.second], from: noon_today_components, to: nowComponents)
            if time_between.second! > 0 {
                return .pm
            } else {
                return .am
            }
        }
    }

    var event_name: String {
        print ("pvt_" + String(pvt_index) + "_arm_1")                //debugging
        return "pvt_" + String(pvt_index) + "_arm_1"
    }
}
