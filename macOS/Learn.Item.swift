extension Learn {
    enum Item: Int, CaseIterable {
        case
        purchases,
        policy,
        terms
        
        var title: String {
            switch self {
            case .purchases:
                return "Why In-App Purchases"
            case .policy:
                return "Privacy Policy"
            case .terms:
                return "Terms and Conditions"
            }
        }
        
        var info: String {
            switch self {
            case .purchases:
                return Copy.why
            case .policy:
                return Copy.policy
            case .terms:
                return Copy.terms
            }
        }
    }
}
