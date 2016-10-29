//
//  Test.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/28/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import Foundation

class Test {
    let start_time : Date
    var trial_time_list : [Int]
    var num_fs: Int
    var data_as_string: String {
        return "Test Start: \(self.start_time) \n" + "Test Data:" + self.trial_time_list.description + "\n" + "False Starts: \(num_fs)"
    }
    
    init(){
        self.start_time = Date()
        self.trial_time_list = []
        self.num_fs = 0
    }

    
}
