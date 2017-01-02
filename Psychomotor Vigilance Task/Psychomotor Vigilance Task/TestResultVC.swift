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
    
    //MARK: - Outlets
    @IBOutlet weak var test_label: UILabel!
    @IBOutlet weak var submission_pending: UIActivityIndicatorView!
    
    //MARK: - Properties
    private var _pvtvc: PVTViewController?
    private var status_update_timer = Timer()
    
    //MARK: - Computed Properties
    var pvtvc: PVTViewController {
        get{
            return _pvtvc!
        } set {
            _pvtvc = newValue
        }
    }
    
    //MARK: - VC Lifecycle Mgmt
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        if self.pvtvc.test_data.test_context.pvt_index >= 0 {
            initialize_activity_indicator()
            self.status_update_timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(update_status), userInfo: nil, repeats: true)
        } else if pvtvc.test_data.test_context.pvt_index == -1 {
            self.submission_pending.isHidden = true
            self.test_label.textColor = UIColor.red
            self.test_label!.text = "Your study has not yet started.  Please contact the study coordinator if you believe this is an error."
        } else if pvtvc.test_data.test_context.pvt_index == -2 {
            self.submission_pending.isHidden = true
            self.test_label.textColor = UIColor.red
            self.test_label!.text = "Your study has concluded.  Thank you for participating!"
        }
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
    
    // MARK: - Custom VC Methods
//    func intArray_to_dubArray(_ intArray: [Int]) -> [Double] {
//        var dubArray: [Double] = []
//        for i in intArray {
//            dubArray.append(Double(i))
//        }
//        return dubArray
//    }
    
    @objc private func update_status () {
        if let status = self.pvtvc.rc_delegate.submission_status {
            self.submission_pending.stopAnimating()
            if status == SubmissionStatus.success {
                self.test_label.text! = status.rawValue
                self.test_label.textColor = UIColor.green
                self.status_update_timer.invalidate()
            } else {
                self.test_label.text! = status.rawValue
                self.test_label.textColor = UIColor.red
                self.status_update_timer.invalidate()
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
