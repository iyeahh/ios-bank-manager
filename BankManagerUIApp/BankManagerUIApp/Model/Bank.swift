//
//  Bank.swift
//  BankManagerUIApp
//
//  Created by Mason Kim on 2023/03/09.
//

import Foundation

final class Bank {

    // MARK: - Private property

    private weak var presenter: BankPresentable?
    private let bankTellers: [BankTeller]
    private let bankWorkDispatchGroup = DispatchGroup()

    private let semaphoreByWorkType: [WorkType: DispatchSemaphore] = {
        WorkType.allCases.reduce(into: [WorkType: DispatchSemaphore]()) { dictionary, workType in
            dictionary[workType] = DispatchSemaphore(value: 1)
        }
    }()

    private var customerQueueByWorkType: [WorkType: Queue<Customer>] = {
        WorkType.allCases.reduce(into: [WorkType: Queue<Customer>]()) { dictionary, workType in
            dictionary[workType] = Queue()
        }
    }()

    // MARK: - Lifecycle

    init(
        bankTellers: [BankTeller],
        presenter: BankPresentable
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
            guard bankTeller.status == .finished else { return }

            DispatchQueue.global().async(group: bankWorkDispatchGroup) { [weak self] in
                self?.assignTask(to: bankTeller)
            }
        }

        setNotifyAllTaskFinished(completion: { [weak self] in
            self?.presenter?.presentAllTaskFinished()
        })
    }

    func stopWorking() {
        WorkType.allCases.forEach { workType in
            customerQueueByWorkType[workType]?.clear()
        }
    }

    // MARK: - Private

    private func assignTask(to bankTeller: BankTeller) {
        guard var queue = customerQueueByWorkType[bankTeller.workType],
              let semaphoreOfWorkType = semaphoreByWorkType[bankTeller.workType] else { return }

        while !queue.isEmpty {
            semaphoreOfWorkType.wait()
            guard let customer = queue.dequeue() else { return }
            semaphoreOfWorkType.signal()

            bankTeller.performTask(
                of: customer,
                presenter: presenter
            )
        }
    }

    private func setNotifyAllTaskFinished(completion: @escaping () -> Void) {
        bankWorkDispatchGroup.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
}
