//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by Mason Kim on 2023/02/23.
//

import Foundation

final class Bank {

    // MARK: - Private property

    private let presenter: BankPresenterable
    private let bankTellers: [BankTeller]
    private let bankWorkDispatchGroup = DispatchGroup()

    private let semaphoreByWorkType: [WorkType: DispatchSemaphore] = {
        WorkType.allCases.reduce(into: [WorkType: DispatchSemaphore]()) { dictionary, workType in
            dictionary[workType] = DispatchSemaphore(value: 1)
        }
    }()

    private let customerQueueByWorkType: [WorkType: Queue<Customer>] = {
        WorkType.allCases.reduce(into: [WorkType: Queue<Customer>]()) { dictionary, workType in
            dictionary[workType] = Queue()
        }
    }()


    // MARK: - Lifecycle

    init(
        bankTellers: [BankTeller],
        presenter: BankPresenterable
    ) {
        self.bankTellers = bankTellers
        self.presenter = presenter
    }

    // MARK: - Public

    func visit(customers: [Customer]) {
        customers.forEach { customer in
            customerQueueByWorkType[customer.workType]?.enqueue(customer)
        }
    }

    func startWorking() {
        bankTellers.forEach { bankTeller in
            DispatchQueue.global().async(group: bankWorkDispatchGroup) {
                self.assignTask(to: bankTeller)
            }
        }
        setNotifyAllTaskFinished(completion: {
            self.presenter.presentAllTaskFinished()
        })
    }

    func stopWorking() {
        
    }

    // MARK: - Private

    private func assignTask(to bankTeller: BankTeller) {
        let queue = self.customerQueueByWorkType[bankTeller.workType]
        while let customer = queue?.dequeue() {
            bankTeller.performTask(
                of: customer,
                presenter: self.presenter,
                group: self.bankWorkDispatchGroup
            )
        }
    }

    private func setNotifyAllTaskFinished(completion: @escaping () -> Void) {
        bankWorkDispatchGroup.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
}
