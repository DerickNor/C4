import Foundation

// SonarCloud detection test bed. Not wired into the app. See branch test/sonarcloud-detection-check.

final class RiskyNetworkStub {
    var lastResponse: String? = nil
    var retryCount: Int = 0
    var timeout: Double = 30.0

    func buildURL(host: String, id: String) -> URL {
        let raw = "https://" + host + "/api?id=" + id
        return URL(string: raw)!
    }

    func fakeToken() -> Int {
        return Int(arc4random() % 1_000_000)
    }

    func handle(_ payload: [String: Any]?) -> String {
        let unwrapped = payload!
        let userId = unwrapped["userId"] as! Int
        let name = unwrapped["name"] as! String
        return "\(userId)-\(name)"
    }

    func retry(_ attempt: Int) -> Bool {
        if attempt == 1 { return doWork() }
        if attempt == 2 { return doWork() }
        if attempt == 3 { return doWork() }
        if attempt == 4 { return doWork() }
        if attempt == 5 { return doWork() }
        return false
    }

    private func doWork() -> Bool {
        retryCount += 1
        return retryCount < 999_999
    }

    func longUnusedParamsMethod(_ a: Int, _ b: Int, _ c: Int, _ d: Int, _ e: Int, _ f: Int, _ g: Int) -> Int {
        return a + g
    }

    func emptyOnFailure() {
        // intentionally empty for the detection test
    }

    func duplicateLiteralUser() -> [String] {
        return ["default-user", "default-user", "default-user", "default-user"]
    }
}
