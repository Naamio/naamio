
import Foundation
import ViilaFS

public enum ReaderError: Error {
    case resourceNotFound
    case readFailed(Error)
    case convertToStringFailed
}

/// Resources provides the tools necessary to manage all types of 
/// files, including templates, images, etc. for the application 
/// to run.
public class Resources {

    public init() {}
    
    public func getResources(from path: String, withSuffix suffix: String) -> [String] {
        let fileManager = FileManager.default
        let potentialResource = NSString(string: "\(fileManager.currentDirectoryPath)/\(path)").standardizingPath
        let fileExists = fileManager.fileExists(atPath: potentialResource)
        
        var resources = [String]()
        
        if fileExists {
            do {
                let potentialResources = try fileManager.contentsOfDirectory(atPath: potentialResource)
            
                resources = potentialResources.filter{ URL(fileURLWithPath: $0).pathExtension == suffix }
            } catch {
            
            }
        }
        
        return resources
    }
    
    public func getResources(from path: String) -> String {
        let fileManager = FileManager.default
        let potentialResource = NSString(string: "\(fileManager.currentDirectoryPath)/\(path)").standardizingPath
        let fileExists = fileManager.fileExists(atPath: potentialResource)
        
        if fileExists {
            Log.trace("Resource found: \(potentialResource)")
            return potentialResource
        } else {
            return path
        }
    }

    /// Returns a resource / file path based on a resource path. This can be
    /// relational, or absolute.
    public func getFilePath(for resource: String) -> String? {
        let fileManager = FileManager.default
        let potentialResource = getResourcePathBasedOnSourceLocation(for: resource)
        let fileExists = fileManager.fileExists(atPath: potentialResource)
        
        if fileExists {
            return potentialResource
        } else {
            return getResourcePathBasedOnCurrentDirectory(for: resource, withFileManager: fileManager)
        }
    }

    /// Returns a resource / file path based on the source location.
    public func getResourcePathBasedOnSourceLocation(for resource: String) -> String {
        let fileName = NSString(string: #file)
        let resourceFilePrefixRange: NSRange
        let lastSlash = fileName.range(of: "/", options: .backwards)
        
        if lastSlash.location != NSNotFound {
            resourceFilePrefixRange = NSMakeRange(0, lastSlash.location + 1)
        } else {
            resourceFilePrefixRange = NSMakeRange(0, fileName.length)
        }

        let response = fileName.substring(with: resourceFilePrefixRange) + "resources/" + resource

        Log.trace("Getting resource from source location: \(response)")
        
        return response
    }

    /// Returns a resoure / file path based on the current working directory.
    public func getResourcePathBasedOnCurrentDirectory(for resource: String, withFileManager fileManager: FileManager) -> String? {
        do {
            let packagePath = fileManager.currentDirectoryPath + "/Packages"

            let packages = try fileManager.contentsOfDirectory(atPath: packagePath)
            
            for package in packages {
                let potentalResource = "\(packagePath)/\(package)/Resources/content/\(resource)"
                Log.trace("Potential resource: \(potentalResource)")
                let resourceExists = fileManager.fileExists(atPath: potentalResource)
                
                if resourceExists {
                    Log.trace("Getting resource from current directory: \(potentalResource)")
                    return potentalResource
                }
            }
        } catch {
            return nil
        }

        return nil
    }

    

    public func getResourceTree(from path: String) {
        try! Folder(path: path).makeSubfolderSequence(recursive: true).forEach { folder in
            // TODO: Provide folder default string value.
            Log.trace("Name : \(folder.name), parent: \(String(describing: folder.parent))")
        }
    }
}
