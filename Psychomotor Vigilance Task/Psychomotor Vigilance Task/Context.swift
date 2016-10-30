//
//  Context.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/29/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import Foundation

class Context {
    let record: String
    let event_name: String
    let pvt_data_complete = 1               //hardcoded value to denote '1' (unverified) status in REDCap Project
    
    init(){
        self.record = "3"
        self.event_name = "post_night_4_pvt_arm_1"          //redcap_event_name:  (pre | post)_(day | night)_[1-5]_pvt_arm_[1-3]
    }
}
