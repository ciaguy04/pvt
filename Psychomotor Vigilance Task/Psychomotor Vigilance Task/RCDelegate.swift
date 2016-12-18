//
//  RCDelegate.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 12/13/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import Foundation
import SwiftyJSON

enum SubmissionStatus: String {
    case success = "Successfully submitted to REDCap! Thank you."
    case no_connectivity = "An error has occurred.  Please check your internet connection.  If the error persists, please contact the study coordinator."
    case api_call_error = "API Call Error"
    case arm_update_error = "An error has occurred.  Please check your internet connection and retry to update your specialty.  If the error persists, please contact the study coordinator."
}

class RCDelegate {
    var submission_status: SubmissionStatus?
    var data: [JSON]?
    
    func persist_data(_ context: Context) {
        let events = self.filter_events()
        self.update_dictionary(context, withJSONList: events)
    }
    
    private func filter_events() -> [JSON] {
        var filtered_list: [JSON] = []
        if let json_events = self.data {
            for event in json_events {
                if String(event["custom_event_label"].stringValue.characters.suffix(2)) == "am" ||
                    String(event["custom_event_label"].stringValue.characters.suffix(2)) == "pm" {
                    filtered_list.append(event)
                }
            }
        }
        print("Filtered List: \(filtered_list.debugDescription)")
        return filtered_list
    }
    
    private func update_dictionary(_ context: Context, withJSONList jsonList: [JSON]) {
        var dictList: [[String:String]] = []
        for event in jsonList {
            let dictObj = event.dictionaryObject! as! [String:String]
            dictList.append(dictObj)
        }
        context.event_list = dictList
    }
}
