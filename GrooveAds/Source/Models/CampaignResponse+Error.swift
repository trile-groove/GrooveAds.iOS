import Foundation

extension CampaignResponse {
    func getError() -> AppVertError {
        if value?.isInvalidAppKey == true {
            return .isInvalidAppKey
        }
        if value?.hasNoCampaign == true {
            return .hasNoCampaign
        }
        if value?.isApplicationInactive == true {
            return .isApplicationInactive
        }
        return .unknown("Can not get any responses")
    }
}
