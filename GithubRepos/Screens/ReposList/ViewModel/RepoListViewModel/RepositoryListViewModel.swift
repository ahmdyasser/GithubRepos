//
//  RepositoryListViewModel.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation
import Combine

final class RepositoryListViewModel: RepositoryListViewModelable {
  
  private weak var navigator: ReposListNavigator?
  private let useCase: RepositoriesUseCaseType
  private var cancellableBag: Set<AnyCancellable> = []
  private var pageNumber = 1
  
  
  init(useCase: RepositoriesUseCaseType,
       navigator: ReposListNavigator) {
    self.useCase = useCase
    self.navigator = navigator
  }
  
  
  func transform(input: RepositoryListViewModelInput) -> RepositoryListViewModelOutput {
    cancellableBag = []
    
    //On Repo selection
    input.onRepoSelection
      .sink { [weak self] repoID in
        self?.navigator?.showDetails(for: repoID)
      }.store(in: &cancellableBag)
    
    
    //in case onAppear was called multiple times(dismissal of presented vc)
    let repos = input.onAppear
      .flatMapLatest { self.useCase.fetchRepositories(page: 1).replaceError(with: []) }
      .map { repos -> RepositoryListState in
        RepositoryListState.success(self.viewModels(from: repos))
      }
    
    let searchInput = input.onSearch
      .removeDuplicates()
    
    let movies = searchInput
      .flatMapLatest({ query -> AnyPublisher<Repositories, Never> in
        if query == "" {
          return self.useCase.fetchRepositories(page: self.pageNumber).replaceError(with: []).eraseToAnyPublisher()
        }
        return self.useCase.searchRepos(query: query).replaceError(with: []).eraseToAnyPublisher()
      })
      .map({ result -> RepositoryListState in
        return.success(self.viewModels(from: result))
      })
    
    let pageRequest = input.onPageRequest
      .flatMapLatest { self.useCase.fetchRepositories(page: $0).replaceError(with: []) }.map { repos -> RepositoryListState in
        RepositoryListState.success(self.viewModels(from: repos))
      }
    
    
    
    return Publishers.Merge3(repos,movies, pageRequest).eraseToAnyPublisher()
  }
  
  
  
}

extension RepositoryListViewModel {
  func viewModels(from repos: Repositories) -> [RepoViewModel]  {
    repos.map {
      RepoViewModel.Builder.viewModel(from: $0) { repo in
        return self.useCase.loadRepoDate(repo: repo)
          .replaceError(with: "")
          .eraseToAnyPublisher()
        
      } imageLoader: { repo in
        return self.useCase.loadRepoImage(repo: repo)
        
      }
      
    }
    
  }
}
