//
//  LinkedListTests.swift
//  Algorithms
//
//  Created by Hugo Tunius on 03/07/16.
//  Copyright © 2016 Hugo Tunius. All rights reserved.
//

import XCTest
@testable import Algorithms

class LinkedListTests: XCTestCase {
    private var list: LinkedList<Int>!
    override func setUp() {
        self.list = LinkedList<Int>()
    }

    func testIsEmptyAndCount() {
        XCTAssertEqual(list.count, 0)
        XCTAssertTrue(list.isEmpty)
        list.append(value: 10)
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.count, 1)
    }

    func testAppend() {
        list.append(value: 10)

        var node = list.nodeAt(index: 0)
        XCTAssertNotNil(node)
        XCTAssertEqual(node?.value, 10)
        XCTAssertEqual(list.count, 1)

        list.append(value: 20)

        node = list.nodeAt(index: 1)
        XCTAssertNotNil(node)
        XCTAssertEqual(node?.value, 20)
        XCTAssertEqual(list.count, 2)
    }

    func testPrepend() {
        list.prepend(value: 10)

        var node = list.nodeAt(index: 0)
        XCTAssertNotNil(node)
        XCTAssertEqual(node?.value, 10)
        XCTAssertEqual(list.count, 1)

        list.prepend(value: 20)

        node = list.nodeAt(index: 0)
        XCTAssertNotNil(node)
        XCTAssertEqual(node?.value, 20)
        XCTAssertEqual(list.count, 2)
    }

    func testRemoveNode() {
        list.append(value: 10)
        list.append(value: 20)
        list.append(value: 30)

        let node = list.nodeAt(index: 1)
        XCTAssertNotNil(node)
        list.remove(node: node!)

        XCTAssertEqual(list.count, 2)

        let node10 = list.nodeAt(index: 0)
        XCTAssertNotNil(node10)
        let node30 = list.nodeAt(index: 1)
        XCTAssertNotNil(node30)

        XCTAssertEqual(node10?.value, 10)
        XCTAssertEqual(node30?.value, 30)
    }

    func testFind() {
        list.append(value: 10)
        list.append(value: 20)
        list.append(value: 30)
        list.append(value: 10)

        let found = list.find { node, index in
            node.value == 10
        }
        XCTAssertNotNil(found)
        XCTAssertEqual(found?.value, 10)
    }
}
