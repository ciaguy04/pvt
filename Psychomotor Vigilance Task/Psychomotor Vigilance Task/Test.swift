//
//  Test.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/28/16.
//  Copyright © 2016 vu_sleep. All rights reserved.  
//

import Foundation

class Test {
    let test_context: Context           //contextual data
    let start_datetime : Date
    var trial_time_list : [Int]         //data
    var num_fs: Int                     //data
    
    
    //MARK: Computed properties
    var data_as_string: String {
        return "Test Start: \(self.start_datetime) \n" + "Test Data:" + self.trial_time_list.description + "\n" + "False Starts: \(num_fs)"
    }
    
    var start_date: String{
        //let userCalendar = Calendar.current
        let myFormatter = DateFormatter()
        myFormatter.locale = Locale(identifier: "en_US_POSIX")
        myFormatter.dateFormat = "y-MM-dd"
        return myFormatter.string(from:self.start_datetime)
    }
    
    var start_time: String{
        let myFormatter = DateFormatter()
        myFormatter.locale = Locale(identifier: "en_US_POSIX")
        myFormatter.dateFormat = "H:mm"
        return myFormatter.string(from:self.start_datetime)
    }
    
    var data_dict: [String: Any] {
        return ["start_date": self.start_date,
                "start_time": self.start_time,
                "trial_time_list": self.trial_time_list.description,
                "num_fs": self.num_fs,
                "pvt_data_complete": self.test_context.pvt_data_complete] as [String : Any]
    }
    
    var context_dict: [String: Any] {
        return ["record": self.test_context.record,
                "event_name": self.test_context.event_name] as [String: Any]
    }
    
    
    
    init(){
        self.start_datetime = Date()
        self.trial_time_list = []
        self.num_fs = 0
        self.test_context = Context()
        
    }
    
    func send_data_dict() {
        postToURL(withData:self.data_dict, andContext: self.context_dict)
    }
    
/* Data that needs to be sent:

    Data Elements:
    start_datetime
    trial_time_list
    num_fs
    pvt_data_complete -> set to '1' (unverified)
 
    Context Elements:
    record
    redcap_event_name:  (pre | post)_(day | night)_[1-5]_pvt_arm_[1-3]
 
*/


    
}
