import UIKit

public class AppVertItemView: AppVertAdsView {

    public func showAds(of ad: AppVertAd) {
        if let campaign = ad.campaign {
            showAds(with: campaign)
        }
    }
}
