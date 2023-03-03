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
    private var bankTellerAssignIndexCount: [WorkType: Int] = [:]

    private var semaphoreByWorkType: [WorkType: DispatchSemaphore] = [:]
    private let bankDispatchGroup = DispatchGroup()

    // MARK: - Lifecycle

    init(bankTellers: [WorkType: [BankTeller]]) {
        self.bankTellers = bankTellers

        configureSemaphoreByWorkType()
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
            assignTask(of: customer)
            customersQueue.dequeue()
        }

        notifyAllTaskFinished(completion: completion)
    }

    private func notifyAllTaskFinished(completion: @escaping () -> Void) {
        bankDispatchGroup.notify(queue: DispatchQueue.main) {
            completion()
        }
    }

    private func assignTask(of customer: Customer) {
        let workType = customer.workType
        let semaphore = semaphoreByWorkType[workType]

        let bankTeller = bankTellerToAssignTask(of: workType)
        addBankTellerAssignIndexCount(of: workType)

        DispatchQueue.global().async(group: bankDispatchGroup) {
            semaphore?.wait()
            bankTeller?.performTask(of: customer)
            semaphore?.signal()
        }
    }

    // MARK: - Helpers
    private func configureSemaphoreByWorkType() {
        semaphoreByWorkType = bankTellers.mapValues({ bankTellers in
            DispatchSemaphore(value: bankTellers.count)
        })
    }

    private func bankTellerToAssignTask(of type: WorkType) -> BankTeller? {
        let numberOfBankTeller = numberOfBankTeller(of: type)
        let index = (bankTellerAssignIndexCount[type] ?? 0) % numberOfBankTeller
        return bankTellers[type]?[index]
    }

    private func addBankTellerAssignIndexCount(of type: WorkType) {
        bankTellerAssignIndexCount[type] = (bankTellerAssignIndexCount[type] ?? 0) + 1
    }

    private func numberOfBankTeller(of type: WorkType) -> Int {
        return bankTellers[type]?.count ?? 0
    }
}
