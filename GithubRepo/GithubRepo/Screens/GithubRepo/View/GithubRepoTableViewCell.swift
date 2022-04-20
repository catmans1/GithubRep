//
//  GithubRepoTableViewCell.swift
//  GithubRepo
//
//  Created by HungLe on 4/21/22.
//

import UIKit

class GithubRepoTableViewCell: UITableViewCell {
    
    private let LeadingAnchorConstant: CGFloat = 10
    private let TrailingAnchorAnchorConstant: CGFloat = 10
    private let TopAnchorConstant: CGFloat = 10
    private let BottomAnchorConstant: CGFloat = 10
    private let PaddingTopBottomAnchorConstant: CGFloat = 5
    private let HeightConstant: CGFloat = 16
    
    private lazy var owner: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: FontSize.ProfileFont)
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var name: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: FontSize.TitleFont)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var descriptionRepo: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: FontSize.SubFont)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var starCount: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: FontSize.SubFont)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var language: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.font = UIFont.systemFont(ofSize: FontSize.SubFont)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(owner)
        contentView.addSubview(name)
        contentView.addSubview(descriptionRepo)
        contentView.addSubview(starCount)
        contentView.addSubview(language)
        
        NSLayoutConstraint.activate([
            owner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: TopAnchorConstant),
            owner.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LeadingAnchorConstant),
            owner.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TrailingAnchorAnchorConstant),
            owner.heightAnchor.constraint(equalToConstant: HeightConstant),
        ])

        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: owner.bottomAnchor, constant: PaddingTopBottomAnchorConstant),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LeadingAnchorConstant),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TrailingAnchorAnchorConstant),
            name.bottomAnchor.constraint(equalTo: descriptionRepo.topAnchor, constant: -PaddingTopBottomAnchorConstant)
        ])

        NSLayoutConstraint.activate([
            descriptionRepo.topAnchor.constraint(equalTo: name.bottomAnchor, constant: PaddingTopBottomAnchorConstant),
            descriptionRepo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LeadingAnchorConstant),
            descriptionRepo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TrailingAnchorAnchorConstant),
            descriptionRepo.bottomAnchor.constraint(equalTo: language.topAnchor, constant: -PaddingTopBottomAnchorConstant)
        ])
        
        NSLayoutConstraint.activate([
            starCount.topAnchor.constraint(equalTo: descriptionRepo.bottomAnchor, constant: PaddingTopBottomAnchorConstant),
            starCount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LeadingAnchorConstant),
            starCount.trailingAnchor.constraint(equalTo: language.leadingAnchor, constant: -TrailingAnchorAnchorConstant),
            starCount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -BottomAnchorConstant)
        ])

        NSLayoutConstraint.activate([
            language.centerYAnchor.constraint(equalTo: starCount.centerYAnchor),
            language.leadingAnchor.constraint(equalTo: starCount.trailingAnchor, constant: LeadingAnchorConstant),
            language.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TrailingAnchorAnchorConstant),
            language.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -BottomAnchorConstant)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //githubRepo: GithubRepoItem?
    func setupCell(githubRepo: GithubRepoItem) {
        
        owner.text = githubRepo.owner?.login

        name.text = githubRepo.name
        descriptionRepo.text = githubRepo.description
        language.text = githubRepo.language
        if let star = githubRepo.stargazersCount {
            starCount.text = "✩ \(star)"
        }
    }
}
