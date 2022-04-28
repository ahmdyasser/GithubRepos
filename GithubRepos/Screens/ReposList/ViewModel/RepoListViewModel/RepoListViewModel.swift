//
//  RepoListViewModel.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation
import Combine

final class RepoListViewModel: RepositoryListViewModelable {

  private weak var navigator: ReposListNavigator?
  private let useCase: RepositoriesUseCaseType
  private var cancellableBag: Set<AnyCancellable> = []
  private var pageNumber = 1
  private var repos: Repositories = []

  init(useCase: RepositoriesUseCaseType,
       navigator: ReposListNavigator) {
    self.useCase = useCase
    self.navigator = navigator
  }

  func transform(input: RepositoryListViewModelInput) -> RepositoryListViewModelOutput {
    cancellableBag = []

    // MARK: - On Repo selection
    input.onRepoSelection
      .sink { [weak self] repoIndex in
        guard let self = self else { return }
        guard repoIndex <= self.repos.count else { return assertionFailure("Trying to access wrong index")}

        let repo = self.repos[repoIndex]
        self.navigator?.showDetails(for: repo)
      }.store(in: &cancellableBag)

    // in case onAppear was called multiple times(dismissal of presented vc)
    let repos = input.onAppear
      .flatMapLatest { self.fetchReposFor(page: self.pageNumber) }
      .map { repos -> RepositoryListState in
        RepositoryListState.success(self.viewModels(from: repos))
      }

    let searchInput = input.onSearch
      .removeDuplicates()

    // MARK: - Search Handling

    let filteredRepos = searchInput
      .flatMapLatest({ query -> AnyPublisher<Repositories, Never> in
        return self.filterRepos(query: query)
      })
      .map({ result -> RepositoryListState in
        return.success(self.viewModels(from: result))
      })

    // MARK: - Pagination Handling

    let pageRequest = input.onPageRequest
      .handleEvents(receiveOutput: { self.pageNumber += 1 })
      .flatMapLatest { self.fetchReposFor(page: self.pageNumber).replaceError(with: []) }.map { repos -> RepositoryListState in
        RepositoryListState.success(self.viewModels(from: repos))
      }

    return Publishers.Merge3(repos, filteredRepos, pageRequest).eraseToAnyPublisher()
  }

}

extension RepoListViewModel {
  func viewModels(from repos: Repositories) -> [RepoViewModel] {
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

  private func fetchReposFor(page index: Int) -> AnyPublisher<Repositories, Never> {
    return self.useCase.fetchRepositories(page: self.pageNumber)
      .handleEvents(receiveOutput: {
        self.repos = $0
      })
      .replaceError(with: [])
      .eraseToAnyPublisher()
  }
  private func filterRepos(query: String) -> AnyPublisher<Repositories, Never> {

    if query == "" {
      return self.useCase.fetchRepositories(page: self.pageNumber).replaceError(with: []).eraseToAnyPublisher()
    }
    guard query.count >= 2 else { return .empty() }
    return self.repos
      .publisher
      .filter { repo in
        return repo.name.lowercased().matching(query: query.lowercased())
      }
      .collect()
      .eraseToAnyPublisher()

  }

}
