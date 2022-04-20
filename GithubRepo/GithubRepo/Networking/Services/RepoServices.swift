//
//  RepoServices.swift
//  GithubRepo
//
//  Created by HungLe on 4/21/22.
//

import Foundation

struct RepoServices {
    
    func searchRepos(query:String, onCompletion: @escaping (Result<GithubRepoData?, NetworkError>) -> ()) {
        NetworkManager.makeGetRequest(path: "search/repositories", queries: ["q":query]) { result in
            onCompletion(result)
        }
    }
}
