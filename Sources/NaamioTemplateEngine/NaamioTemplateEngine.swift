import KituraTemplateEngine
import Malline
import Foundation

/// NaamioTemplateEngine is the base templating system for `Naamio`.
/// It utilizes `Kitura` and `Malline`, extending base functionality 
/// to support additional tags and functions, specific to `Naamio`.
///
/// Documentation can be found at [Malline on GitHub](https://github.com/Naamio/malline).
public class NaamioTemplateEngine: TemplateEngine {

    /// Identifies the specific file extensions to look for.
    /// In the case of `Naamio`, we use `.html` to simplify
    /// adoption and migration use cases.
    public var fileExtension: String { return "html" }

    private let `extension`: Extension
    
    /// Initializes a new instance of the `NaamioTemplateEngine` with 
    /// the default extension (`.html`).
    public init(extension: Extension = Extension()) {
        self.`extension` = `extension`
    }
    
    /// Renders the given template using `Malline`, and the additional tags
    /// provided to the parser by the `NaamioTemplateEngine`.
    ///
    ///  - parameter filePath: The path of the file in relation to the root project.
    ///  - parameter context: The meta information for the current page session.
    ///  - returns: The resulting file post-render.
    public func render(filePath: String, context: [String: Any]) throws -> String {
        let templatePath = Path(filePath)
        let templateDirectory = templatePath.parent()
        print(templateDirectory)
    
        let loader = FileSystemLoader(paths: [templateDirectory])
        `extension`.registerTag("asset", parser: AssetTag.parse)
        let environment = Environment(loader: loader, extensions: [`extension`])
        var context = context
        context["loader"] = loader
        
        return try environment.renderStencil(name: templatePath.lastComponent,  context: context)
    }
    
    func assetsFilter(value: Any?, arguments: [Any?]) throws -> Any? {
        var path: String
        
        if let value = arguments.first as? String {
            path = value
        } else {
            throw StencilSyntaxError("Asset tag must be called with a String argument")
        }
        
        path = "/assets" + path
        
        /*
            if let value = value as? String {
                return "/assets" + value
            }
        */
        
        return path
    }
}

