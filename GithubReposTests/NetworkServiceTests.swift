//
//  NetworkServiceTests.swift
//  GithubReposTests
//
//  Created by Mostfa on 28/04/2022.
//

import Foundation
import XCTest
import Combine

@testable import GithubRepos

class NetworkServiceTests: XCTestCase {

  private lazy var session: URLSession = {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [URLProtocolMock.self]
    return URLSession(configuration: config)
  }()

  private let resource = Resource<Repositories>.repositories()

  private lazy var networkService = NetworkService(session: session)

  private var cancellableBag: [AnyCancellable] = []

  private lazy var reposData: Data = {
    let url = Bundle(for: NetworkServiceTests.self).url(forResource: "repos", withExtension: "json")
    guard let resourceUrl = url, let data = try? Data(contentsOf: resourceUrl) else {
      XCTFail("Failed to use Resource")
      return Data()
    }
    return data
  }()

  override class func setUp() {
    URLProtocol.registerClass(URLProtocolMock.self)
  }

  func test_loadFinishedSuccessfully() {
    // Given
    var fetchedRepos: Repositories = []
    let expectation = self.expectation(description: "Network Service Expections")

    // Mocking Response
    URLProtocolMock.requestHandler = { _ in
      let response = HTTPURLResponse(url: self.resource.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, self.reposData)
    }

    // When
    networkService.load(resource)
      .catch({ _ -> AnyPublisher<Repositories, Never> in .empty() })
        .sink(receiveValue: { value in
          fetchedRepos = value
          expectation.fulfill()
        }).store(in: &cancellableBag)

              // Then
              self.waitForExpectations(timeout: 1.0, handler: nil)

              XCTAssertEqual(fetchedRepos.count, 100)
  }

  func test_loadFailedWithJsonParsingError() {
    // Given
    let expectation = self.expectation(description: "Network Parsing Error")

    URLProtocolMock.requestHandler = { _ in
      let response = HTTPURLResponse(url: self.resource.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, Data()) // <notice, wrong data is returned.
    }

    // When
    networkService.load(resource)
      .sink { completion in
        switch completion {

        case .finished:
          XCTFail("This publisher should fail, instead of finishing")
        case .failure(let error):
          guard error is DecodingError else { return XCTFail("Returned Error Isn't Correct.") }
          expectation.fulfill()

        }
      } receiveValue: { _ in
        return
      }.store(in: &cancellableBag)

    // Then
    self.waitForExpectations(timeout: 1.0, handler: nil)

  }

}
