import Foundation

final class Node<T> {
    private typealias NodeType = Node<T>

    let value: T
    private var previousNode: NodeType?
    private var nextNode: NodeType?

    init(value: T) {
        self.value = value
    }
}

struct LinkedList<T> {
    typealias NodeType = Node<T>

    private var startNode: NodeType? {
        didSet {
            if endNode == nil {
                endNode = startNode
            }
        }
    }
    private var endNode: NodeType? {
        didSet {
            if startNode == nil {
                startNode = endNode
            }
        }
    }

    private(set) var count: Int = 0

    var isEmpty: Bool {
        get {
            return count == 0
        }
    }

    var first: NodeType? {
        get {
            return startNode
        }
    }

    init() {

    }

    init<S: Sequence where S.Iterator.Element == T>(_ elements: S) {
        append(elements)
    }

    func nodeAt(index: Int) -> NodeType? {
        return iterate {
            if index == $1 {
                return $0
            }

            return nil
        }
    }

    mutating func append(value: T) {
        let previousEndNode = endNode
        endNode = Node(value: value)
        if previousEndNode != nil {
            endNode?.previousNode = previousEndNode
            previousEndNode?.nextNode = endNode
        }

        count += 1
    }

    mutating func prepend(value: T) {
        let previousStartNode = startNode
        startNode = Node(value: value)
        if previousStartNode != nil {
            startNode?.nextNode = previousStartNode
            previousStartNode?.previousNode = startNode
        }

        count += 1
    }

    mutating func remove(node: NodeType) {
        let nextNode = node.nextNode
        let previousNode = node.previousNode

        if node === startNode {
            startNode = node.nextNode
        } else if node === endNode {
            endNode = node.previousNode
        } else {
            previousNode?.nextNode = nextNode
        }

        count -= 1
    }

    private func iterate(block: @noescape  (node: NodeType, index: Int) throws -> NodeType?) rethrows -> NodeType? {
        var node = startNode
        var index = 0

        while node != nil {
            let result = try block(node: node!, index: index)
            if result != nil {
                return result
            }
            index += 1
            node = node?.nextNode
        }

        return nil
    }

    private mutating func append<S: Sequence where S.Iterator.Element == T>(_ elements: S) {
        for element in elements {
            append(value: element)
        }
    }
}

extension LinkedList {
    func find(where predicate: @noescape (node: Node<T>, index: Int) throws ->  Bool) rethrows -> Node<T>? {
        return try iterate {
            if try predicate(node: $0, index: $1) {
                return $0
            }

            return nil
        }
    }
}

