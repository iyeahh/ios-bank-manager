//
//  BankTeller.swift
//  BankManagerConsoleApp
//
//  Created by Bora Yang on 2023/02/23.
//

import Foundation

class BankTeller {
    var tellerWorkQueue = DispatchQueue(label: "myWork")

    enum WorkingStatus {
        case working
        case done
    }

    var myWorkType: BankTaskType
    var currentStatus: WorkingStatus = .done


    init(myWorkType: BankTaskType = .deposit) {
        self.myWorkType = myWorkType
    }

    func performTask(of customer: Customer, completion: @escaping () -> Void) {
        self.currentStatus = .working
        tellerWorkQueue.async { [weak self] in
            guard let self = self else {
                completion()
                return
            }
            ConsoleManager.presentTaskStarted(of: customer)
            Thread.sleep(forTimeInterval: self.myWorkType.timeSpent)
            ConsoleManager.presentTaskFinished(of: customer)
            self.currentStatus = .done
            completion()
        }
    }
}
