import Foundation

struct Campaign: Codable {
    let id: Int
    let name: String?
    let description: String?
    let content: CampaignContent?
    let linkUrl: String?
    let status: Int?
    let statusName: String?
    let delay: Int?
}

struct CampaignContent: Codable {
    let id: Int
    let source: String?
    let type: Int?
    let typeName: String?
    let width: Int
    let height: Int
}

struct CampaignWrapper: Codable {
    let campaign: Campaign?
    let isApplicationInactive: Bool?
    let isInvalidAppKey: Bool?
    let hasNoCampaign: Bool?
}

struct CampaignResponse: Codable {
    let value: CampaignWrapper?
}

struct CampaignRequest: Codable {
    let appKey: String
    let event: String
    let deviceId: String
    let ipAddress: String
    let width: Int?
    let height: Int?
}
