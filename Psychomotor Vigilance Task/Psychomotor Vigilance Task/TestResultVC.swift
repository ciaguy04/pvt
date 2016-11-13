//
//  TestResultVC.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 11/10/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import UIKit

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
        initialize_activity_indicator()
        self.status_update_timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(update_status), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom VC Methods
    
    @objc private func update_status () {
        if let status = self.pvtvc.submission_status {
            self.submission_pending.stopAnimating()
            if status == SubmissionStatus.success {
                self.test_label.text! = status.rawValue
                self.test_label.textColor = UIColor.green
                self.status_update_timer.invalidate()
                self.pvtvc.test_data.test_context.increment_pvt_index()
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
