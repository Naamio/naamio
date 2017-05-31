/**
* Omnijar Seneca License 1.0
*
* Copyright (c) 2016 Omnijar Studio Oy 
* All rights reserved.
* 
* Permission is hereby granted, free of charge, to any person obtaining a 
* copy of this software and associated documentation files (the "Software"), 
* to use the Software for the enhancement of knowledge and to further 
* education. 
* 
* Permission is granted for the Software to be copied, modified, merged, 
* published, and distributed as original source, and to permit persons to 
* whom the Software is furnished to do so, for the above reasons, subject 
* to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software. The Software shall not
* be used for commercial or promotional purposes without written permission
* from the authors or copyright holders.
* 
* THE SOFTWARE IS NOT OPEN SOURCE. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
* WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
* WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
* LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
* CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH 
* THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**/

import Foundation

/// Resources provides the tools necessary to manage all types of 
/// files, including templates, images, etc. for the application 
/// to run.
class Resources {
    
    func getResources(from path: String, withSuffix suffix: String) -> [String] {
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
    
    func getResources(from path: String) -> String {
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
    func getFilePath(for resource: String) -> String? {
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
    func getResourcePathBasedOnSourceLocation(for resource: String) -> String {
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
    func getResourcePathBasedOnCurrentDirectory(for resource: String, withFileManager fileManager: FileManager) -> String? {
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
}
