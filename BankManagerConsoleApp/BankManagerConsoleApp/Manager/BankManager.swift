//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

struct BankManager {
    private var bank: Bank
    var checkFinished: Bool {
        bank.isFinished
    }

    private enum Constants {
        static let minimumValueOfRandomCustomers = 10
        static let maximumValueOfRandomCustomers = 30
        static let defaultTimespent = 0.7
    }

    init() {
        let depositBankTeller1 = BankTeller(myWorkType: .deposit)
        let depositBankTeller2 = BankTeller(myWorkType: .deposit)
        let loanBankTeller = BankTeller(myWorkType: .loan)
        self.bank = Bank(bankTellers: [depositBankTeller1, depositBankTeller2, loanBankTeller])
    }

    mutating func open() {
        let customers = generateRandomCustomers()
        bank.visit(customers: customers)

        bank.startWorking()

        while !checkFinished {

        }

        ConsoleManager.presentAllTaskFinished(of: customers)
    }

    private func generateRandomCustomers() -> [Customer] {
        let range = Constants.minimumValueOfRandomCustomers...Constants.maximumValueOfRandomCustomers
        let randomNumber = Int.random(in: range)

        var customers: [Customer] = []
        for id in 1...randomNumber {
            let customer = Customer(id: id, workType: BankTaskType.allCases.randomElement() ?? .deposit)
            customers.append(customer)
        }

        return customers
    }
}
