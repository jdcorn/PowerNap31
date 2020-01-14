//
//  TimerController.swift
//  PowerNap31
//
//  Created by Jon Corn on 1/14/20.
//  Copyright © 2020 jdcorn. All rights reserved.
//

import Foundation

protocol TimerDelegate: class {
    func timerSecondTick()
    func timerCompleted()
    func timerStopped()
}

class TimerController {
    
    // MARK: - Properties
    var delegate: TimerDelegate?
    var timer: Timer?
    var timeRemaining: TimeInterval?
    
    var isOn: Bool {
        if timeRemaining != nil {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Functions
    func startTimer(_ time: TimeInterval) {
        if isOn == false {
            timeRemaining = time
            DispatchQueue.main.async {
                self.secondTick()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in self.secondTick()
                })
            }
        }
    }
    
    func secondTick() {
        guard let timeRemaining = timeRemaining else { return }
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            delegate?.timerSecondTick()
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
            delegate?.timerCompleted()
        }
    }
    
    func stopTimer() {
        if isOn == true {
            timeRemaining = nil
            timer?.invalidate()
            delegate?.timerStopped()
        }
    }
    
    func timeRemainingAsString() -> String {
        // If object on left is nil, we'll use info on right
        let timeRemaining = Int(self.timeRemaining ?? 20*60)
        // Take the time we put in divided by 60
        let minutesLeft = timeRemaining / 60
        // Total time remaining times 60 to get our seconds left
        let secondsLeft = timeRemaining - (minutesLeft*60)
        // Formats the timer string to 00 : 00
        return String(format: "%02d : %02d", arguments: [minutesLeft, secondsLeft])
    }
}
