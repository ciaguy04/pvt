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
    var jsonString = "["
    
    
    //TODO: keys in data (below) should be hardcoded, values passed as dict: [String:Any]-> for each key, take elements and add to data dictionary -> append jsonString with dict

    for (key, value) in data{
        let jsonData : [String:Any] = ["record": context["record"] as! String,
                                       "redcap_event_name": context["event_name"] as! String,
                                       "field_name": key,
                                       "value": value]
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
        "returnFormat": "json"              //TODO: may need to add the DateTime format argument (currently proposed format: 2016-10-29)
    ]
    
    Alamofire.request("https://redcap.vanderbilt.edu/api/", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
        
        print("request: \(response.request)")
        print("response: \(response.response)")
        print("data: \(response.data)")
        print("result: \(response.result)")
        
        if let JSON = response.result.value {
            print("JSON: \(JSON)")
        }
    }
//end comment

}
