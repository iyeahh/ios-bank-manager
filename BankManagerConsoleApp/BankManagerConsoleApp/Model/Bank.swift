//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by Mason Kim on 2023/02/23.
//

import Foundation

class Bank {
    private var bankTellers: [BankTeller]
    private var depositCustomersQueue: Queue<Customer> = Queue()
    private var loanCustomersQueue: Queue<Customer> = Queue()

    var isFinished: Bool {
        depositCustomersQueue.count == 0 &&
        loanCustomersQueue.count == 0 &&
        bankTellers.filter {
            $0.currentStatus == .working
        }.count == 0
    }

    //var allSpentTime: Date?

    init(bankTellers: [BankTeller]) {
        self.bankTellers = bankTellers
    }

    func visit(customers: [Customer]) {
        customers.forEach {
            $0.workType == .deposit ?
            depositCustomersQueue.enqueue($0) : loanCustomersQueue.enqueue($0)
        }
    }

    func startWorking() {
        while depositCustomersQueue.count > 0 || loanCustomersQueue.count > 0 {
            bankTellers.forEach { teller in
                if teller.myWorkType == .deposit && teller.currentStatus == .done {
                    guard let depositCustomer = depositCustomersQueue.peek else { return }
                    self.depositCustomersQueue.dequeue()
                    teller.performTask(of: depositCustomer) {
                        
                    }
                } else if teller.myWorkType == .loan && teller.currentStatus == .done {
                    guard let loanCustomer = loanCustomersQueue.peek else { return }
                    self.loanCustomersQueue.dequeue()
                    teller.performTask(of: loanCustomer) {

                    }
                }
            }
        }
    }


}

