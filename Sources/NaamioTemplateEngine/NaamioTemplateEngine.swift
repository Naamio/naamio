import KituraTemplateEngine
import Malline
import Foundation

public class NaamioTemplateEngine: TemplateEngine {
    public var fileExtension: String { return "html" }
    private let `extension`: Extension
    
    public init(extension: Extension = Extension()) {
        self.`extension` = `extension`
    }
    
    public func render(filePath: String, context: [String: Any]) throws -> String {
        let templatePath = Path(filePath)
        let templateDirectory = templatePath.parent()

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

