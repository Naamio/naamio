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

class Resources {

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

    func getResourcePathBasedOnSourceLocation(for resource: String) -> String {
        let fileName = NSString(string: #file)
        let resourceFilePrefixRange: NSRange
        let lastSlash = fileName.range(of: "/", options: .backwards)
        
        if  lastSlash.location != NSNotFound {
            resourceFilePrefixRange = NSMakeRange(0, lastSlash.location + 1)
        } else {
            resourceFilePrefixRange = NSMakeRange(0, fileName.length)
        }

        return fileName.substring(with: resourceFilePrefixRange) + "resources/" + resource
    }

    func getResourcePathBasedOnCurrentDirectory(for resource: String, withFileManager fileManager: FileManager) -> String? {
        do {
            let packagePath = fileManager.currentDirectoryPath + "/Packages"
            let packages = try fileManager.contentsOfDirectory(atPath: packagePath)
            
            for package in packages {
                let potentalResource = "\(packagePath)/\(package)/Resources/content/\(resource)"
                print("Potential resource: \(potentalResource)")
                let resourceExists = fileManager.fileExists(atPath: potentalResource)
                
                if resourceExists {
                    return potentalResource
                }
            }
        } catch {
            return nil
        }

        return nil
    }
}