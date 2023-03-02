//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

struct BankManager {
    private var bank: Bank

    private enum Constants {
        static let minimumValueOfRandomCustomers = 10
        static let maximumValueOfRandomCustomers = 30
    }

    init() {
        let bankTellers: [WorkType: [BankTeller]] = [
            .deposit: [
                BankTeller(id: 1),
                BankTeller(id: 2)
            ],
            .loan: [BankTeller(id: 3)]
        ]

        self.bank = Bank(bankTellers: bankTellers)
    }

    mutating func open() {
        let openTime = DispatchTime.now()

        let customers = generateRandomCustomers()
        bank.visit(customers: customers)

        bank.startWorking(completion: {
            print("BankManager completion")

            let closeTime = DispatchTime.now()

            let nanoTime = closeTime.uptimeNanoseconds - openTime.uptimeNanoseconds
            let passedTime = Double(nanoTime) / 1_000_000_000
            let roundedPassedTime = passedTime.round(toPlaces: 2)

            ConsoleManager.presentAllTaskFinished(totalTime: roundedPassedTime, numberOfCustomers: customers.count)
        })
    }

    private func generateRandomCustomers() -> [Customer] {
        let range = Constants.minimumValueOfRandomCustomers...Constants.maximumValueOfRandomCustomers
        let randomNumber = Int.random(in: range)

        var customers: [Customer] = []
        for id in 1...randomNumber {
            let workType = WorkType.allCases.randomElement() ?? .deposit
            customers.append(Customer(id: id, workType: workType))
        }

        return customers
    }
}
