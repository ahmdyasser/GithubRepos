//
//  RepoViewModel.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Combine
import UIKit

/// Represents a single Repository ViewModel
struct RepoViewModel: Hashable, Equatable {

  let id: Int
  let title: String
  let ownerName: String
  let cover: AnyPublisher<UIImage?, Never>
  let date: AnyPublisher<String?, Never>
}

// MARK: - Hashable Implementation
extension RepoViewModel {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

// MARK: - Equatable Implementation
extension RepoViewModel {
  static func == (lhs: RepoViewModel, rhs: RepoViewModel) -> Bool {
    lhs.id == rhs.id
  }
}

extension RepoViewModel {
  enum Builder {
    static func viewModel(from repo: Repository,
                          dateLoader: (Repository) -> AnyPublisher<String?, Never>,
                          imageLoader: (Repository) -> AnyPublisher<UIImage?, Never>) -> RepoViewModel {
      return RepoViewModel.init(id: repo.id,
                                      title: repo.name,
                                      ownerName: repo.owner.login,
                                      cover: imageLoader(repo),
                                      date: dateLoader(repo))
    }
  }
}

class DetailedRepoViewModel: Hashable, Equatable, ObservableObject {

  init(createdAt: String = "",
       forksCount: String = "",
       watchersCount: String = "",
       openIssuesCount: String = "",
       size: String = "",
       name: String = "",
       description: String = "",
       cover: AnyPublisher<UIImage?, Never> = .empty()) {
    self.createdAt = createdAt
    self.forksCount = forksCount
    self.watchersCount = watchersCount
    self.openIssuesCount = openIssuesCount
    self.size = size
    self.name = name
    self.description = description
    self.cover = cover
  }

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

  static func == (lhs: DetailedRepoViewModel, rhs: DetailedRepoViewModel) -> Bool {
    lhs.createdAt == rhs.createdAt
  }

  enum Builder {
    static func viewModel(from repo: RepoDetail,
                          imageLoader: (RepoDetail) -> AnyPublisher<UIImage?, Never>) -> DetailedRepoViewModel {
      return DetailedRepoViewModel.init(createdAt: "\(repo.createdAt)",
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
