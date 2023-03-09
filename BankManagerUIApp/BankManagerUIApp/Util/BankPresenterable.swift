//
//  BankPresenterable.swift
//  BankManagerUIApp
//
//  Created by Mason Kim on 2023/03/09.
//

import Foundation

protocol BankPresenterable: AnyObject {
    func presentUserMenu()
    func presentTaskStarted(of customer: Customer)
    func presentTaskFinished(of customer: Customer)
    func presentAllTaskFinished(totalTime: TimeInterval, numberOfCustomers: Int)
}
