//
//  ReposListViewModelInput.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation
import Combine

protocol  RepositoryListViewModelable {
  func transform(input: RepositoryListViewModelInput) ->  RepositoryListViewModelOutput
}

typealias RepositoryListViewModelOutput = AnyPublisher<RepositoryListState, Never>

struct RepositoryListViewModelInput {
  /// called when a screen becomes visible
  let onAppear: AnyPublisher<Void, Never>
  // triggered when the search query is updated
  let onSearch: AnyPublisher<String, Never>
  /// called when the user selected an item from the list
  let onRepoSelection: AnyPublisher<Int, Never>
  
  let onPageRequest: AnyPublisher<Int, Never>
  
}

enum RepositoryListState {
  case loading
  case success([RepoViewModel])
  case noResults
  case failure(Error)
}
