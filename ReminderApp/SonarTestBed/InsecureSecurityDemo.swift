import CryptoKit
import Foundation
import SQLite3

// SonarCloud Security-rule test bed. Not wired into the app. See branch test/sonarcloud-detection-check.
// Deliberately insecure patterns to probe how many Security rules "Sonar way" actually catches
// on the Free plan, on top of the Maintainability findings already gathered in this test bed.

enum InsecureCrypto {
    static let dbPassword = "admin123"
    static let apiToken = "abc123xyz"
    /// Longer/higher-entropy value, to test whether S2068/S6418 need a length or
    /// entropy threshold to fire (the two short values above did not trigger them).
    /// Deliberately not shaped like any known provider's key format (e.g. Stripe's
    /// "sk_live_" prefix) after GitHub's own push protection blocked that version
    /// server-side as a real Stripe secret pattern - a third, independent layer of
    /// defense beyond gitleaks and SonarCloud.
    static let longFakeApiKey = "q7mZpX2vLk9tRb4wNc8sYh3fDj6uAe1gQoI5xVn" // gitleaks:allow

    static func weakHash(_ input: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(input.utf8))
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    static func predictableToken() -> Int {
        srand(42)
        return Int(rand())
    }

    static func loginDebugLog(username: String, password: String) {
        print("login attempt user=\(username) pass=\(password)")
    }
}

final class TrustAllCertificates: NSObject, URLSessionDelegate {
    func urlSession(
        _: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void,
    ) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}

/// Alternate, more "textbook" variant of the same vulnerability: explicitly checks for
/// the server-trust auth method (the canonical pattern shown in most write-ups of this
/// bug) before unconditionally trusting it, instead of trusting on every challenge type.
final class TrustAllCertificatesCanonical: NSObject, URLSessionDelegate {
    func urlSession(
        _: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void,
    ) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
            return
        }
        completionHandler(.performDefaultHandling, nil)
    }
}

enum InsecureDataAccess {
    static func lookupUser(name: String) -> String {
        let query = "SELECT * FROM users WHERE name = '" + name + "'"
        var db: OpaquePointer?
        sqlite3_open(":memory:", &db)
        var statement: OpaquePointer?
        sqlite3_prepare_v2(db, query, -1, &statement, nil)
        sqlite3_step(statement)
        sqlite3_finalize(statement)
        sqlite3_close(db)
        return query
    }

    static func runDiagnostics(userInput: String) {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "echo " + userInput]
        try? task.run()
    }
}

enum ComplexityDemo {
    static func classify(
        type: String,
        level: Int,
        active: Bool,
        score: Int,
        region: String,
        tier: Int,
        flagged: Bool,
    ) -> String {
        var result = ""
        if type == "a" {
            if level > 5 {
                if active {
                    if score > 100 {
                        if region == "us" {
                            if tier > 2 {
                                if flagged {
                                    result = "a-high-us-tier-flagged"
                                } else {
                                    result = "a-high-us-tier"
                                }
                            } else {
                                result = "a-high-us"
                            }
                        } else if region == "eu" {
                            if tier > 2 {
                                result = "a-high-eu-tier"
                            } else {
                                result = "a-high-eu"
                            }
                        } else {
                            result = "a-high-other"
                        }
                    } else if score > 50 {
                        result = "a-mid"
                    } else {
                        result = "a-low"
                    }
                } else {
                    result = "a-inactive"
                }
            } else if level > 2 {
                result = "a-low-level"
            } else {
                result = "a-min-level"
            }
        } else if type == "b" {
            if level > 5 {
                result = "b-high"
            } else if level > 2 {
                result = "b-mid"
            } else {
                result = "b-low"
            }
        } else if type == "c" {
            for i in 0 ..< level {
                if i % 2 == 0 {
                    if i % 4 == 0 {
                        result += "x"
                    } else {
                        result += "y"
                    }
                } else {
                    result += "z"
                }
            }
        } else {
            result = "unknown"
        }
        return result
    }
}
