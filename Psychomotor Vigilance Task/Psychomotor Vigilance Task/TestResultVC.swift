//
//  TestResultVC.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 11/10/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import UIKit
import ScrollableGraphView

class TestResultVC: UIViewController {
    
    //MARK: - Outlets / Properties
    @IBOutlet weak var test_label: UILabel!
    @IBOutlet weak var submission_pending: UIActivityIndicatorView!
    private var _pvtvc: PVTViewController?
    private var status_update_timer = Timer()
//    private var _pvtvc_dict: [String: Any]?
    
    //MARK: - Computed Properties
    var pvtvc: PVTViewController {
        get{
            return _pvtvc!
        } set {
            _pvtvc = newValue
        }
    }
    
//    var pvtvc_dict: [String: Any] {
//        get{
//            return _pvtvc_dict! 
//        } set {
//            _pvtvc_dict = newValue
//        }
//    }
//    
//    var pvtvc_num_fs: Int {
//        get{
//            return _pvtvc_dict!["num_fs"] as! Int
//        }
//    }
//    
//    var pvtvc_trial_time_list: [Int] {
//        get{
//            return _pvtvc_dict!["trial_time_list"] as! [Int]
//        }
//    }
//    
//    var pvtvc_call_success: SubmissionStatus {
//        get{
//            return _pvtvc_dict!["api_call_success"] as! SubmissionStatus
//        }
//    }
    
    //MARK: - VC Lifecycle Mgmt
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        initialize_activity_indicator()
        self.status_update_timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(update_status), userInfo: nil, repeats: true)
        
        
//        let graphView = ScrollableGraphView(frame: CGRect(x:80, y:100, width: 250, height: 400))
//        let labels = [1...pvtvc_trial_time_list.count]
//        graphView.set(data: intArray_to_dubArray(pvtvc_trial_time_list), withLabels: ["1", "2", "3", "4", "5"])
//        graphView.shouldAdaptRange = true
//        graphView.shouldRangeAlwaysStartAtZero = true
//        self.view.addSubview(graphView)
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
    
    // MARK: - Custom
//    func intArray_to_dubArray(_ intArray: [Int]) -> [Double] {
//        var dubArray: [Double] = []
//        for i in intArray {
//            dubArray.append(Double(i))
//        }
//        return dubArray
//    }
    
    @objc private func update_status () {
        if let status = self.pvtvc.submission_status {
            self.submission_pending.stopAnimating()
            if status == SubmissionStatus.success {
                self.test_label.text! = status.rawValue
                self.test_label.textColor = UIColor.green
                self.status_update_timer.invalidate()
                self.pvtvc.test_data.test_context.pvt_index += 1
            } else {
                self.test_label.text! = status.rawValue
                self.test_label.textColor = UIColor.red
                self.status_update_timer.invalidate()                       //TODO: - Consider providing further instructions (ie. retake test)
            }
        }
    }
    
    private func initialize_activity_indicator() {
        self.submission_pending.hidesWhenStopped = true
        self.submission_pending.startAnimating()
    }
    
    //MARK: - Actions
    @IBAction func navigate_home(_ sender: Any) {
        navigationController!.popToRootViewController(animated: true)
    }

    

}
