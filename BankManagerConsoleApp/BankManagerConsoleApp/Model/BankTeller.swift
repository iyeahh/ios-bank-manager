//
//  BankTeller.swift
//  BankManagerConsoleApp
//
//  Created by Bora Yang on 2023/02/23.
//

import Foundation

struct BankTeller {
    let id: Int
    private(set) var isWorking = false

    mutating func performTask(of customer: Customer) {
        ConsoleManager.presentTaskStarted(of: customer)
        isWorking = true

        Thread.sleep(forTimeInterval: customer.timespent)
        ConsoleManager.presentTaskFinished(of: customer)
        isWorking = false
    }
}
