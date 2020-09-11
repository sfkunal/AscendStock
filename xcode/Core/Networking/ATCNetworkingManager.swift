

import Alamofire

public enum ATCNetworkResponseStatus {
    case success
    case error(string: String?)
}

public class ATCNetworkingManager {

    let queue = DispatchQueue(label: "networking-manager-requests", qos: .userInitiated, attributes: .concurrent)

    func getJSONResponse(path: String, parameters: [String:String]?, completionHandler: @escaping (_ response: Any?,_ status: ATCNetworkResponseStatus) -> Void) {
        Alamofire
            .request(path, method: .get, parameters: parameters)
            .responseJSON(queue: queue, options: []) { (response) in
            DispatchQueue.main.async {
                if let json = response.result.value {
                    completionHandler(json, .success)
                } else {
                    completionHandler(nil, .error(string: response.result.error?.localizedDescription))
                }
            }
        }
    }

    func get(path: String, params: [String:String]?, completion: @escaping ((_ jsonResponse: Any?, _ responseStatus: ATCNetworkResponseStatus) -> Void)) {
        Alamofire.request(path, parameters: params).responseJSON { response in
            DispatchQueue.main.async {
                if let json = response.result.value {
                    completion(json, .success)
                } else {
                    completion(nil, .error(string: response.result.error?.localizedDescription))
                }
            }
        }
    }

}
