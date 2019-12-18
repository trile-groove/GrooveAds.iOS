import Foundation
import Alamofire
import Kingfisher

public enum AppVertEvent: String {
    case appStart = "app_start"
}

enum AppVertKeys: String {
    case frequencyOpen = "app_frequency_open"
    case countOpen = "app_count_open"
}

public enum AppVertError: Error {
    case isApplicationInactive
    case isInvalidAppKey
    case hasNoCampaign
    case unknown(String)
    
    public var errorDescription: String {
        switch self {
        case .isApplicationInactive:
            return "Application Inactive"
        case .isInvalidAppKey:
            return "Invalid App Key"
        case .hasNoCampaign:
            return "Application Has No Campaign"
        case .unknown(let message):
            return message
        }
    }
    
    internal static func fromNetworkError(_ error: Error) -> AppVertError {
        var message = "Can't get any responses"
        if let error = error as? AFError, let errorDescription = error.errorDescription {
            message = errorDescription
        }
        
        return AppVertError.unknown(message)
    }
}

public class AppVert {
    
    public var appKey = ""
    public var endPoint = "https://api.appvert.io/api/v1" {
        didSet {
            Network.shared.cancelAllRequests()
        }
    }
    public static let shared = AppVert()
    public var closeIcon: UIImage?
    public var backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)

    private var normalWindow: UIWindow = UIWindow()
    private lazy var adViewController: AppVertViewController = {AppVertViewController()}()
    private var popupWindow: UIWindow?
    
    func makeSelfKeyWindow() {
        popupWindow = rightWindow()
        popupWindow?.frame = UIScreen.main.bounds
        popupWindow?.windowLevel = UIWindow.Level.statusBar + 1
        popupWindow?.rootViewController = adViewController
        popupWindow?.makeKeyAndVisible()
    }
    
    func rightWindow() -> UIWindow {
        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
        if let windowScene = windowScene as? UIWindowScene {
            return UIWindow(windowScene: windowScene)
        }
        return UIWindow()
    }

    private init() {
    }
    
    public func dismiss(event: AppVertEvent, dismissalEvent: DismissalEvent) {
       dismiss(event: event.rawValue, dismissalEvent: dismissalEvent)
    }
    
    internal func dismiss(event: String?, dismissalEvent: DismissalEvent) {
        hideAd()
        
        guard let event = event else {return}
        guard let adInfo = UserDefaults.getAddInfo(for: event) else {
            return
        }
        print("adInfo \(adInfo)")
        
        let request = DismissRequest(
            appKey: appKey,
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "N/A",
            campaignId: adInfo.campaignId,
            event: event,
            dismissalEvent: dismissalEvent.rawValue,
            displayDuration: Int(Date().timeIntervalSince(adInfo.startTime)),
            ipAddress: Helper.getIPAddress())
        
        // Clear AdInfo
        UserDefaults.setAddInfo(nil, for: event)
        
        print("request \(request)")
        
        Network.shared.dismiss(request) { (result) in
            print("Dismiss request \(request), result \(request)")
        }
    }
    
    public func displayAd(for event: AppVertEvent, rootViewController: UIViewController?) {
        displayAd(for: event.rawValue, rootViewController: rootViewController)
    }
    
    public func displayAd(for event: String, rootViewController: UIViewController?) {
        
        let request = CampaignRequest(
            appKey: AppVert.shared.appKey,
            event: event,
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "N/A",
            ipAddress: Helper.getIPAddress(),
            width: nil,
            height: nil)
        
        print("request \(request)")
        var rootViewControllerID: String?
        if let rootViewController = rootViewController {
            rootViewControllerID = String(describing: rootViewController)
        }
        
        Network.shared.fetchCampaign(request) { [weak self] (response) in
            switch response {
            case .success(let campaign):
                print(campaign)
                self?.downloadAd(for: event, campaign: campaign, rootViewControllerID: rootViewControllerID)
            case .error(_):
                break
            }
        }
    }

    private func downloadAd(for event: AppVertEvent, campaign: Campaign, rootViewControllerID: String?) {
        downloadAd(for: event.rawValue, campaign: campaign, rootViewControllerID: rootViewControllerID)
    }
    
    private func downloadAd(for event: String, campaign: Campaign, rootViewControllerID: String?) {
        if let source = campaign.content?.source,
            let url = URL(string: source) {
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { [weak self] (_, _, _, _) in
                self?.showAd(for: event, campaign: campaign, rootViewControllerID: rootViewControllerID)
            }
        }
    }
    
    private func showAd(for event: String, campaign: Campaign, rootViewControllerID: String?) {

        let delay = Double(campaign.delay ?? 0)
        
        let popupView = self.adViewController.view;
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let `self` = self else {return}
            
            let appShowingFrequency = UserDefaults.getAdsShowingFrequency()
            var appShowingCount = UserDefaults.getAdsCountOpen()
            
            appShowingCount += 1
            
            if appShowingFrequency != 1 && appShowingCount < appShowingFrequency {
                UserDefaults.setAdsCountOpen(count: appShowingCount)
                return
            }
            
            appShowingCount = 0
            UserDefaults.setAdsCountOpen(count: appShowingCount)
            
            let adInfo = AdInfo(campaignId: campaign.id, startTime: Date())
            UserDefaults.setAddInfo(adInfo, for: event)
            
            self.adViewController.setCampaign(campaign, for: event)
            popupView?.alpha = 0
            
            UIView.animate(withDuration: 0.25, animations: {
                popupView?.alpha = 1
            }, completion: { _ in
                if let self_ = self as? UIViewController {
                    self.adViewController.didMove(toParent: self_)
                }
            })
        }
    }
    
    private func hideAd() {
        self.adViewController.view.alpha = 0
        popupWindow?.rootViewController = nil
        popupWindow = nil
        normalWindow.makeKeyAndVisible()
    }
    
    public func setShowingFrequency(numberOfFrequency: Int) {
        UserDefaults.setAdsCountOpen(count: 0)
        UserDefaults.setAdsShowingFrequency(numOfTime: numberOfFrequency <= 0 ? 1 : numberOfFrequency)
    }
}
