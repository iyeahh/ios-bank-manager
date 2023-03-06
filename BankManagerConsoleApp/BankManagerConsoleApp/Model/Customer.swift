//
//  Customer.swift
//  BankManagerConsoleApp
//
//  Created by Mason Kim on 2023/02/23.
//

import Foundation

struct Customer {
    private(set) var id: Int
//    private(set) var timespent: TimeInterval
    var workType: BankTaskType

    init(id: Int, workType: BankTaskType) {
        self.id = id
        self.workType = workType

//        guard timespent >= 0 else {
//            self.timespent = 0
//            return
//        }
//        self.timespent = timespent
    }
}
