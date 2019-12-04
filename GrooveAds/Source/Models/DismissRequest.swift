import Foundation

struct DismissRequest: Codable {
    let appKey: String
    let deviceId: String
    let campaignId: Int
    let event: String
    let dismissalEvent: Int
    let displayDuration: Int
    let ipAddress: String
}

public enum DismissalEvent: Int {
    case closeAd = 1
    case clickAd = 2
}
