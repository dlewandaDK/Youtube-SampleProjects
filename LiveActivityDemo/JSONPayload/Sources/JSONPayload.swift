// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation

func sendCurlCommand(headers: [String: String], body: String, url: String) async {
    guard let url = URL(string: url) else {
        print("Invalid URL: \(url)")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = body.data(using: .utf8)

    // Set headers
    for (key, value) in headers {
        request.setValue(value, forHTTPHeaderField: key)
    }

    do {
        // Use the async/await API for data task
        let (responseData, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("Response status code: \(httpResponse.statusCode)")
        }

        if let responseString = String(data: responseData, encoding: .utf8) {
            print("Response data: \(responseString)")
        }
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

@main
struct JSONPayload: AsyncParsableCommand {
    @Option(help: "Which step of the live activity cycle to generate as JSON")
    var step: Int?

    @Flag(help: "Prints date in a human-readable style")
    var debug: Bool = false

    @Flag(help: "Run all the steps in sequence with a 2 second pause between")
    var runAll: Bool = false

    private func run(step: Int) async throws {
        let jsonString = switch step {
            case 1: try beforeGame(debug: debug)
            case 2: try gameStart(debug: debug)
            case 3: try firstOut(debug: debug)
            case 4: try firstRun(debug: debug)
            case 5: try bottomThird(debug: debug)
            case 6: try homeRuns(debug: debug)
            case 7: try seventhInningStretch(debug: debug)
            case 8: try endEighth(debug: debug)
            case 9: try final(debug: debug)
            default:
                fatalError("No step '\(step)' defined")
        }
        
        if debug {
            print(jsonString)
        } else {
            guard let authToken = ProcessInfo.processInfo.environment["AUTHENTICATION_TOKEN"] else {
                fatalError("No auth token")
            }
            
            await sendCurlCommand(
                headers: [
                    "authorization": "bearer \(authToken)",
                    "apns-channel-id": "aMs2y8fFEe8AAPIAM4gHog==",
                    "apns-push-type": "liveactivity",
                    "apns-priority": "10",
                    "apns-expiration": "0"
                ],
                body: jsonString,
                url: "https://api.sandbox.push.apple.com:443/4/broadcasts/apps/com.diamondkinetics.fespinozacast.youtube-sample.LiveActivityDemo"
            )
        }
    }
    
    mutating func run() async throws {
        if runAll {
            for i in 1...9 {
                try await run(step: i)
                try await Task.sleep(for: .seconds(2))
            }
        } else {
            guard let step else {
                fatalError("No step provided")
            }
            try await run(step: step)
        }
    }
}
