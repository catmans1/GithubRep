//
//  GithubRepoModel.swift
//  GithubRepo
//
//  Created by HungLe on 4/21/22.
//

import Foundation

struct Owner: Codable {
    let login: String?
    
    enum CodingKeys: String, CodingKey {
        case login
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        login = try values.decodeIfPresent(String.self, forKey: .login)
    }
}

struct GithubRepoItem: Codable {
    let id: Int?
    let name: String?
    let owner: Owner?
    let description: String?
    let htmlUrl: String?
    let language: String?
    let stargazersCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case description
        case htmlUrl = "html_url"
        case language
        case stargazersCount = "stargazers_count"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        owner = try values.decodeIfPresent(Owner.self, forKey: .owner)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        stargazersCount = try values.decodeIfPresent(Int.self, forKey: .stargazersCount)
    }
}

struct GithubRepoData: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [GithubRepoItem]?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
        incompleteResults = try values.decodeIfPresent(Bool.self, forKey: .incompleteResults)
        items = try values.decodeIfPresent([GithubRepoItem].self, forKey: .items)
    }
}
