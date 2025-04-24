//
//  AliyunClient.swift
//  Aliyun Credit Panel
//
//  Created by John Bean on 4/24/25.
//

import AlibabacloudBssOpenApi20171214
import AlibabaCloudCredentials
import AlibabacloudOpenApi
import Foundation
import SwiftUI
import Tea
import TeaUtils

public class AliyunClient: ObservableObject {
    
    init() {
        self.client = try? Self.createClient()
        self.timer = nil
    }
    
    /// Static constant for the global ``AliyunClient`` object
    static public let shared: AliyunClient = .init()
    
    /// A `Double` representing the balance at the end of last month
    @Published var lastMonthBalance: Double? = nil
    /// A `Double` representing the current available credit
    @Published var currentBalance: Double = 0
    /// A `Double` for the change since last month
    private var balanceChange: Double? {
        if let lastMonthBalance = self.lastMonthBalance {
            return self.currentBalance - lastMonthBalance
        }
        return nil
    }
    
    
    @Published var currency: String = "CNY"
    
    /// A `Client` object for accessing the API
    private var client: AlibabacloudBssOpenApi20171214.Client?
    /// A `Timer` for updates
    private var timer: Timer?
    
    /// Function to create a client
    public static func createClient() throws -> AlibabacloudBssOpenApi20171214.Client {
        let config: AlibabacloudOpenApi.Config = AlibabacloudOpenApi.Config([
            "accessKeyId": Settings.accessKeyId,
            "accessKeySecret": Settings.accessKeySecret
        ])
        config.endpoint = Settings.endpoint
        return try AlibabacloudBssOpenApi20171214.Client(config)
    }
    
    /// Function to start updates
    public func startUpdates() {
        // Get interval
        let interval: Double = Settings.RefreshInterval.interval?.seconds ?? 900
        // Set timer
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: true
        ) { _ in
            Task { @MainActor in
                await self.update()
            }
        }
    }
    
    /// Function to stop updates
    public func stopUpdates() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /// Function to restart updates
    public func restartUpdates() {
        self.stopUpdates()
        self.startUpdates()
    }
    
    /// Function to update the figures
    @MainActor
    public func update() async {
        // Get client
        let client: AlibabacloudBssOpenApi20171214.Client? = self.client
        if client == nil {
            self.client = try? Self.createClient()
        }
        // If failed
        guard let client else {
            // Show error
            Dialogs.showAlert(
                title: String(localized: "Error"),
                message: String(localized: "Failed to initialize client")
            )
            return
        }
        // Init runtime
        let runtime: TeaUtils.RuntimeOptions = TeaUtils.RuntimeOptions(
            [:]
        )
        // Hit API
        do {
            // Update current balance
            let currentResponse = try await client.queryAccountBalanceWithOptions(
                runtime
            )
            if let availableAmountStr = currentResponse.body?.data?.availableAmount,
               let availableAmount: Double = Double(availableAmountStr) {
                self.currentBalance = availableAmount
            }
            // Update last month balance
            let queryAccountTransactionsRequest: AlibabacloudBssOpenApi20171214.QueryAccountTransactionsRequest = AlibabacloudBssOpenApi20171214.QueryAccountTransactionsRequest([:])
            let lastMonthResponse = try await client.queryAccountTransactionsWithOptions(
                queryAccountTransactionsRequest ,
                runtime
            )
            let lastMonthTransaction = lastMonthResponse
                .body?.data?.accountTransactionsList?
                .accountTransactionsList?.filter { transaction in
                    transaction.billingCycle == Date.lastMonthString
                }.first
            if let lastMonthTransaction,
               let lastMonthBalanceStr = lastMonthTransaction.balance,
               let lastMonthBalance = Double(lastMonthBalanceStr){
                self.lastMonthBalance = lastMonthBalance
            }
        }
        catch {
            // Show error
            Dialogs.showAlert(
                title: String(localized: "Error"),
                message: error.localizedDescription
            )
        }
    }
}

extension AliyunClient {
    
    /// A `Color` for the change
    private var changeColor: Color? {
        guard let balanceChange else {
            return nil
        }
        if balanceChange >= 0 {
            return .green
        } else {
            return .red
        }
    }
    /// An `Angle` for the change
    private var changeAngle: Angle? {
        guard let balanceChange else {
            return nil
        }
        if balanceChange >= 0 {
            return .zero
        } else {
            return .degrees(180)
        }
    }
    /// A view for the balance
    public var balanceView: some View {
        VStack(
            spacing: 11
        ) {
            Group {
                Text("Current Balance: ").bold() + Text("\(currentBalance, specifier: "%.2f") \(currency)")
            }
            .font(.title3)
            // Show change if possible
            if let balanceChange = self.balanceChange,
               let changeAngle = self.changeAngle,
               let changeColor = self.changeColor {
                HStack {
                    Label {
                        Text("\(balanceChange, specifier: "%.2f") \(currency) this month")
                    } icon: {
                        Image(systemName: "arrowtriangle.up.fill")
                            .rotationEffect(changeAngle)
                    }
                    .foregroundColor(changeColor)
                }
            }
        }
    }
    
}
