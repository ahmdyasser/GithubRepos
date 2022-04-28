//
//  RepoDetailViewModel.swift
//  GithubRepos
//
//  Created by Mostfa on 28/04/2022.
//

import Foundation
import UIKit
import Combine
struct RepoDetailViewModelDTO: Hashable, Equatable {

  let createdAt: String
  let forksCount: String
  let watchersCount: String
  let openIssuesCount: String
  let size: String
  let name: String
  let description: String
  let cover: AnyPublisher<UIImage?, Never>

  func hash(into hasher: inout Hasher) {
    hasher.combine(createdAt)
  }

  static func == (lhs: RepoDetailViewModelDTO, rhs: RepoDetailViewModelDTO) -> Bool {
    lhs.createdAt == rhs.createdAt
  }

  enum Builder {
    static func viewModel(from repo: RepoDetail,
                          imageLoader: (RepoDetail) -> AnyPublisher<UIImage?, Never>) -> RepoDetailViewModelDTO {
      return RepoDetailViewModelDTO.init(createdAt: "\(repo.createdAt)",
                                        forksCount: "\(repo.forksCount)",
                                        watchersCount: "\(repo.watchersCount)",
                                        openIssuesCount: "\(repo.openIssuesCount)",
                                        size: "\(repo.size)",
                                        name: "\(repo.name)",
                                        description: repo.description ?? "",
                                        cover: imageLoader(repo))
    }
  }

}
