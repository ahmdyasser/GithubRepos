//
//  RepoDetail.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation

struct RepoDetail: Codable {
  let createdAt: String?

  enum CodingKeys: String, CodingKey {
    case createdAt = "created_at"
  }

}
