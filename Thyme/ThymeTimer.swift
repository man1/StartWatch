//
//  ThymeTimer.swift
//  Thyme
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import Foundation

enum ThymeState {
    case Unstarted, Started, Paused
}

struct ThymeSegment {
    let creationDate: NSDate
    var lastStarted: NSDate? = nil // if `nil`, segment is paused
    var duration: NSTimeInterval = 0

    init() {
        self.creationDate = NSDate()
    }

    init(creationDate: NSDate, duration: NSTimeInterval) {
        self.creationDate = creationDate
        self.duration = duration
    }
}

class ThymeTimer {
    var name: String
    var pastSegments: [ThymeSegment]?
    var currentSegment: ThymeSegment?

    var currentSegmentDuration: NSTimeInterval? {
        if let currentSegment = self.currentSegment {
            return currentSegment.duration - (currentSegment.lastStarted?.timeIntervalSinceNow ?? 0)
        } else {
            return nil
        }
    }

    var totalDuration: NSTimeInterval {
        let pastDuration = self.pastSegments?.reduce(0, combine: { (current: NSTimeInterval, nextSegment: ThymeSegment) -> NSTimeInterval in
            return current + (nextSegment.duration ?? 0)
        })
        return (self.currentSegmentDuration ?? 0) + (pastDuration ?? 0)
    }

    var state: ThymeState {
        if (self.currentSegment?.lastStarted != nil) {
            return .Started
        } else if (self.currentSegment != nil) {
            return .Paused
        } else {
            return .Unstarted
        }
    }

    init(name: String) {
        self.name = name
    }

    class func debugTimer() -> ThymeTimer {
        let newTimer = ThymeTimer(name: "Debug Timer")
        newTimer.pastSegments = [ThymeSegment(creationDate: NSDate(timeIntervalSinceNow: -1000), duration: 100), ThymeSegment(creationDate: NSDate(timeIntervalSinceNow: -2000), duration: 200), ThymeSegment(creationDate: NSDate(timeIntervalSinceNow: -3000), duration: 100)]
        return newTimer
    }
}