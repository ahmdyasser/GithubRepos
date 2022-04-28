//
//  RepoDetailViewModel.swift
//  GithubRepos
//
//  Created by Mostfa on 28/04/2022.
//

import Foundation
import Combine

final class RepoDetailViewModel: RepoDetailViewModelType {

  init(useCase: RepositoriesUseCaseType) {
    self.useCase = useCase
  }

  func transform(input: RepoDetailViewModelInput) -> RepoDetailViewModelOutput {

    return input.onAppear
      .flatMapLatest { repo in
        return self.useCase.repositoryDetails(repo)
      }
      .print()
      .map {
        DetailedRepoViewModel.init(createdAt: $0.createdAt,
                                   forksCount: $0.forksCount,
                                   watchersCount: $0.watchersCount ,
                                   openIssuesCount: $0.openIssuesCount,
                                   cover: self.useCase.loadRepoImage(repo: $0))
      }.map { RepoDetailState.success([$0])}
      .eraseToAnyPublisher()
  }

  private let useCase: RepositoriesUseCaseType
  private var cancellableBag: Set<AnyCancellable> = []

}
