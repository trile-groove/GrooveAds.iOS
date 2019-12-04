import UIKit

class RotationViewController: UIViewController {

    internal var isPortrait = true
    private var needUpdateLayout = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOrientation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateOrientation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateOrientation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if needUpdateLayout {
            viewOrientationDidChange()
        }
    }
    
    private func updateOrientation() {
        if UIDevice.current.orientation.isLandscape {
            isPortrait = false
        } else {
            isPortrait = true
        }
        needUpdateLayout = true
    }
    
    public func viewOrientationDidChange() {
        needUpdateLayout = false
    }
}
