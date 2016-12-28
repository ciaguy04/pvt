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

class REDCapAPI {
    
    static let manager: Alamofire.SessionManager = {
        let serverTrustPolicy = ServerTrustPolicy.performDefaultEvaluation(validateHost: true)
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["redcap.vanderbilt.edu": serverTrustPolicy ]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()

    static func getURL (_ url:String){
        
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

    static func import_record (withData data:[String:Any], andContext context:[String:Any], withDelegate delegate: Any) {
        //### Building JSON String to add to data parameter for .post body
        var jsonString = "["
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
        
        //Building headers for post method body - comment to avoid API calls during debugging above code -> see 'end comment'
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
        
        //### Calling API
        REDCapAPI.manager.request("https://redcap.vanderbilt.edu/api/", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            print(response.debugDescription)
            print(REDCapAPI.manager)
            
            if response.response == nil {
                (delegate as! RCDelegate).submission_status = SubmissionStatus.no_connectivity
                //TODO: return to main screen +/- save PVT data to send at a later time.
            }
            if let rawJSONResponse = response.result.value {
                if response.result.isSuccess && JSON(rawJSONResponse)["count"] == nil  {
                    (delegate as! RCDelegate).submission_status = SubmissionStatus.api_call_error
                }
                if response.result.isSuccess && JSON(rawJSONResponse)["count"] != nil  {
                    (delegate as! RCDelegate).submission_status = SubmissionStatus.success
                }
            }
        }
        //end comment
        
    }
    
    static func export_events (fromArm arm: Int, withDelegate delegate: Any) {
        
        //Building headers for post method body - comment to avoid API calls during debugging above code -> see 'end comment'
        let parameters: Parameters =
            [   "token": TOKEN,
                "content": "event",
                "format": "json",
                "returnFormat": "json",
                "arm": String(arm)
        ]
        
        //### Calling API
        REDCapAPI.manager.request("https://redcap.vanderbilt.edu/api/", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            //print("Response: \(response.debugDescription)")
            //print("Result: \(response.result)")
            //print("Result.value: \(response.result.value)")
            
            
            
            if response.response == nil {
                (delegate as! RCDelegate).submission_status = SubmissionStatus.update_error
            }
            if let rawJSONResponse = response.result.value {
                let json = JSON(rawJSONResponse)
                
                if let error_text = json["error"].string {
                    print("There was an error: \(error_text)")
                    (delegate as! RCDelegate).submission_status = SubmissionStatus.api_call_error
                } else if response.result.isSuccess  {
                    //print("Successful Submission: \(json.array!)")
                    (delegate as! RCDelegate).submission_status = SubmissionStatus.success
                    (delegate as! RCDelegate).data = json.array
                } else {
                    print("not really sure what happened...")
                }
            }
        }
        //end comment
        
    }
    
    static func export_record (fromID record_id: String, withDelegate delegate: Any) {
        
        //Building headers for post method body - comment to avoid API calls during debugging above code -> see 'end comment'
        let parameters: Parameters =
            [   "token": TOKEN,
                "content": "record",
                "format": "json",
                "type": "eav",
                "record": record_id,
                "fields": "day_zero"
        ]
        
        //### Calling API
        REDCapAPI.manager.request("https://redcap.vanderbilt.edu/api/", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            //print("Response: \(response.debugDescription)")
            //print("Result: \(response.result)")
            //print("Result.value: \(response.result.value)")
            
            if response.response == nil {
                (delegate as! RCDelegate).submission_status = SubmissionStatus.update_error
            }
            if let rawJSONResponse = response.result.value {
                let json = JSON(rawJSONResponse)
                print("rawJSONRespose: \(rawJSONResponse)")
                print("JSONized: \(json)")
                
                if let error_text = json["error"].string {
                    print("There was an error: \(error_text)")
                    (delegate as! RCDelegate).submission_status = SubmissionStatus.api_call_error
                } else if response.result.isSuccess  {
                    print("Successful Submission: \(json.array!)")
                    let new_json_list = json.array!.filter{$0["record"].string! == record_id}
                    if new_json_list == [JSON]() {
                        print("new json_list in export_records was null")
                        (delegate as! RCDelegate).submission_status = SubmissionStatus.start_date_api_call_error
                    } else {
                        print("New JSON List: \(new_json_list.debugDescription) -> rc_delegate")
                        print("Submission Status = success")
                        (delegate as! RCDelegate).submission_status = SubmissionStatus.success
                        (delegate as! RCDelegate).data = new_json_list
                    }
                } else {
                    print("not really sure what happened...")
                }
            }
        }
    }
}
