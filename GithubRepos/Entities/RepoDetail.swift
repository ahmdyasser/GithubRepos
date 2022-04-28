//
//  RepoDetail.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation

/// Implementers of this protocol, will provide an imageURL for the cover, used to remove duplication of function from the use case.
protocol RepoCoverProvider { var imageURL: String { get } }

struct RepoDetail: Codable, RepoCoverProvider {
  let createdAt: String
  let forksCount: Int
  let watchersCount: Int
  let openIssuesCount: Int
  let owner: Repository.Owner
  let size: Int
  var description: String?
  var name: String

  var imageURL: String {
    return owner.avatarURL
  }
  enum CodingKeys: String, CodingKey {
    case createdAt = "created_at"
    case openIssuesCount = "open_issues_count"
    case watchersCount = "watchers_count"
    case forksCount = "forks_count"
    case owner = "owner"
    case description = "description"
    case name = "name"
    case size = "size"

  }

}
