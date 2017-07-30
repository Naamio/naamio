import Foundation

/// Templating provides the tools necessary to take content
/// and provide it in a structured method to the end-user.
class Templating {
    
    private static let templateSuffix = "html"
    
    static var templates: [String] = {
        let resources = Resources()
        
        return resources.getResources(from: Templating.path, withSuffix: templateSuffix)
    }()

    /// The path of the templates.
    static var path: String {
        return Config.settings["naamio.templates"] as? String ?? "_templates/leaf"
    }

    /// Loads the templates into memory for safe and efficient
    /// processing at runtime.
    static func load() {
        
    }
}
