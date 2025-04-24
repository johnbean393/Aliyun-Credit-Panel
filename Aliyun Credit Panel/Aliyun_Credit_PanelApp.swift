//
//  Aliyun_Credit_PanelApp.swift
//  Aliyun Credit Panel
//
//  Created by John Bean on 4/24/25.
//

import SwiftUI

@main
struct Aliyun_Credit_PanelApp: App {
    
    @Environment(\.colorScheme) var colorScheme
    var isDarkMode: Bool {
        return self.colorScheme == .dark
    }
    
    @StateObject private var client: AliyunClient = .shared
    
    var body: some Scene {
        
        MenuBarExtra {
            ContentView()
                .environmentObject(client)
        } label: {
            Image("aliyun")
        }
        .menuBarExtraStyle(.window)
        
        SwiftUI.Settings {
            SettingsView()
                .frame(maxWidth: 600)
        }
        
    }
    
}
