//
//  NetworkError.swift
//  GithubRepo
//
//  Created by HungLe on 4/21/22.
//

import Foundation

enum NetworkError: Error {
    case noInternet
    case apiFailure
    case invalidResponse
    case decodingError
    
}
