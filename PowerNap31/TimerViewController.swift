//
//  TimerViewController.swift
//  PowerNap31
//
//  Created by Jon Corn on 1/14/20.
//  Copyright © 2020 jdcorn. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    // MARK: - Properties
    let myTimer = TimerController()
    
    // MARK: - Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func startButtonTapped(_ sender: Any) {
        
    }
}

extension TimerViewController: TimerDelegate {
    
}
