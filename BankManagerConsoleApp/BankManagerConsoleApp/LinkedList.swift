//
//  LinkedList.swift
//  BankManagerConsoleApp
//
//  Created by Mason Kim on 2023/02/22.
//

import Foundation

final class Node<Value> {
    var value: Value
    var next: Node?

    init(_ value: Value) {
        self.value = value
    }
}

final class LinkedList<Value> {
    private var head: Node<Value>?
    private var tail: Node<Value>?

    var isEmpty: Bool {
        return head == nil
    }

    var peek: Value? {
        return head?.value
    }

    func append(_ value: Value) {
        guard !isEmpty else {
            head = Node(value)
            tail = head
            return
        }

        tail?.next = Node(value)
        tail = tail?.next
    }

    func removeFirst() -> Value? {
        let headValue = head?.value
        head = head?.next
        
        if isEmpty {
            tail = nil
        }

        return headValue
    }
}
