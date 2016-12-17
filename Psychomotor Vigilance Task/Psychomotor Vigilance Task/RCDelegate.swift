//
//  RCDelegate.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 12/13/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import Foundation

enum SubmissionStatus: String {
    case success = "Successfully submitted to REDCap! Thank you."
    case no_connectivity = "An error has occurred.  Please check your internet connection.  If the error persists, please contact the study coordinator."
    case api_call_error = "API Call Error"
    case arm_update_error = "An error has occurred.  Please check your internet connection and retry to update your specialty.  If the error persists, please contact the study coordinator."
}

class RCDelegate {
    var submission_status: SubmissionStatus?
    
}
