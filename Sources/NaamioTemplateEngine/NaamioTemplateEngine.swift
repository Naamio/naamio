import Foundation

import KituraTemplateEngine

import Malline

import NaamioCore

public enum NaamioTemplateEngineError: Swift.Error {
    case rootPathsEmpty
    case notValidTemplate
}

struct NaamioTemplateCache {
    var stencil: Stencil
    var path: Path
}

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

    private var rootPaths: [Path] = []
    
    private var cache: [NaamioTemplateCache]
    
    /// Initializes a new instance of the `NaamioTemplateEngine` with 
    /// the default extension (`.html`).
    public init(extension: Extension = Extension()) {
        self.`extension` = `extension`
        self.cache = [NaamioTemplateCache]()
    }
    
    public func cacheTemplates(from path: String) throws {
        Log.trace("Caching templates in \(path)")
        let templates = try! Path(path).recursiveChildren()
        
        for template in templates {
            _ = try self.cacheTemplate(filePath: template.string)
        }
    }

    public func setRootPaths(rootPaths: [String]) {
        self.rootPaths = rootPaths.map { Path($0) }
    }

    public func cacheTemplate(filePath: String) throws -> Stencil {
        let templatePath = Path(filePath)
        
        guard templatePath.isFile else {
            throw NaamioTemplateEngineError.notValidTemplate
        }
        
        let templateDirectory = templatePath.parent()
        
        Log.trace("\(templatePath.string) is loading")
        
        let loader = FileSystemLoader(paths: [templateDirectory])
        `extension`.registerTag("asset", parser: AssetTag.parse)
        let environment = Environment(loader: loader, extensions: [`extension`])

        let template = try environment.loadStencil(names: [templatePath.lastComponent])
        Log.trace("Template '\(String(describing: template.name))' loaded")
        
        if cache.contains(where: { cachedItem in
            if (template.name == cachedItem.stencil.name) &&
                (templatePath == cachedItem.path) {
                return true
            } else {
                return false
            }
        }) {
            return template
        }
        else {
            Log.trace("Template is new. Caching.")
            return template
        }
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
    
        let loader = FileSystemLoader(paths: [templateDirectory])
        `extension`.registerTag("asset", parser: AssetTag.parse)
        let environment = Environment(loader: loader, extensions: [`extension`])
        var context = context
        context["loader"] = loader
        
        return try environment.renderStencil(name: templatePath.lastComponent,  context: context)
    }

    /// Renders the given template using `Malline`, and the additional tags
    /// provided to the parser by the `NaamioTemplateEngine`.
    ///
    ///  - parameter filePath: The path of the file in relation to the root project.
    ///  - parameter context: The meta information for the current page session.
    ///  - parameter options: Rendering options for `Malline` to render the template.
    ///  - parameter templateName: Name to use for the template.
    ///  - returns: The resulting file post-render.
    public func render(filePath: String, context: [String: Any], options: RenderingOptions,
                       templateName: String) throws -> String {
        if rootPaths.isEmpty {
            throw NaamioTemplateEngineError.rootPathsEmpty
        }
        
        Log.trace("Rendering \(templateName) from '\(filePath)'")
        
        let loader = FileSystemLoader(paths: rootPaths)
        `extension`.registerTag("asset", parser: AssetTag.parse)
        let environment = Environment(loader: loader, extensions: [`extension`])
        var context = context
        context["loader"] = loader
        return try environment.renderStencil(name: templateName,  context: context)
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

