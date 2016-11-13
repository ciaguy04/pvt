//
//  PVTViewController.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/27/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//


import UIKit
import CoreData
import Alamofire

enum SubmissionStatus: String {
    case no_connectivity = "An error has occurred.  Please check your internet connection.  If the error persists, please contact the study coordinator."
    case api_call_error = "API Call Error"
    case success = "Successfully submitted to REDCap! Thank you."
}

enum TrialState {
    case Active
    case Delay
    case Inactive
}

class PVTViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var counter_view: UILabel!
    
    //MARK: - Test Logic Properties (private)
    /*
    ###  A single PVT test consists of sequential 'trials', each of which test the user's reaction time.
    */
    private var trial_timer = Timer()             //timer within a given trial (ie. intra-trial timer)
    private var trial_countdown_timer = Timer()   //randomly generated delay for trial start if trial_state == .Inactive (ie. inter-trial timer)
    private var test_state_timer = Timer()        //timer that spans entire test, sequentially checking test state
    private var trial_state: TrialState
    private var start_trial_time: Int64             //the beginning of a given trial
    private var current_trial_time: Int64           //used to compare current time to start_trial_time
    private var start_pvt_time: Int64               //use this variable to track when 3 minutes are up
    
    //MARK: - Data Management Properties
    var test_data: Test
    var submission_status: SubmissionStatus?
    
    
    //MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        self.start_trial_time = 0
        self.current_trial_time = 0
        self.start_pvt_time = 0
        self.trial_state = .Inactive
        self.test_data = Test()
        super.init(coder: aDecoder)
    }
    
    //MARK: - VC Lifecycle Mgmt
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.start_pvt_time = currentTimeMillis()
        self.test_state_timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(start_trial_countdown), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.test_state_timer.invalidate()
        self.trial_countdown_timer.invalidate()
        self.trial_timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Custom Test Methods (private)
    
    //### method to return the current time (ms) - each trial requires timer precision near 50-100ms
    private func currentTimeMillis() -> Int64 {
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
    //### method returns random number between a range
    private func randomNumber(range: Range<Int>) -> Int {
        let min = range.lowerBound
        let max = range.upperBound
        return Int(arc4random_uniform(UInt32(max-min))) + min
    }
    
    //### method called to start a single trial of the overall 3 min test
    @objc private func start_trial(){
        self.trial_state = .Active
        self.start_trial_time = currentTimeMillis()
        self.current_trial_time = currentTimeMillis()
        self.trial_timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(update_counter), userInfo: nil, repeats: true)
    }
    
    //### method called by start_trial(), which updates the couter_view every 50-100ms (max: 5s per trial)
    @objc private func update_counter() {
        self.current_trial_time = currentTimeMillis()
        if (self.current_trial_time - self.start_trial_time <= 5000){
            counter_view!.text! = String(self.current_trial_time - self.start_trial_time)
            print(counter_view!.text!)
        }
        else {
            self.trial_timer.invalidate()
            self.test_data.trial_time_list.append(5000)
            counter_view!.text! = String(5000)
            self.trial_state = .Inactive
        }
    }
    
    //### if test duration has been < 3min and a test is not active, start one
    //### if time has expired, navigate to next VC and submit to REDCap
    @objc private func start_trial_countdown(){
        if currentTimeMillis() - self.start_pvt_time <= 180000 {
            switch self.trial_state{
            case .Inactive:
                self.trial_state = .Delay
                counter_view!.text! = ""
                let delay = randomNumber(range: 2..<9)
                self.trial_countdown_timer = Timer.scheduledTimer(timeInterval: Double(delay), target: self, selector: #selector(start_trial), userInfo: nil, repeats: false)
            case .Active:
                return
            case .Delay:
                return
            }
            
        } else {
            self.test_state_timer.invalidate()
            self.trial_countdown_timer.invalidate()
            REDCapAPI.postToURL(withData: self.test_data.data_dict, andContext: self.test_data.context_dict, fromCaller: self)
            counter_view!.text! = "END TEST"
            show_end_test_alert()
        }
    }
    
    private func show_end_test_alert () {
        let message = "You've finished the test."
        let alert = UIAlertController(title: "Test Completed", message: message, preferredStyle: .alert)
        let default_action = UIAlertAction(title: "OK", style: .default) {
            _ in
            self.performSegue(withIdentifier: "TestResultVC", sender: self)
        }
        alert.addAction(default_action)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TestResultVC {
            destination.pvtvc = self
        }
    }
    
    //MARK: - Actions
    @IBAction func view_touched(_ sender: Any) {
        switch self.trial_state{
        case .Active:
            self.current_trial_time = currentTimeMillis()
            self.trial_timer.invalidate()
            self.trial_state = .Inactive
            self.test_data.trial_time_list.append(self.current_trial_time - self.start_trial_time)
            counter_view!.text! = String(self.current_trial_time - self.start_trial_time)
            
        default:
            counter_view!.text! = "FALSE START!!"
            test_data.num_fs += 1
            self.trial_countdown_timer.invalidate()
            self.trial_state = .Inactive
        }
    }
}
