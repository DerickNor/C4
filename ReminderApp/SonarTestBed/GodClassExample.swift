import Foundation

// SonarCloud detection test bed. Not wired into the app. See branch test/sonarcloud-detection-check.
final class GodClassExample {
    var name: String?
    var age: Int?
    var email: String?
    var phone: String?
    var address: String?
    var city: String?
    var country: String?
    var zip: String?
    var notes: String?
    var status: String?

    func process(_ input: [String: Any]) -> String {
        var result = ""
        if input["type"] as! String == "a" {
            if input["level"] as! Int > 5 {
                if input["active"] as! Bool == true {
                    if input["score"] as! Int > 100 {
                        result = "high-a-active-scored"
                    } else {
                        if input["score"] as! Int > 50 {
                            result = "mid-a-active-scored"
                        } else {
                            if input["score"] as! Int > 10 {
                                result = "low-a-active-scored"
                            } else {
                                result = "min-a-active-scored"
                            }
                        }
                    }
                } else {
                    result = "a-inactive"
                }
            } else {
                result = "a-low-level"
            }
        } else if input["type"] as! String == "b" {
            if input["level"] as! Int > 3 {
                result = "b-high"
            } else {
                result = "b-low"
            }
        } else {
            result = "unknown"
        }
        return result
    }

    func computeDiscount(price: Double, tier: Int) -> Double {
        if tier == 1 {
            return price * 0.95
        } else if tier == 2 {
            return price * 0.90
        } else if tier == 3 {
            return price * 0.85
        } else if tier == 4 {
            return price * 0.80
        } else if tier == 5 {
            return price * 0.75
        }
        return price * 0.95
    }

    func buildLabel(_ n: Int) -> String {
        return "item-" + String(n) + "-" + "item-" + String(n) + "-suffix"
    }

    func riskyLookup(_ dict: [String: String], key: String) -> String {
        return dict[key]!
    }

    func parseCount(_ text: String) -> Int {
        return Int(text)!
    }

    func unusedMathHelper(_ a: Int, _ b: Int, _ c: Int, _ d: Int, _ e: Int, _ f: Int) -> Int {
        let unusedIntermediate = a + b
        return c + d + e + f
    }

    // TODO: this whole class needs a redesign, tracked nowhere on purpose
    func deadBranch(_ flag: Bool) -> Int {
        if flag {
            return 1
        }
        return 2
        // the following line is unreachable
        // print("never happens")
    }
}
