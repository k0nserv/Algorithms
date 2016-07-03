import XCTest
@testable import Algorithms

class StableMatchingTests: XCTestCase {
    typealias IntCandidate = Candidate<Int>

    func testEmptyCandidates() {
        let result: Set<Pair<IntCandidate>> = stableMatching(candidates: [], otherCandidates: [])

        XCTAssertTrue(result.isEmpty, "A matching between two empty candidate sets should be empty")
    }

    func testSimple() {
        let candidate = IntCandidate(data: 1)
        let otherCandidate = IntCandidate(data: 2, preferences: [candidate])
        candidate.preferences = [otherCandidate]

        let result = stableMatching(candidates: [candidate], otherCandidates: [otherCandidate])

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first, Pair(first: candidate, second: otherCandidate))
    }

    func testNoOtherCandidates() {
        let candidate = IntCandidate(data: 1)

        let result = stableMatching(candidates: [candidate], otherCandidates: [])

        XCTAssertTrue(result.isEmpty)
    }

    func testNoMatching() {
        let candidate = IntCandidate(data: 1)
        let otherCandidate = IntCandidate(data: 2)

        let result = stableMatching(candidates: [candidate], otherCandidates: [otherCandidate])

        XCTAssertTrue(result.isEmpty)
    }

    func testComplexer() {
        let a1 = IntCandidate(data: 1)
        let a2 = IntCandidate(data: 2)
        let b1 = IntCandidate(data: 3)
        let b2 = IntCandidate(data: 4)
        a1.preferences = [b1, b2]
        a2.preferences = [b2, b1]
        b1.preferences = [a2, a1]
        b2.preferences = [a1, a2]

        let result = stableMatching(candidates: [a1, a2], otherCandidates: [b1, b2])

        XCTAssertEqual(result.count, 2)
        let option1 = result.contains(Pair(first: a1, second: b1)) && result.contains(Pair(first: a2, second: b2))
        let option2 = result.contains(Pair(first: a2, second: b1)) && result.contains(Pair(first: a1, second: b2))
        XCTAssertTrue(option1 != option2)
    }
}
