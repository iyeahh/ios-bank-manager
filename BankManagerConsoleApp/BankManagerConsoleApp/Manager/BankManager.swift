//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

public struct BankManager {

    // MARK: - Private property

    private let bank: Bank
    private let presenter: BankPresenterable

    private enum Constants {
        static let minimumValueOfRandomCustomers: Int = 10
        static let maximumValueOfRandomCustomers: Int = 30
    }

    // MARK: - Lifecycle

    init(presenter: BankPresenterable) {
        let bankTellers = [
            BankTeller(id: 0, workType: .deposit, presenter: presenter),
            BankTeller(id: 1, workType: .deposit, presenter: presenter),
            BankTeller(id: 2, workType: .loan, presenter: presenter)
        ]
        self.bank = Bank(bankTellers: bankTellers)

        self.presenter = presenter
    }

    // MARK: - Public

    func open(completion: @escaping () -> Void) {
        let openedTime = DispatchTime.now()

        let customers = generateRandomCustomers()
        bank.visit(customers: customers)

        bank.startWorking(completion: {
            let closedTime = DispatchTime.now()
            let totalTime = calculateTotalWorkTime(openedTime: openedTime, closedTime: closedTime)

            presenter.presentAllTaskFinished(totalTime: totalTime, numberOfCustomers: customers.count)
            completion()
        })
    }

    // MARK: - Private

    private func generateRandomCustomers() -> [Customer] {
        let range = Constants.minimumValueOfRandomCustomers...Constants.maximumValueOfRandomCustomers
        let randomNumber = Int.random(in: range)

        return (1...randomNumber).map { id in
            let workType = WorkType.allCases.randomElement() ?? .deposit
            return Customer(id: id, workType: workType)
        }
    }

    private func calculateTotalWorkTime(openedTime: DispatchTime, closedTime: DispatchTime) -> TimeInterval {
        let nanoTime = closedTime.uptimeNanoseconds - openedTime.uptimeNanoseconds
        let passedTime = Double(nanoTime) / 1_000_000_000
        return passedTime.round(toPlaces: 2)
    }
}
