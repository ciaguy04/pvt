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

enum SubmissionStatus {
    case no_connectivity
    case api_call_error
    case success
}

enum TrialState {
    case Active
    case Delay
    case Inactive
}

class PVTViewController: UIViewController {
    
    //MARK: Properties
    //MARK: - Outlets
    @IBOutlet weak var counter_view: UILabel!
    
    //MARK: - Test Logic Properties
    var trial_timer = Timer()              //timer within a given trial
    var trial_countdown_timer = Timer()   //randomly generated delay for trial start if trial_state == .Active
    var test_state_timer = Timer()        //timer to check test state
    var trial_state: TrialState
    var start_trial_time: Int64             //the beginning of a given trial
    var current_trial_time: Int64           //used to compare current time to start_trial_time
    var start_pvt_time: Int64               //use this variable to track when 3 minutes are up
    
    //MARK: - Data Management Objects
    var test_data: Test
    var submission_status: SubmissionStatus?
    
    
    //MARK: Initializer
    required init?(coder aDecoder: NSCoder) {
        self.start_trial_time = 0
        self.current_trial_time = 0
        self.start_pvt_time = 0
        self.trial_state = .Inactive
        self.test_data = Test()
        super.init(coder: aDecoder)
    }
    
    //MARK:Overrides
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
    
    //MARK: Custom Test Methods
    func currentTimeMillis() -> Int64 {
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
    func randomNumber(range: Range<Int>) -> Int {
        let min = range.lowerBound
        let max = range.upperBound
        return Int(arc4random_uniform(UInt32(max-min))) + min
    }
    
    @objc func start_trial(){
        self.trial_state = .Active
        self.start_trial_time = currentTimeMillis()
        self.current_trial_time = currentTimeMillis()
        self.trial_timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(update_counter), userInfo: nil, repeats: true)
    }
    
    @objc func update_counter() {
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
    
    @objc func start_trial_countdown(){
        if currentTimeMillis() - self.start_pvt_time <= 10000 {
            print(String(currentTimeMillis() - self.start_pvt_time) + "ms into the test")               //caveman debugging tool
            switch self.trial_state{
            case .Inactive:
                self.trial_state = .Delay
                counter_view!.text! = ""
                let delay = randomNumber(range: 2..<9)
                print("The Random # is: " + String(delay) + " at " + String(currentTimeMillis() - self.start_pvt_time))                                              //caveman debugging tool
                self.trial_countdown_timer = Timer.scheduledTimer(timeInterval: Double(delay), target: self, selector: #selector(start_trial), userInfo: nil, repeats: false)
            case .Active:
                print(".Active")
                return
            case .Delay:
                print(".Delay")
                return
            }
            
        } else {
            self.test_state_timer.invalidate()
            self.trial_countdown_timer.invalidate()
            REDCapAPI.postToURL(withData: self.test_data.data_dict, andContext: self.test_data.context_dict, fromCaller: self)
            counter_view!.text! = "END TEST"
            show_end_test_alert()
            
        }
        
        /* Data that needs to be sent:
         
         Data Elements:
         start_datetime
         trial_time_list
         num_fs
         pvt_data_complete -> set to '1' (unverified)
         
         Context Elements:
         record
         redcap_event_name:  (pre | post)_(day | night)_[1-5]_pvt_arm_[1-3]
         
         */
        
    }
    
    func show_end_test_alert () {
        let message = "You've finished the test."
        let alert = UIAlertController(title: "Test Completed", message: message, preferredStyle: .alert)
        let default_action = UIAlertAction(title: "OK", style: .default) {
            _ in
            self.performSegue(withIdentifier: "TestResultVC", sender: ["num_fs": self.test_data.data_dict["num_fs"],
                                                                       "trial_time_list": self.test_data.trial_time_list,
                                                                       "api_call_success":self.submission_status ?? .no_connectivity])
        }
        alert.addAction(default_action)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? TestResultVC {
            if let data = sender as? [String:Any] {
                destination.pvtvc_dict = data
                if (data["api_call_success"] as? SubmissionStatus) == SubmissionStatus.success {
                    test_data.test_context.pvt_index += 1
                }
            }
        }
    }
    
    //MARK: Actions
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
            print("False Start" + test_data.data_as_string)
            self.trial_countdown_timer.invalidate()
            self.trial_state = .Inactive
        }
    }
}
