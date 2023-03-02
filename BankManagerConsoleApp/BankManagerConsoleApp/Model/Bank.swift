//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by Mason Kim on 2023/02/23.
//

import Foundation

final class Bank {

    // MARK: - Private property

    private var customersQueue: Queue<Customer> = Queue()
    private let bankTellers: [WorkType: [BankTeller]]

    private var semaphoreByWorkType: [WorkType: DispatchSemaphore] = [:]
    private var dispatchQueueByWorkType: [WorkType: DispatchQueue] = [:]
    private let bankDispatchGroup = DispatchGroup()

    // MARK: - Lifecycle

    init(bankTellers: [WorkType: [BankTeller]]) {
        self.bankTellers = bankTellers

        configureSemaphoreByWorkType()
        configureDispatchQueueByWorkType()
    }

    // MARK: - Actions

    func visit(customers: [Customer]) {
        customers.forEach {
            customersQueue.enqueue($0)
        }
    }

    func startWorking(completion: @escaping () -> Void) {
        for _ in 0..<customersQueue.count {
            guard let customer = customersQueue.peek else { continue }
            let type = customer.workType

            switch type {
            case .loan:
                work(customer, of: .loan)
            case .deposit:
                work(customer, of: .deposit)
            }
            customersQueue.dequeue()
        }

        notifyAllTaskFinished(completion: completion)
    }

    private func notifyAllTaskFinished(completion: @escaping () -> Void) {
        let queueForGroup = DispatchQueue(label: "업무 종료", attributes: .concurrent)

        bankDispatchGroup.notify(queue: queueForGroup) {
            completion()
        }
    }

    private func work(_ customer: Customer, of type: WorkType) {
        let queue = dispatchQueueByWorkType[type]
        let semaphore = semaphoreByWorkType[type]
        var bankTeller = self.bankTellers[type]?.first { !$0.isWorking }

        queue?.async(group: bankDispatchGroup) {
            semaphore?.wait()
            bankTeller?.performTask(of: customer)
            semaphore?.signal()
        }
    }

    // MARK: - Helpers
    func configureSemaphoreByWorkType() {
        semaphoreByWorkType = bankTellers.mapValues({ bankTellers in
            DispatchSemaphore(value: bankTellers.count)
        })
    }

    func configureDispatchQueueByWorkType() {
        bankTellers.forEach { (workType, bankTellers) in
            dispatchQueueByWorkType[workType] = DispatchQueue(
                label: workType.rawValue,
                attributes: .concurrent
            )
        }
    }
}
