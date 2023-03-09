//
//  BankTeller.swift
//  BankManagerConsoleApp
//
//  Created by Bora Yang on 2023/02/23.
//

import Foundation

struct BankTeller {

    // MARK: - Properties

    let id: Int
    let workType: WorkType
    let serialQueue = DispatchQueue(label: "bankTellerQueue")

    // MARK: - Public

    func performTask(
        of customer: Customer,
        presenter: BankPresenterable,
        group: DispatchGroup
    ) {
        serialQueue.async(group: group) {
            presenter.presentTaskStarted(of: customer)
            Thread.sleep(forTimeInterval: customer.timespent)
            presenter.presentTaskFinished(of: customer)
        }
    }
}
