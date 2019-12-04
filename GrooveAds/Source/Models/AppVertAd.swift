import Foundation

public struct AppVertAd {
    let campaign: Campaign?
    
    public init() {
        campaign = nil
    }
    
    init(campaign: Campaign) {
        self.campaign = campaign
    }
    
    public var adSize: CGSize {
        get {
            guard let campaign = campaign,
                let content = campaign.content else {
                    return CGSize.zero
            }
            return CGSize(width: content.width, height: content.height)
        }
    }
    
    public func height(from width: CGFloat) -> CGFloat {
        let size = adSize
        return width * size.height / size.width
    }
    
    public func width(from height: CGFloat) -> CGFloat {
        let size = adSize
        return height * size.width / size.height
    }
}
