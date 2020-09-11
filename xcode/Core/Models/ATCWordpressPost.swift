

public class ATCWordpressPost: ATCGenericBaseModel {
    var link: String?
    var title: String?
    var text: String?
    var picture: String?
    public var description: String {
        return title ?? ""
    }

    required public init(jsonDict: [String: Any]) {
//        link            <- map["link"]
//        title           <- map["title"]
//        text            <- map["text"]
//        picture         <- map["picture"]
    }
}
