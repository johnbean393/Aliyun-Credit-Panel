//
//  AppDelegate.swift
//  Aliyun Credit Panel
//
//  Created by John Bean on 4/24/25.
//

import AppKit
import Foundation
import SwiftUI

/// The app's delegate which handles life cycle events
public class AppDelegate: NSObject, NSApplicationDelegate {
    
    /// Function that runs after the app is initialized
    public func applicationDidFinishLaunching(
        _ notification: Notification
    ) {
        AliyunClient.shared.startUpdates()
    }
    
    /// Function that runs before the app is terminated
    public func applicationShouldTerminate(
        _ sender: NSApplication
    ) -> NSApplication.TerminateReply {
        AliyunClient.shared.stopUpdates()
        return .terminateNow
    }
    
}
