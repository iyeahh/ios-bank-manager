//
//  BankTaskType.swift
//  BankManagerConsoleApp
//
//  Created by Bora Yang on 2023/03/04.
//

import Foundation

enum BankTaskType: CaseIterable {
    case deposit
    case loan

    var timeSpent: Double {
        switch self {
        case .deposit:
            return 0.7
        case .loan:
            return 1.1
        }
    }
}
