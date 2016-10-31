//
//  REDCapAPI.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/27/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

func getURL (_ url:String){
    Alamofire.request(url).responseJSON { response in
        print("request: \(response.request)")
        print("response: \(response.response)")
        print("data: \(response.data)")
        print("result: \(response.result)")
        
        if let JSON = response.result.value {
            print("JSON: \(JSON)")
        }
        
    }
}

func postToURL (withData data:[String:Any], andContext context:[String:Any]){
    var jsonString = ""

    for (key, value) in data{
        let jsonData : [String:Any] = ["records": context["record"] as! String,
                                       "redcap_event_names": context["event_name"] as! String,
                                       "field_names": key,
                                       "values": value]
        jsonString += "\(JSON(jsonData)),"
    }
    
    
    jsonString.remove(at: jsonString.index(before: jsonString.endIndex))
    jsonString.insert("]", at:jsonString.endIndex)
    print(jsonString)

//Comment to avoid API calls during debugging above code -
    let parameters: Parameters =
        
    [   "token": TOKEN,
        "content": "record",
        "format": "json",
        "type": "eav",
        "overwriteBehavior": "normal",
        "data": jsonString,
        "returnContent": "count",
        "returnFormat": "json"
    ]
    
    Alamofire.request("https://redcap.vanderbilt.edu/api/", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
    
    //TODO: consider adding more specific error handling prior to incrementing
    /*
         No internet: response.response == nil
         + internet, badly formed request: response.result == .success
         Successful submission: response.result.value's parsed JSON dict["count"] == 1
         
    */

        print(response.debugDescription)
        
        if response.response == nil {
            print("An error has occurred.  Please check your internet connection.  If the error persists, please contact the study coordinator.")
            //TODO: return to main screen +/- save PVT data to send at a later time.
        }
        
        
        if let rawJSONResponse = response.result.value {
            if response.result.isSuccess && JSON(rawJSONResponse)["count"] == nil  {
                print("Successfully captured failure!")
                //TODO: Use Alamofire to send response.debugDescription to email via mailto:
            }
        
        }
    }
//end comment

}
