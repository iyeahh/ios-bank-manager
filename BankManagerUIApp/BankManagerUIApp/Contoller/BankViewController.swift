//
//  BankManagerUIApp - BankViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

final class BankViewController: UIViewController {

    // MARK: - Properties

    private lazy var bank: Bank = {
        let bankTellers = [
            BankTeller(id: 0, workType: .deposit),
            BankTeller(id: 1, workType: .deposit),
            BankTeller(id: 2, workType: .loan)
        ]
        return Bank(bankTellers: bankTellers, presenter: self)
    }()

//    private lazy var bankManager = BankManager(bank: bank, presenter: self)

    private var lastCustomerID: Int = 1
    private var isWorking = false

    private enum Constants {
        static let addCustomerButtonTitle: String = "고객 10명 추가"
        static let resetButtonTitle: String = "초기화"
        static let workTimeLabelFormText: String = "업무시간 - "
        static let waitingStateLabelText: String = "대기중"
        static let workingStateLabelText: String = "업무중"
    }

    // MARK: - UI Properties

    private lazy var addCustomerButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.addCustomerButtonTitle, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(addCustomers), for: .touchUpInside)
        return button
    }()

    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.resetButtonTitle, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(resetAllTasks), for: .touchUpInside)
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addCustomerButton, resetButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()

    private let workTimeLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.workTimeLabelFormText
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()

    private let waitingStateLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.waitingStateLabelText
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemGreen
        return label
    }()

    private let workingStateLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.workingStateLabelText
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemIndigo
        return label
    }()

    private lazy var stateLabelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [waitingStateLabel, workingStateLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()

    private let waitingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()

    private let workingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()

    private var customerLabels: [CustomerStatusLabel] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        view.backgroundColor = .white
    }


    // MARK: - Actions

    @objc private func addCustomers() {
        let customers = generateVisitCustomers()

        bank.visit(customers: customers)
        updateViews(addedCustomers: customers)

//        guard !isWorking else { return }
//        print("뱅크 일 시작")
        bank.startWorking()
    }

    @objc private func resetAllTasks() {
        customerLabels = []
        lastCustomerID = 1

        workingStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        waitingStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }

        bank.stopWorking() // TODO: 리셋 로직 구현 필요
    }


    // MARK: - Private

    private func updateViews(addedCustomers: [Customer]) {
        addedCustomers
            .map { CustomerStatusLabel(customer: $0) }
            .forEach { customerLabel in
                waitingStackView.addArrangedSubview(customerLabel)
                customerLabels.append(customerLabel)
            }
    }

    private func generateVisitCustomers() -> [Customer] {
        let customers = (lastCustomerID...(lastCustomerID + 9))
            .map {
                let workType = WorkType.allCases.randomElement() ?? .deposit
                return Customer(id: $0, workType: workType)
            }

        lastCustomerID += 10

        return customers
    }
}

// MARK: - Layout

extension BankViewController {
    private func configureLayout() {
        let headerStackView = UIStackView(arrangedSubviews: [
            buttonStackView,
            workTimeLabel,
            stateLabelStackView
        ])
        headerStackView.axis = .vertical
        headerStackView.distribution = .fillEqually

        view.addSubview(headerStackView)
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStackView.heightAnchor.constraint(equalToConstant: 150),
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(waitingStackView)
        waitingStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            waitingStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 8),
            waitingStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            waitingStackView.widthAnchor.constraint(equalToConstant: view.frame.width / 2)
        ])

        view.addSubview(workingStackView)
        workingStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            workingStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 8),
            workingStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            workingStackView.widthAnchor.constraint(equalToConstant: view.frame.width / 2)
        ])
    }
}

// MARK: - BankPresenterable
extension BankViewController: BankPresenterable {
    func presentTaskStarted(of customer: Customer) {
        print("고객 업무 시작 \(customer.id) \(customer.workType.rawValue)")

        guard let customerLabel = customerLabels.first(where: {
            $0.customer.id == customer.id
        }) else { return }

        DispatchQueue.main.async { [weak self] in
            customerLabel.removeFromSuperview()
            self?.workingStackView.addArrangedSubview(customerLabel)
        }
    }

    func presentTaskFinished(of customer: Customer) {
        print("고객 업무 종료 \(customer.id) \(customer.workType.rawValue)")

        guard let customerLabel = customerLabels.first(where: {
            $0.customer.id == customer.id
        }) else { return }

        DispatchQueue.main.async {
            customerLabel.removeFromSuperview()
        }
    }

    func presentAllTaskFinished() {
        print("은행 업무 종료")
    }
}
