import UIKit

extension UIWindow {
    internal func topMostViewController() -> UIViewController? {
        return rootViewController?.topMostViewController()
    }
}

extension UIViewController {
    internal func topMostViewController() -> UIViewController? {
        if let navigation = self as? UINavigationController,
            let lastController = navigation.viewControllers.last {
                return lastController.topMostViewController()
        }
        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        if self.presentedViewController == nil {
            return self
        }
        return self.presentedViewController?.topMostViewController()
    }
}
