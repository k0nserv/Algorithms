import Foundation

class Candidate<T: Hashable> {
    let data: T
    var preferences: OrderedSet

    convenience init(data: T) {
        self.init(data: data, preferences: [])
    }

    init(data: T, preferences: OrderedSet) {
        self.data = data
        self.preferences = preferences
    }
}

extension Candidate: Hashable {
    var hashValue: Int {
        get {
            return data.hashValue
        }
    }
}

func ==<T: Equatable>(lhs: Candidate<T>, rhs: Candidate<T>) -> Bool {
    return lhs.data == rhs.data
}

struct Pair<T: Hashable> {
    let first: T
    let second: T
}

extension Pair: Hashable {
    var hashValue: Int {
        get {
            return first.hashValue ^ (second.hashValue >> sizeof(Int))
        }
    }
}

func ==<T: Hashable>(lhs: Pair<T>, rhs: Pair<T>) -> Bool {
    return (lhs.first == rhs.first && lhs.second == rhs.second)
}

func stableMatching<T: Hashable>(candidates: Set<Candidate<T>>,
                    otherCandidates: Set<Candidate<T>>) -> Set<Pair<Candidate<T>>> {
    typealias CandidateType = Candidate<T>

    var currentMatches: [CandidateType:Candidate<T>] = [:]
    var remainingPossibilitiesForCandidate: [Candidate<T>:NSMutableOrderedSet] = [:]
    candidates.forEach {
        remainingPossibilitiesForCandidate[$0] = NSMutableOrderedSet(orderedSet: $0.preferences)
    }
    var freeCandidates = LinkedList(candidates)

    while !freeCandidates.isEmpty {
        let candidate = freeCandidates.first!
        guard let potentialMatch = remainingPossibilitiesForCandidate[candidate.value]?.firstObject as? Candidate<T> else {
            freeCandidates.remove(node: candidate)
            continue
        }

        if let matchedCandidatesCurrentMatch = currentMatches[potentialMatch] {
            let indexOfCurrentCandidate = potentialMatch.preferences.index(of: candidate)
            let indexOfPreviousMatch = potentialMatch.preferences.index(
                of: matchedCandidatesCurrentMatch
            )

            if indexOfCurrentCandidate < indexOfPreviousMatch {
                currentMatches[potentialMatch] = candidate.value
                freeCandidates.append(value: matchedCandidatesCurrentMatch)
                freeCandidates.remove(node: candidate)
            }
        } else {
            currentMatches[potentialMatch] = candidate.value
            let set = remainingPossibilitiesForCandidate[candidate.value]!
            set.remove(candidate)
            remainingPossibilitiesForCandidate[candidate.value] = set
            freeCandidates.remove(node: candidate)
        }
    }

    return Set(currentMatches.map {
        Pair(first: $1, second: $0)
    })
}
