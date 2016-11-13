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

    static func postToURL (withData data:[String:Any], andContext context:[String:Any], fromCaller caller: Any) {
        //### REDCap API call requires combination of cURL and JSON
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
        
        //### Building headers for HTTP POST body
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
                (caller as! PVTViewController).submission_status = SubmissionStatus.no_connectivity
            }
            if let rawJSONResponse = response.result.value {
                if response.result.isSuccess && JSON(rawJSONResponse)["count"] == nil  {
                    (caller as! PVTViewController).submission_status = SubmissionStatus.api_call_error
                }
                if response.result.isSuccess && JSON(rawJSONResponse)["count"] != nil  {
                    (caller as! PVTViewController).submission_status = SubmissionStatus.success
                }
            }
        }
    }
}
