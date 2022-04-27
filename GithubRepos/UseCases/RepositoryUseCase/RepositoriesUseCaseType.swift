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
  func repositoryDetails(_ repo: Repository) -> AnyPublisher<Repository, Error>
  
  func loadRepoImage(repo: Repository) -> AnyPublisher<UIImage?, Never>
  
  func loadRepoDate(repo: Repository) -> AnyPublisher<String?, Never>
  
  func searchRepos(query: String) -> AnyPublisher<Repositories, Error>
}

