

public class ATCAPIManager {

    fileprivate let networkingManager = ATCNetworkingManager()

    func retrieveObjectFromJSON<T: ATCGenericJSONParsable>(urlPath: String, parameters: [String:String]?, completion: @escaping (_ object: T?, _ status: ATCNetworkResponseStatus) -> Void) {
        networkingManager.getJSONResponse(path: urlPath, parameters: parameters) { (jsonData: Any?, status: ATCNetworkResponseStatus) in
            if let jsonDict = jsonData as? [String: Any] {
                completion(T(jsonDict: jsonDict), status)
            } else {
                completion(nil, status)
            }
        }
    }

    func retrieveListFromJSON<T: ATCGenericJSONParsable>(urlPath: String, parameters: [String:String]?, completion: @escaping (_ objects: [T]?, _ status: ATCNetworkResponseStatus) -> Void) {
        networkingManager.getJSONResponse(path: urlPath, parameters: parameters) { (jsonData: Any?, status: ATCNetworkResponseStatus) in
            if let jsonArray = jsonData as? [[String: Any]] {
                completion(jsonArray.compactMap{T(jsonDict: $0)}, status)
            } else {
                completion(nil, status)
            }
        }
    }
}
