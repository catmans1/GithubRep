//
//  GithubRepoViewModel.swift
//  GithubRepo
//
//  Created by HungLe on 4/21/22.
//

import Foundation

final class GithubRepoViewModel {
    
    private let repoServices = RepoServices()
    
    var githubRepos: [GithubRepoItem] = []
    var isFetching = false
    var onFetchSucceed: (() -> Void)?
    var onFetchFailure: ((Error) -> Void)?
    
    func searchRepos(query: String) {
        repoServices.searchRepos(query: query) {[weak self] result in
            switch result {
            case .success(let githubData):
                if let githubItem = githubData?.items {
                    self?.githubRepos = githubItem
                    self?.onFetchSucceed?()
                }
            case .failure(let error):
                self?.onFetchFailure?(error)
            }
        }
    }
    
}
