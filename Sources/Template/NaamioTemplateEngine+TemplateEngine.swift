import Foundation 

import KituraTemplateEngine

import Loki
import Malline

import NaamioCore

extension NaamioTemplateEngine: TemplateEngine {
    /// Renders the given template using `Malline`, and the additional tags
    /// provided to the parser by the `NaamioTemplateEngine`.
    ///
    ///  - Parameters:
    ///    - filePath: The path of the file in relation to the root project.
    ///    - context: The meta information for the current page session.
    ///  - Throws: A rendering Error from `renderStencil`
    ///  - Returns: The resulting file post-render.
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
    ///  - Parameters:
    ///    - filePath: The path of the file in relation to the root project.
    ///    - context: The meta information for the current page session.
    ///    - options: Rendering options for `Malline` to render the template.
    ///    - templateName: Name to use for the template.
    ///  - Throws: `rootPathsEmpty` Error if the `rootPaths` property is empty.
    ///  - Returns: The resulting file post-render.
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

    /// Take a template file and an `Encodable` type and generate the content to be sent back to the client.
    /// Note that this function is called by Kitura when you call [`response.render(_:with:forKey:options:)`](https://ibm-swift.github.io/Kitura/Classes/RouterResponse.html#/s:6Kitura14RouterResponseC6renderACSS_x4withSSSg6forKey0A14TemplateEngine16RenderingOptions_p7optionstKs9EncodableRzlF).
    ///
    /// - Parameters:
    ///   - filePath: The path of the template file to use when generating the content.
    ///   - with: A value that conforms to `Encodable` which is used to generate the content.
    ///   - forKey: A value used to match the `Encodable` values to the correct variable in a template file.
    ///             The `forKey` value should match the desired variable in the template file.
    ///   - options: Unused by this templating engine.
    ///   - templateName: The name of the template.
    ///
    public func render<T: Encodable>(filePath: String, with value: T, forKey key: String?,
                                   options: RenderingOptions, templateName: String) throws -> String {
        if rootPaths.isEmpty {
            throw NaamioTemplateEngineError.rootPathsEmpty
        }
        
        //Throw an error if an array is passed without providing a key.
        if key == nil {
            let mirror = Mirror(reflecting: value)
            if mirror.displayStyle == .collection || mirror.displayStyle == .set {
                throw NaamioTemplateEngineError.noKeyProvidedForType(value: value)
            }
        }
        
        let json: [String: Any]
        
        if let contextKey = key {
            json = [contextKey: value]
        } else {
            var data = Data()
            do {
                data = try JSONEncoder().encode(value)
            } catch {
                throw NaamioTemplateEngineError.unableToEncodeValue(value: value)
            }
            
            guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw NaamioTemplateEngineError.unableToSerializeToDictionary
            }
            
            json = dict
        }
        
        return try render(filePath: filePath, context: json, options: options, templateName: templateName)
    }
}