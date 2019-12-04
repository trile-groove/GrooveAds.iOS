import Foundation
import Alamofire

enum AppVertResponse {
    case success(Campaign)
    case error(AppVertError)
}

class Network {
    
    static let shared = Network()
    private let sessionManager: Alamofire.Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        sessionManager = Alamofire.Session(configuration: configuration)
    }

    func dismiss(_ request: DismissRequest, responseHandler: @escaping (Bool) -> Void) {
        let absolutePath = "\(AppVert.shared.endPoint)/\(ApiEndpoint.dismiss.rawValue)"
        
        let encoder = JSONEncoder()
        var urlRequest = URLRequest(url: URL(string: absolutePath)!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? encoder.encode(request)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        sessionManager
            .request(urlRequest)
            .responseData { response in
                switch response.result {
                case .success(_):
                    responseHandler(true)
                case .failure(_):
                    responseHandler(false)
                }
            }
    }
    
    func fetchCampaign(_ request: CampaignRequest, responseHandler: @escaping (AppVertResponse) -> Void) {
        let absolutePath = "\(AppVert.shared.endPoint)/\(ApiEndpoint.display.rawValue)"
        
        let encoder = JSONEncoder()
        var urlRequest = URLRequest(url: URL(string: absolutePath)!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? encoder.encode(request)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        sessionManager
            .request(urlRequest)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    print(String(data: data, encoding: .utf8) ?? "")
                    do {
                        let campaign = try decoder.decode(CampaignResponse.self, from: data)
                        if let campaign = campaign.value?.campaign {
                            print("campaign: \(campaign)")
                             responseHandler(.success(campaign))
                        } else {
                           responseHandler(.error(campaign.getError()))
                        }
                    } catch let error {
                        print("Error when get Campaign, request: \(request), log: \(error)")
                        responseHandler(.error(AppVertError.unknown(error.localizedDescription)))
                    }
                case .failure(let error):
                    responseHandler(.error(AppVertError.fromNetworkError(error)))
                }
            }
    }
    
    func cancelAllRequests() {
        sessionManager.session.getAllTasks { (tasks) in
            tasks.forEach({$0.cancel()})
        }
    }
}
