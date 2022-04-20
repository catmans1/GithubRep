//
//  GithubRepoViewController.swift
//  GithubRepo
//
//  Created by HungLe on 4/21/22.
//

import UIKit
import SafariServices

class GithubRepoViewController: UIViewController, UISearchBarDelegate {
    
    fileprivate let CellIdentifiers = "CellIdentifiers"
    
    private lazy var repoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.register(GithubRepoTableViewCell.self, forCellReuseIdentifier: CellIdentifiers)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        return tableView
    }()
        
    private var githubRepoViewModel = GithubRepoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        bindViewModelEvent()
    }
    
    private func setupUI() {
        view.addSubview(repoTableView)
        
        NSLayoutConstraint.activate([
            repoTableView.topAnchor.constraint(equalTo: view.topAnchor),
            repoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            repoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            repoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    fileprivate func setupNavigationBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Repositories"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    fileprivate func searchRepos(searchText: String) {
        guard let query = navigationItem.searchController?.searchBar.text, !query.isEmpty else {
            return
        }
        githubRepoViewModel.searchRepos(query: query)
    }
    
    private func bindViewModelEvent() {
        githubRepoViewModel.onFetchSucceed = {[weak self] in
            DispatchQueue.main.async {
                self?.repoTableView.reloadData()
            }
        }
        
        githubRepoViewModel.onFetchFailure = { error in
            print(error)
        }
    }
    
}

extension GithubRepoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return githubRepoViewModel.githubRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers, for: indexPath) as? GithubRepoTableViewCell else { return UITableViewCell() }
        let repo = githubRepoViewModel.githubRepos[indexPath.row]
        cell.setupCell(githubRepo: repo)
        return cell
    }
}

extension GithubRepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let htmlUrlString = githubRepoViewModel.githubRepos[indexPath.row].htmlUrl,
              let url = URL(string: htmlUrlString)
            else { return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GithubRepoViewController:UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.throttle(deadline: DispatchTime.now() + 0.5) {[weak self] in
            self?.searchRepos(searchText: searchText)
        }
    }
    
}
