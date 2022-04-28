//
//  RepoDetailViewModelType.swift
//  GithubRepos
//
//  Created by Mostfa on 28/04/2022.
//

import Foundation
import Combine

protocol  RepoDetailViewModelType {
  func transform(input: RepoDetailViewModelInput) -> RepoDetailViewModelOutput
}

typealias RepoDetailViewModelOutput = AnyPublisher<RepoDetailState, Error>

struct RepoDetailViewModelInput {
  /// called when a screen becomes visible, with the repository of this screen
  let onAppear: AnyPublisher<Repository, Error>

}

enum RepoDetailState {
  case loading
  case success(RepoDetailViewModelDTO)
}
