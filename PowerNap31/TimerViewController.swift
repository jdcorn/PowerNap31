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
        updateViews()
        myTimer.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func startButtonTapped(_ sender: Any) {
        if myTimer.isOn {
            myTimer.stopTimer()
        } else {
        myTimer.startTimer(10)
        }
        updateViews()
    }
    
    // MARK: - Functions
    func updateViews() {
        updateTimerTextLabel()
        if myTimer.isOn {
            startButton.setTitle("Stop", for: .normal)
        } else {
            startButton.setTitle("Start nap", for: .normal)
        }
    }
    
    func updateTimerTextLabel() {
        timerLabel.text = myTimer.timeRemainingAsString()
    }
    
}

extension TimerViewController: TimerDelegate {
    func timerSecondTick() {
        updateTimerTextLabel()
    }
    
    func timerCompleted() {
        updateViews()
    }
    
    func timerStopped() {
        updateViews()
    }
    
}
