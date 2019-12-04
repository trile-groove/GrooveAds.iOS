import UIKit
import Kingfisher
import SnapKit

public class AppVertBannerView: AppVertAdsView {
    public var adSize: AdSize = .banner

    public func loadAd(event: String) {
        adsManager.loadAd(event: event, adSize: adSize)
    }
    
    private lazy var adsManager: AppVertAdsManager = {
        let adsManager = AppVertAdsManager()
        adsManager.didReceiveAdsInternal = { [weak self] (campaign, event) in
            self?.showAds(with: campaign)
        }
        return adsManager
    }()
    
    public weak var delegate: AppVertAdsManagerDelegate? {
        didSet {
            adsManager.delegate = delegate
        }
    }
}
