import UIKit

public class AppVertAdsView: UIView {

    private let imageView = UIImageView()
    private var campaign: Campaign?
        
    @IBInspectable public var shouldCropImage: Bool = false {
        didSet {
            imageView.contentMode = shouldCropImage ? .scaleAspectFill : .scaleAspectFit
        }
    }

    public init() {
        super.init(frame: CGRect.zero)
        prepareViews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareViews()
    }
    
    private func prepareViews() {
        isHidden = true
        backgroundColor = UIColor.white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(adTriggered))
        imageView.addGestureRecognizer(tapGesture)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    @objc private func adTriggered() {
        if let urlString = campaign?.linkUrl,
            let url = URL(string: urlString) {
            UIApplication.shared.openURL(url)
        }
    }
    
    internal func showAds(with campaign: Campaign) {
        self.campaign = campaign
        showAds(with: campaign.content?.source ?? "")
    }
    
    internal func showAds(with source: String) {
        isHidden = false
        let sourceUrl = URL(string: source)
        imageView.kf.setImage(with: sourceUrl)
    }
}
