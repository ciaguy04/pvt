//
//  TestResultVC.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 11/10/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import UIKit

class TestResultVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
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
