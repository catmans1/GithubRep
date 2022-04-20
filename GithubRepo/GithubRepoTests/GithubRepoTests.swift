//
//  GithubRepoTests.swift
//  GithubRepoTests
//
//  Created by HungLe on 4/21/22.
//

import XCTest
@testable import GithubRepo

class GithubRepoTests: XCTestCase {

    var repoRequest: RepoServices?
    let repoDataMockup: [String: Any] = [
        "total_count": 12,
        "incomplete_results": true,
        "items": [
            [
                "id": 1,
                "name": "Droar",
                "full_name": "myriadmobile/Droar",
                "private": false,
                "owner": [
                    "login": "myriadmobile"
                ],
                "html_url": "https://github.com/myriadmobile/Droar",
                "description": "Droar is a modular, single-line installation debugging window",
                "stargazers_count": 52
            ]
        ]
    ]
    
    override func setUpWithError() throws {
        repoRequest = RepoServices()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        repoRequest = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRepoRequest() throws {
        let promise = expectation(description: "Fetch Github Repositories")

        repoRequest?.searchRepos(query: "test", onCompletion: { result in
            switch result {
            case .success(_):
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error)")
                return
            }
        })
        
        wait(for: [promise], timeout: 7)
    }
    
    func testSerializeRepoData() {
        guard let data = try? JSONSerialization.data(withJSONObject: repoDataMockup, options: .prettyPrinted), let repoInfo = try? JSONDecoder().decode(GithubRepoData.self, from: data) else {
            XCTFail()
            return
        }
        
        XCTAssert(repoInfo.items?.count == 1)
        XCTAssert(repoInfo.totalCount == 12)
    }

}
