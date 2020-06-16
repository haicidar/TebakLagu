//
//  NotificationName.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 14/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
    static let statusConnected = Notification.Name("didConnected")
    static let statusDisconnected = Notification.Name("didDisconnect")
    static let hostLeft = Notification.Name("hostLeft")
    static let finishSing = Notification.Name("finishSing")
    static let didAnswer = Notification.Name("didAnswer")
    static let checkAnswer = Notification.Name("checkAnswer")
    static let dismissedModal = Notification.Name("dismissedModal")
    
}
