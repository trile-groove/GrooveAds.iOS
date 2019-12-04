import Foundation

public protocol AppVertAdsManagerDelegate: class {
    func appVert(didReceive ads: AppVertAd, for event: String)
    func appVert(didFail error: AppVertError)
}

public class AppVertAdsManager {
    
    private var ads = [AppVertAdsView]()
    internal var didReceiveAdsInternal: ((Campaign, String) -> Void)?
    public weak var delegate: AppVertAdsManagerDelegate?

    public init() {
    }
    
    public func loadAd(event: String, adSize: AdSize) {
        let size = adSize.getSize()
        let request = CampaignRequest(
            appKey: AppVert.shared.appKey,
            event: event,
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "N/A",
            ipAddress: Helper.getIPAddress(),
            width: size.width,
            height: size.height)
        
        print("request \(request)")
        
        Network.shared.fetchCampaign(request) { [weak self] (response) in
            switch response {
            case .success(let campaign):
                print(campaign)
                self?.handleReceiveAd(campaign: campaign, event: event)

            case .error(let error):
                self?.delegate?.appVert(didFail: error)
                break
            }
        }
    }
    
    private func handleReceiveAd(campaign: Campaign, event: String) {
        let ad = AppVertAd(campaign: campaign)
        let delay = Double(campaign.delay ?? 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.didReceiveAdsInternal?(campaign, event)
            self?.delegate?.appVert(didReceive: ad, for: event)
        }
    }
}
