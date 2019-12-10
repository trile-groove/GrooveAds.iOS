import UIKit
import SnapKit
import Kingfisher

class AppVertViewController: RotationViewController {
    
    private let closeButton = UIButton()
    private let imageView = UIImageView()
    private var imageSize: CGSize?
    private var event: String?
    private var campaign: Campaign?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewOrientationDidChange() {
        super.viewOrientationDidChange()
        updateImageSize()
    }
    
    private func setup() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(closeButton)
        
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(adTriggered))
        imageView.addGestureRecognizer(tapGesture)
        
        let imageClose: UIImage?
        
        if let image = AppVert.shared.closeIcon {
            imageClose = image
        } else {
            imageClose = UIImage(named: "close", in: Bundle(for: AppVertViewController.self), compatibleWith: nil)
        }
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        closeButton.setImage(imageClose, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        imageView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalTo(200)
            maker.height.equalTo(200)
        }
        
        closeButton.snp.makeConstraints { maker in
            maker.trailing.equalTo(imageView)
            maker.bottom.equalTo(imageView.snp.top).offset(-5)
            maker.width.height.equalTo(30)
        }
        
        view.backgroundColor = AppVert.shared.backgroundColor
    }
    
    private func reset() {
        imageSize = nil
        imageView.image = nil
        campaign = nil
        event = nil
    }
    
    @objc private func close() {
        AppVert.shared.dismiss(event: event, dismissalEvent: .closeAd)
    }
    
    @objc private func adTriggered() {
        AppVert.shared.dismiss(event: event, dismissalEvent: .clickAd)
        if let urlString = campaign?.linkUrl,
            let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func setCampaign(_ campaign: Campaign, for event: AppVertEvent) {
        setCampaign(campaign, for: event.rawValue)
    }
    
    func setCampaign(_ campaign: Campaign, for event: String) {
        reset()
        self.event = event
        self.campaign = campaign
        
        if let source = campaign.content?.source,
            let url = URL(string: source) {
            imageView.kf.setImage(with: url) {(image, _, _, _) in
                if let image = image {
                    self.updateImageSize(image.size)
                }
            }
        }
    }
    
    private func updateImageSize(_ imgSize: CGSize) {
        imageSize = imgSize
        imageView.snp.remakeConstraints { maker in
            maker.center.equalToSuperview()
            
            let size = calculateImageViewSize(from: imgSize)
            maker.width.equalTo(size.width)
            maker.height.equalTo(size.height)
        }
    }
    
    private func updateImageSize() {
        if let size = imageSize {
            updateImageSize(size)
        }
    }
    
    private func calculateImageViewSize(from imgSize: CGSize) -> CGSize {
        let parentSize = self.view.frame.size
        
        let imgWidth = imgSize.width
        let imgHeight = imgSize.height
        let width: CGFloat
        let height: CGFloat
        
        if #available(iOS 11.0, *) {
            let safeInsets = view.safeAreaInsets
            width = parentSize.width - safeInsets.left - safeInsets.right
            height = parentSize.height - safeInsets.top - safeInsets.bottom
        } else {
            width = parentSize.width
            height = parentSize.height
        }
        
        let ratio = imgWidth/imgHeight
        let screenRatio = width/height
        
        let newWidth: CGFloat
        let newHeight: CGFloat
        
        if ratio < screenRatio { // image is high
            newHeight = height - 80
            newWidth = newHeight*ratio
        } else { // image is long
            newWidth = width - 40
            newHeight = newWidth/ratio
        }
        
        return CGSize(width: newWidth, height: newHeight)
    }
}
