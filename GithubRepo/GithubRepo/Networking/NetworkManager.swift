//
//  NetworkManager.swift
//  GithubRepo
//
//  Created by HungLe on 4/21/22.
//

import Foundation

typealias Parameters = [String : Any]

protocol NetworkProtocol {
    static func makeRequest<T: Codable>(session: URLSession, request: URLRequest, model: T.Type, onCompletion: @escaping(Result<T?, NetworkError>) -> ())
    static func makeGetRequest<T: Codable> (path: String, queries: Parameters, onCompletion: @escaping(Result<T?, NetworkError>) -> ())
}

enum NetworkManager: NetworkProtocol {
    case getAPI(path: String, data: Parameters)

    static var baseURL: URL = URL(string: "https://api.github.com/")!
    
    private var path: String {
        switch self {
        case .getAPI(let path, _):
            return path
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getAPI:
            return .get
        }
    }
    
    fileprivate func addHeaders(request: inout URLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    fileprivate func asURLRequest() -> URLRequest {
        /// appends the path passed to either of the enum case with the base URL
        var request = URLRequest(url: Self.baseURL.appendingPathComponent(path))
        /// appends the httpMethod based on the enum case
        request.httpMethod = method.rawValue
        
        var parameters = Parameters()
        
        switch self {
        case .getAPI(_, let queries):
            /// we are just going through all the key and value pairs in the queries and adding the same to parameters.. For Each Key-Value pair,  parameters[key] = value
            queries.forEach({parameters[$0] = $1})
            /// encode the queries for GET call //
            URLEncoding.queryString.encode(&request, with: parameters)
        }
        self.addHeaders(request: &request)
        return request
    }
    
    internal static func makeRequest<T: Codable>(session: URLSession, request: URLRequest, model: T.Type, onCompletion: @escaping(Result<T?, NetworkError>) -> ()) {
        let sessionTask:URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            
            guard error == nil, let responseData = data else {
                onCompletion(.failure(NetworkError.apiFailure)) ; return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    as? Parameters  {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let response = try JSONDecoder().decode(T.self, from: jsonData)
                    onCompletion(.success(response))
                    
                    /// if the response is an `Array of Objects`
                } else if let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            as? [Parameters] {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let response = try JSONDecoder().decode(T.self, from: jsonData)
                    onCompletion(.success(response))
                }
                else {
                    onCompletion(.failure(NetworkError.invalidResponse))
                    return
                }
            } catch {
                onCompletion(.failure(NetworkError.decodingError))
                return
            }
        }

        DispatchQueue.main.throttle(deadline: DispatchTime.now() + 0.5) {
            sessionTask.resume()
        }
    }
    
    internal static func makeGetRequest<T: Codable> (path: String, queries: Parameters, onCompletion: @escaping(Result<T?, NetworkError>) -> ()) {
        let session = URLSession.shared
        let request: URLRequest = Self.getAPI(path: path, data: queries).asURLRequest()
        makeRequest(session: session, request: request, model: T.self) { result in
            onCompletion(result)
        }
    }
    
}
