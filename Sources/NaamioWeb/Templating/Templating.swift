import Foundation

import NaamioCore

/// Templating provides the tools necessary to take content
/// and provide it in a structured method to the end-user.
class Templating {

    static let `default` = Templating()
    
    private let templateSuffix = "html"
    
    /// List of templates within Templating instance.
    var templates: [String] = [String]()

    /// The path of the templates.
    var path: String = ""

    init() {
        let resources = Resources()
        
        templates = resources.getResources(from: path, withSuffix: templateSuffix)
        path = Config.settings["naamio.templates"] as? String ?? "_templates/leaf"
    }
}
