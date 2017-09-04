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
import Malline

class AssetTag : TagType {
    let assetName: Variable
    
    class func parse(_ parser: TokenParser, token: Token) throws -> TagType {
        let bits = token.components()
        
        guard bits.count == 2 else {
            throw StencilSyntaxError("'asset' tag takes one argument, the asset file to be included")
        }
        
        return AssetTag(assetName: Variable(bits[1]))
    }
    
    init(assetName: Variable) {
        self.assetName = assetName
    }
    
    func render(_ context: Context) throws -> String {
        guard let assetName = try self.assetName.resolve(context) as? String else {
            throw StencilSyntaxError("'\(self.assetName)' could not be resolved as a string")
        }
        
        let assetPath = "/assets" + assetName
        
        return assetPath
    }
}
