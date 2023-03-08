//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {

    private enum Constants {
        static let addCustomerButtonTitle = "고객 10명 추가"
        static let resetButtonTitle = "초기화"
        static let workTimeLabelFormText = "업무시간 - "
        static let waitingStateLabelText = "대기중"
        static let workingStateLabelText = "업무중"

    }

    // MARK: - UI Properties

    private let addCustomerButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.addCustomerButtonTitle, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.resetButtonTitle, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
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


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        view.backgroundColor = .white
    }

    // MARK: - Public


    // MARK: - Private

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

        let testLabel1 = UILabel()
        testLabel1.textColor = .black
        testLabel1.text = "5 - 예금"
        waitingStackView.addArrangedSubview(testLabel1)

        let testLabel2 = UILabel()
        testLabel2.textColor = .black
        testLabel2.text = "2 - 예금"
        workingStackView.addArrangedSubview(testLabel2)
    }
}

