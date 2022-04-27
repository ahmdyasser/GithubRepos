//
//  RepositoriesUseCase.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation
import Combine
import UIKit.UIImage

final class RepositoriesUseCase: RepositoriesUseCaseType {
  
  private let imageLoaderService: ImageLoaderServiceType
  private let networkService: NetworkServiceType
  
  ///fetchedRepos added  to be able later to simulate pagination since it's not supported by the API
  private var fetchedRepos: Repositories = []

  init(networkService: NetworkServiceType = NetworkService(),
       imageLoaderService: ImageLoaderServiceType = ImageLoaderService()) {
    self.imageLoaderService = imageLoaderService
    self.networkService = networkService
  }
  
  
  //MARK: - RepositoriesUseCaseType Confirmation

  func fetchRepositories(page: Int = 1) -> AnyPublisher<Repositories, Error> {
    guard fetchedRepos.isEmpty else { return preFetchedRepositories(at: page) }
    
    return networkService
      .load(Resource<Repositories>.repositories())
      .subscribe(on: Scheduler.backgroundWorkScheduler)
      .receive(on: Scheduler.mainScheduler)
      .handleEvents(receiveOutput: { repos in
        self.fetchedRepos = repos
      })
      .flatMap { $0.publisher.setFailureType(to: Error.self) }
      .collect(page * 10)
      .first()
      .eraseToAnyPublisher()
  }
  
  func repositoryDetails(_ repo: Repository) -> AnyPublisher<Repository, Error> {
    return networkService
      .load(Resource<Repository>.details(repoURL: repo.owner.url))
      .subscribe(on: Scheduler.backgroundWorkScheduler)
      .receive(on: Scheduler.mainScheduler)
      .eraseToAnyPublisher()
  }
  
  
  func loadRepoImage(repo: Repository) -> AnyPublisher<UIImage?, Never> {
    guard let url = URL.init(string: repo.owner.avatarURL) else {
      return .empty()
    }
    return self.imageLoaderService.loadImage(from: url).eraseToAnyPublisher()
  }
  
  func searchRepos(query: String) -> AnyPublisher<Repositories, Error> {
    fetchedRepos
      .publisher
      .filter { repo in
        return repo.name.contains(query.lowercased())
      }
      .collect()
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
  
  func loadRepoDate(repo: Repository) -> AnyPublisher<String?, Never> {
    return networkService
      .load(Resource<RepoDetail>.repoDate(repoURL: repo.owner.url))
      .compactMap { $0.createdAt }
      .compactMap { DateFormatter.compactDate($0) }
      .mapError({ error -> Error in
        print(error)
        return error
      })
      .replaceError(with: "-")
      .eraseToAnyPublisher()
  }
  
}


extension RepositoriesUseCase {
  
  /// Used to simulate pagination using the already fetched results.
  /// - Parameter page: page index, starts with 1
  /// - Returns: Repositories from index 0 to index (page * 10)
  private func preFetchedRepositories(at page: Int) -> AnyPublisher<Repositories, Error> {
    guard page > 0 else {
      assertionFailure("page index can't be zero, and can't be minus value, current page index is \(page)")
      return .empty()}
    let reposCount =  10 * page
    guard reposCount <= fetchedRepos.count - 1 else {
      return .just(fetchedRepos)
    }
    return fetchedRepos[0 ..< ((10 * page))]
      .publisher
      .collect()
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
    
  }
}
