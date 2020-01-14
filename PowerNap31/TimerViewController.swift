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
    fileprivate let userNotificationIdentifier = "timerNotification"
    
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
            timerStopped()
        } else {
            myTimer.startTimer(10)
            scheduleNotification()
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
    
    func resetTimer() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            let timerLocalNotificationRequest = requests.filter({ $0.identifier == self.userNotificationIdentifier})
            guard let timerNotificationRequest = timerLocalNotificationRequest.last,
                let trigger = timerNotificationRequest.trigger as? UNCalendarNotificationTrigger,
                let fireDate = trigger.nextTriggerDate()
                else { return }
            
            self.myTimer.stopTimer()
            self.myTimer.startTimer(fireDate.timeIntervalSinceNow)
        }
    }
    
    // Creates the popup window, how it looks
    func setupAlertController() {
        var snoozeTextField: UITextField?
        let alert = UIAlertController(title: "Wake up", message: "or keep snoozing?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Choose how long to snooze"
            textField.keyboardType = .numberPad
            snoozeTextField = textField
            
        }
        
        // snooze button
        let snoozeAction = UIAlertAction(title: "Snooze", style: .default) { (_) in
            guard let snoozeTimeText = snoozeTextField?.text,
                let time = TimeInterval(snoozeTimeText)
                else { return }
            
            self.myTimer.startTimer(time)
            self.updateViews()
        }
        
        // cancel button
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel) { (_) in
            self.updateViews()
        }
        
        alert.addAction(snoozeAction)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    // lock screen notification
    func scheduleNotification() {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "wakey wakey"
        notificationContent.body = "eggs and bakey"
        
        guard let timeRemaining = myTimer.timeRemaining else { return }
        let fireDate = Date(timeInterval: timeRemaining, since: Date())
        let dateComponents = Calendar.current.dateComponents([.minute, .second], from: fireDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: userNotificationIdentifier, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("error")
            }
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [userNotificationIdentifier])
    }
    
}

extension TimerViewController: TimerDelegate {
    func timerSecondTick() {
        updateTimerTextLabel()
    }
    
    func timerCompleted() {
        updateViews()
        setupAlertController()
    }
    
    func timerStopped() {
        updateViews()
        cancelNotification()
    }
    
}
