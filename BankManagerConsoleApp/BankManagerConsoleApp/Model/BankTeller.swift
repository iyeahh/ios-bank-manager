//
//  BankTeller.swift
//  BankManagerConsoleApp
//
//  Created by Bora Yang on 2023/02/23.
//

import Foundation

struct BankTeller {
    let id: Int

    func performTask(of customer: Customer) {
        print("bankTeller: \(id))")
        ConsoleManager.presentTaskStarted(of: customer)
        Thread.sleep(forTimeInterval: customer.timespent)
        ConsoleManager.presentTaskFinished(of: customer)
    }
}
