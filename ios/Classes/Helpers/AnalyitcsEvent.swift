struct AnalyticsEvent {
    let eventName: String
    let properties: [String: Any]
    
    func toDictionary() -> [String: Any] {
            var dictionary: [String: Any] = ["eventName": eventName]
            dictionary["properties"] = properties
            return dictionary
        }
}