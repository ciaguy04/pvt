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
    case update_error = "An error has occurred.  Check your internet connection and retry to sync your settings.  If the error persists, please contact the study coordinator."
}

class RCDelegate {
    var submission_status: SubmissionStatus?
    var data: [JSON]?
    
    //MARK: -Event Data Methods
    func persist_event_data(_ context: Context) {
        let events = self.filter_events()
        self.update_event_dictionary(context, withJSONList: events)
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
        return filtered_list
    }
    
    private func update_event_dictionary(_ context: Context, withJSONList jsonList: [JSON]) {
        var dictList: [[String:String]] = []
        for event in jsonList {
            let dictObj = event.dictionaryObject! as! [String:String]
            dictList.append(dictObj)
        }
        context.event_list = dictList
    }
    
    //MARK: -Start Date Methods
    func persist_start_date_data(_ context: Context) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm Z"
        let dateString = self.data![0]["value"].stringValue + " 00:00 -0600"
        if let date = dateFormatter.date(from: dateString) {
            context.start_date = date
            print("Start Date: \(context.start_date)")
        }
    }
}
