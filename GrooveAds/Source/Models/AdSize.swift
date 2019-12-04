import Foundation

public enum AdSize {
    case banner
    case largeBanner
    case mediumRectangle
    case fullBanner
    case leaderboard
}

extension AdSize {
    func getSize() -> (width: Int, height: Int) {
        switch self {
        case .banner:
            return (320, 50)
        case .largeBanner:
            return (320, 100)
        case .mediumRectangle:
            return (300, 250)
        case .fullBanner:
            return (468, 60)
        case .leaderboard:
            return (728, 90)
        }
    }
    
    public func height(from width: CGFloat) -> CGFloat {
        switch self {
        case .banner:
            return width * 5 / 32
        case .largeBanner:
            return width * 5 / 16
        case .mediumRectangle:
            return width * 5 / 6
        case .fullBanner:
            return width * 5 / 39
        case .leaderboard:
            return width * 45 / 364
        }
    }
    
    public func width(from height: CGFloat) -> CGFloat {
        switch self {
        case .banner:
            return height * 32 / 5
        case .largeBanner:
            return height * 16 / 5
        case .mediumRectangle:
            return height * 6 / 5
        case .fullBanner:
            return height * 39 / 5
        case .leaderboard:
            return height * 364 / 45
        }
    }
}
