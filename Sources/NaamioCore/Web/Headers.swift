/**
 * Omnijar Seneca License 1.0
 *
 * Copyright (c) 2017 Omnijar Studio Oy
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

import Kitura

class HeadersMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        response.headers["Access-Control-Allow-Origin"] = "*"
        response.headers["Access-Control-Allow-Headers"] = "accept, content-type"
        response.headers["Access-Control-Allow-Methods"] = "GET,HEAD,POST,DELETE,OPTIONS,PUT"
        response.headers["Server"] = "Naamio/0.2.0"
        response.headers["X-Powered-By"] = "Naamio/0.2.0"
        response.headers["Content-Type"] = "application/xhtml+xml; charset=utf-8"
        next()
    }
}
