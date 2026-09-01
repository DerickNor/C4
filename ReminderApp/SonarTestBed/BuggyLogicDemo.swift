import Foundation

// SonarCloud Reliability (Bug) rule test bed. Not wired into the app. See branch
// test/sonarcloud-bug. Split out from the Maintainability and Security test beds
// so each SonarCloud issue category has its own branch/PR.
// Targets the 8 Bug-type rules active in the "Sonar way" Swift profile:
// S1862, S1764, S2201, S1763, S3083, S3110, S3981, S3923.

enum BuggyLogicDemo {
    // S1862: repeats the same condition in an if/else-if chain - the second branch
    // can never run.
    static func classify(_ value: Int) -> String {
        if value == 1 {
            "one"
        } else if value == 1 {
            "one again"
        } else {
            "other"
        }
    }

    // S1764: identical expression on both sides of a binary operator - always
    // true/zero regardless of the runtime value.
    static func isSame(_ a: Int) -> Bool {
        a == a
    }

    static func difference(_ x: Int) -> Int {
        x - x
    }

    // S2201: calling a non-mutating function and discarding its result - looks
    // like it sorts in place, but `numbers` is never touched.
    static func sortIgnored(_ numbers: [Int]) {
        numbers.sorted()
    }

    // S1763: statement placed after an unconditional return can never execute.
    static func unreachableAfterReturn() -> Int {
        return 1
        print("this line never runs")
    }

    // S3981: a count from a Swift Array is never negative, so this comparison
    // is always true and the condition is dead logic.
    static func hasItems(_ items: [Int]) -> Bool {
        items.count >= 0
    }

    // S3923: both branches produce the exact same result, so the condition is
    // pointless.
    static func labelFor(_ flagged: Bool) -> String {
        if flagged {
            "same-label"
        } else {
            "same-label"
        }
    }
}
