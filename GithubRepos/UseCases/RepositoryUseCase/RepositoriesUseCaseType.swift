//
//  RepositoryUseCase.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Combine
import UIKit.UIImage

typealias Repositories = [Repository]

protocol RepositoriesUseCaseType: AutoMockable {

  /// Fetches all repositories
  func fetchRepositories(page: Int) -> AnyPublisher<Repositories, Error>

  /// Fetches details for a repository with specified id
  func repositoryDetails(_ repo: Repository) -> AnyPublisher<RepoDetail, Error>

  func loadRepoImage(repo: RepoCoverProvider) -> AnyPublisher<UIImage?, Never>

  func loadRepoDate(repo: Repository) -> AnyPublisher<String?, Never>

}
