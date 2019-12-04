import Foundation

extension UserDefaults {
    static func setAddInfo(_ info: AdInfo?, for event: AppVertEvent) {
        setAddInfo(info, for: event.rawValue)
    }
    
    static func setAddInfo(_ info: AdInfo?, for event: String) {
        guard let info = info else {
            standard.set(nil, forKey: event)
            return
        }
        let encoder = JSONEncoder()
        let data = try? encoder.encode(info)
        standard.set(data, forKey: event)
    }
    
    static func getAddInfo(for event: AppVertEvent) -> AdInfo? {
        return getAddInfo(for: event.rawValue)
    }
    
    static func getAddInfo(for event: String) -> AdInfo? {
        guard let data = standard.data(forKey: event) else {return nil}
        let decoder = JSONDecoder()
        return try? decoder.decode(AdInfo.self, from: data)
    }
    
    // Handle Ads showing FREQUENCY
    static func setAdsShowingFrequency(numOfTime: Int) {
        self.standard.setValue(numOfTime, forKey: AppVertKeys.frequencyOpen.rawValue)
    }
    
    static func getAdsShowingFrequency() -> Int {
        let numOfTime = self.standard.integer(forKey: AppVertKeys.frequencyOpen.rawValue)
        return numOfTime == 0 ? 1 : numOfTime
    }
    
    static func setAdsCountOpen(count: Int) {
        self.standard.setValue(count, forKey: AppVertKeys.countOpen.rawValue)
    }
    
    static func getAdsCountOpen() -> Int {
        return self.standard.integer(forKey: AppVertKeys.countOpen.rawValue)
    }
}
