//
//  TestResultVC.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 11/10/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import UIKit

class TestResultVC: UIViewController {
    
    //MARK: - Outlets / Properties
    @IBOutlet weak var test_label: UILabel!
    private var _pvtvc_dict: [String: Any]?
    
    //MARK: - Computed Properties
    var pvtvc_dict: [String: Any] {
        get{
            return _pvtvc_dict! 
        } set {
            _pvtvc_dict = newValue
        }
    }
    
    var pvtvc_num_fs: Int {
        get{
            return _pvtvc_dict!["num_fs"] as! Int
        }
    }
    
    var pvtvc_trial_time_list: [Int] {
        get{
            return _pvtvc_dict!["trial_time_list"] as! [Int]
        }
    }
    
    var pvtvc_call_success: SubmissionStatus {
        get{
            return _pvtvc_dict!["api_call_success"] as! SubmissionStatus
        }
    }
    
    //MARK: - VC Lifecycle Mgmt
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        print("\(pvtvc_num_fs) \n \(pvtvc_trial_time_list.debugDescription) \n \(pvtvc_call_success)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Actions
    
    @IBAction func navigate_home(_ sender: Any) {
        navigationController!.popToRootViewController(animated: true)
    }

    

}
