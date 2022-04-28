//
//  ReposUseCase.swift
//  GithubReposTests
//
//  Created by Mostfa on 28/04/2022.
//

import Foundation
import XCTest
import Combine
@testable import GithubRepos

class ReposUseCaseTests: XCTestCase {
  private let networkService = MockedNetworkService()
  private let imageLoaderMocked = ImageLoaderMocked.init()
  private var useCase: RepositoriesUseCase!
  private var cancellableBag: [AnyCancellable] = []

  override func setUp() {
    useCase = .init(networkService: networkService,
                    imageLoaderService: imageLoaderMocked)

  }

  func test_FetchRepositoriesPagination() {
    // Given
    var result: Repositories = []
    let expectation = self.expectation(description: "Repositories Fetching, at page 20")
    let repos = Repositories.loadFromFile("repos.json")
    networkService.responses["/repositories"] = repos

    // When
    useCase.fetchRepositories(page: 2)
      .replaceError(with: [])
      .sink { value in
        result = value
        if value.count >= 20 {
          expectation.fulfill()
        }
      }.store(in: &cancellableBag)

    // Then
    self.waitForExpectations(timeout: 1.0, handler: nil)
    guard result.count == 20 else {
      return XCTFail("Didn't Get the result")
    }
  }

  func test_FetchRepositoriesSucceeds() {
    // Given
    var result: Repositories = []
    let expectation = self.expectation(description: "Repositories Fetching")
    let repos = Repositories.loadFromFile("repos.json")
    networkService.responses["/repositories"] = repos

    // When
    useCase.fetchRepositories()
      .replaceError(with: [])
      .sink { value in
      result = value
        if value.count >= 10 {
          expectation.fulfill()
        }
    }.store(in: &cancellableBag)

    // Then
    self.waitForExpectations(timeout: 1.0, handler: nil)
    guard result.count >= 0 else {
      return XCTFail("Didn't Get the result")
    }

  }

}
