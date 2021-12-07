//
//  This file is part of Game Catalogue.
//
//  Game Catalogue is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Game Catalogue is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Game Catalogue.  If not, see <https://www.gnu.org/licenses/>.
//

import SwiftUI
import Combine

// MARK: - RequestMethod
public enum RequestMethod: String {
    case GET
    case POST
}

// MARK: - Request
public class Request {
    private var urlStr: String
    private var method: String
    private var query: [String: String] = [:]
    private var header: [String: String] = [:]
    private var body: Any = {}

    public init(_ url: String, method: RequestMethod = .GET) {
        self.urlStr = url
        self.method = method.rawValue

        self.header["Content-Type"] = "application/json"
    }

    public func addQuery(key: String, value: String) -> Request {
        self.query[key] = value
        return self
    }

    public func addHeader(key: String, value: String) -> Request {
        self.header[key] = value
        return self
    }

    public func resultPublisher<T>() -> AnyPublisher<T, Error> where T: Codable {
        guard let url = constructUrl() else {
            return Fail<T, Error>(error: RequestError.invalidUrl("Invalid URL")).eraseToAnyPublisher()
        }

        let request = constructRequest(url)
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw RequestError.serverError(code: 0, error: "Server error")
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                RequestError.invalidJson(String(describing: error))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func constructUrl() -> URL? {
        var queryItems: [URLQueryItem] = []
        for (key, value) in self.query {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        guard var rawUrl = URLComponents(string: self.urlStr) else { return nil }
        rawUrl.queryItems = queryItems

        return rawUrl.url?.absoluteURL
    }

    private func constructRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        for (key, value) in self.header {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = self.method

        return request
    }
}
