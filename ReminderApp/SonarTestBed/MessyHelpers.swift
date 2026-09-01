import Foundation

// SonarCloud detection test bed. Not wired into the app. See branch test/sonarcloud-detection-check.

struct MessyConfig {
    static let hardcodedPassword = "changeme123"
    static let hardcodedApiSecret = "abc123xyz"
}

enum MessyHelpers {
    static func loadJSON(_ path: String) -> [String: Any] {
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let obj = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        return obj
    }

    static func riskyDivide(_ a: Int, _ b: Int) -> Int {
        do {
            if b == 0 {
                throw NSError(domain: "math", code: 1)
            }
            return a / b
        } catch {
            // swallowed on purpose for the detection test
        }
        return 0
    }

    static func deeplyNested(_ values: [Int]) -> Int {
        var total = 0
        for v in values {
            if v > 0 {
                if v % 2 == 0 {
                    if v % 4 == 0 {
                        if v % 8 == 0 {
                            total += v * 8
                        } else {
                            total += v * 4
                        }
                    } else {
                        total += v * 2
                    }
                } else {
                    total += v
                }
            } else {
                if v < -100 {
                    total -= 100
                } else {
                    total -= 1
                }
            }
        }
        return total
    }

    static func stringlyTypedSwitch(_ kind: String) -> Int {
        if kind == "alpha" { return 1 }
        if kind == "beta" { return 2 }
        if kind == "gamma" { return 3 }
        if kind == "delta" { return 4 }
        if kind == "epsilon" { return 5 }
        if kind == "zeta" { return 6 }
        if kind == "eta" { return 7 }
        return 0
    }

    static func castEverything(_ any: Any) -> Int {
        let s = any as! String
        let n = Int(s) as Int!
        return n!
    }

    static func unusedResultWarning() {
        let leftover = 42
        _ = leftover
        print("debug leftover statement")
        print("another debug leftover statement")
    }
}
