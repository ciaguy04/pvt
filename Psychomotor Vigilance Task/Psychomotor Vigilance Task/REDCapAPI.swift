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

func postToURL (_ url:String){
    
    let data : [String: Any] = ["record": "1,2",
                                "field_name":"pvt_data",
                                "value":[1,2,3,4],
                                "redcap_event_name": "post_night_2_pvt_arm_1"]              //TODO: make # of event name mutable
    let jsonString = "[ \(JSON(data))" + "]"
    print(jsonString)
    
    let parameters: Parameters =
        
    [   "token": TOKEN,
        "content": "record",
        "format": "json",
        "type": "eav",
        "overwriteBehavior": "normal",
        "data": jsonString,
        "returnContent": "count",
        "returnFormat": "json"              //TODO: will need to add the DateTime format argument (currently proposed format: 2016-10-29)
    ]
    
    Alamofire.request(url , method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
        
        print("request: \(response.request)")
        print("response: \(response.response)")
        print("data: \(response.data)")
        print("result: \(response.result)")
        
        if let JSON = response.result.value {
            print("JSON: \(JSON)")
        }
    }
}
