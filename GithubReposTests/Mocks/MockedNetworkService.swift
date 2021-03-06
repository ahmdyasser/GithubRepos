//
//  MockedNetworkService.swift
//  GithubReposTests
//
//  Created by Mostfa on 28/04/2022.
//

import Foundation
import XCTest
import Combine
@testable import GithubRepos

class MockedNetworkService: NetworkServiceType {

  var loadCallsCount = 0
  var loadCalled: Bool {
    return loadCallsCount > 0
  }
  var responses = [String: Any]()

  func load<T>(_ resource: Resource<T>?) -> AnyPublisher<T, Error> {
    if let response = responses[resource?.url.path ?? ""] as? T {
      return .just(response)
    } else if let error = responses[resource?.url.path ?? ""] as? NetworkError {
      return .fail(error)
    } else {
      return .fail(NetworkError.invalidRequest)
    }
  }
}
