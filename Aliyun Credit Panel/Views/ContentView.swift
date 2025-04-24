//
//  ContentView.swift
//  Aliyun Credit Panel
//
//  Created by John Bean on 4/24/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    var isDarkMode: Bool {
        return self.colorScheme == .dark
    }
    
    @EnvironmentObject private var client: AliyunClient
    
    var body: some View {
        VStack {
            toolbar
            Divider()
            client.balanceView
                .padding(.vertical, 4)
        }
        .padding(.vertical, 10)
        .onAppear() {
            self.refresh()
        }
    }
    
    var toolbar: some View {
        HStack {
            Label {
                Text("Aliyun Credit Panel")
            } icon: {
                Image("aliyun")
            }
            .font(.title3)
            .bold()
            Spacer()
            quitButton
            reloadButton
            SettingsLink()
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
        }
        .padding(.horizontal, 7)
    }
    
    var quitButton: some View {
        Button {
            NSApplication.shared.terminate(nil)
        } label: {
            Label("Quit", systemImage: "power")
                .labelStyle(.iconOnly)
        }
        .buttonStyle(.plain)
    }
    
    var reloadButton: some View {
        Button {
            self.refresh()
        } label: {
            Label(
                "Refresh",
                systemImage: "arrow.triangle.2.circlepath"
            )
            .labelStyle(.iconOnly)
        }
        .buttonStyle(.plain)
    }
    
    private func refresh() {
        Task { @MainActor in
            await self.client.update()
        }
    }
    
}

#Preview {
    ContentView()
}
