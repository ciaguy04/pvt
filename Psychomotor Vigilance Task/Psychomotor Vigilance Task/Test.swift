//
//  Test.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/28/16.
//  Copyright © 2016 vu_sleep. All rights reserved.  
//

import Foundation

class Test {
    let test_context: Context           //contextual data for REDCap
    let start_datetime : Date
    var trial_time_list : [Int]         //test data
    var num_fs: Int                     //test data
    
    
    //MARK: Computed properties
    var start_date: String{
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
                "pvt_data_complete": self.test_context.PVT_DATA_COMPLETE] as [String : Any]
    }
    
    var context_dict: [String: Any] {
        return ["record": self.test_context.record!,
                "event_name": self.test_context.event_name] as [String: Any]
    }
 
    init(){
        self.start_datetime = Date()
        self.trial_time_list = []
        self.num_fs = 0
        self.test_context = Context()
    }
}
