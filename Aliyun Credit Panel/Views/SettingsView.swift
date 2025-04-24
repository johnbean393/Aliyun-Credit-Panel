//
//  SettingsView.swift
//  Aliyun Credit Panel
//
//  Created by John Bean on 4/24/25.
//

import LaunchAtLogin
import SwiftUI

struct SettingsView: View {
    
    @AppStorage("endpoint") private var endpoint: String = Settings.endpoint
    @AppStorage("refreshInterval") private var refreshInterval: Int = Settings.refreshInterval
    
    @State private var accessKeyId: String = Settings.accessKeyId
    @State private var accessKeySecret: String = Settings.accessKeySecret
    
    var body: some View {
        TabView {
            form
                .tabItem {
                    Label(
                        "General",
                        systemImage: "gear"
                    )
                }
        }
    }
    
    var form: some View {
        Form {
            Section {
                launchAtLogin
                refreshIntervalPicker
            } header: {
                Text("General")
            }
            Section {
                credentials
            } header: {
                Text("Credentials")
            }
            Section {
                endpointEditor
            } header: {
                Text("Endpoint")
            }
        }
        .formStyle(.grouped)
    }
    
    var launchAtLogin: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Launch at Login")
                    .font(.title3)
                    .bold()
                Text("Controls whether Aliyun Credit Panel launches automatically at login.")
                    .font(.caption)
            }
            Spacer()
            LaunchAtLogin.Toggle()
                .labelsHidden()
        }
    }
    
    var refreshIntervalPicker: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Refresh Interval")
                    .font(.title3)
                    .bold()
                Text("Determines how often the panel refreshes credit information.")
                    .font(.caption)
            }
            Spacer()
            Picker(
                "",
                selection: $refreshInterval.animation(.linear)
            ) {
                ForEach(
                    Settings.RefreshInterval.allCases,
                    id: \.rawValue
                ) { interval in
                    Text(interval.description)
                        .tag(interval.rawValue)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    var credentials: some View {
        Group {
            keyIdEditor
            keySecretEditor
        }
        .onAppear {
            self.accessKeyId = Settings.accessKeyId
            self.accessKeySecret = Settings.accessKeySecret
        }
    }
    
    var keyIdEditor: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Access Key ID")
                    .font(.title3)
                    .bold()
                Text("Needed to access the Aliyun Console API")
                    .font(.caption)
                Button {
                    let url: URL = URL(
                        string: "https://ram.console.aliyun.com/users/"
                    )!
                    NSWorkspace.shared.open(url)
                } label: {
                    Text("Get a Key ID")
                }
            }
            Spacer()
            SecureField("", text: self.$accessKeyId)
                .textContentType(.password)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
                .onChange(
                    of: self.accessKeyId
                ) { oldValue, newValue in
                    Settings.accessKeyId = newValue
                }
        }
    }
    
    var keySecretEditor: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Access Key Secret")
                    .font(.title3)
                    .bold()
                Text("Needed to access the Aliyun Console API")
                    .font(.caption)
                Button {
                    let url: URL = URL(
                        string: "https://ram.console.aliyun.com/users/"
                    )!
                    NSWorkspace.shared.open(url)
                } label: {
                    Text("Get a Key Secret")
                }
            }
            Spacer()
            SecureField("", text: self.$accessKeySecret)
                .textContentType(.password)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
                .onChange(
                    of: self.accessKeySecret
                ) { oldValue, newValue in
                    Settings.accessKeySecret = newValue
                }
        }
    }
    
    var endpointEditor: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Endpoint")
                    .font(.title3)
                    .bold()
                Text("The API endpoint for Aliyun Console")
                    .font(.caption)
            }
            Spacer()
            TextField("", text: self.$endpoint)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
        }
    }
    
}

#Preview {
    SettingsView()
}
