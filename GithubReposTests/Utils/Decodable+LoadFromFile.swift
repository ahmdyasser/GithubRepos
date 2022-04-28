//
//  LoadFromFile.swift
//  GithubReposTests
//
//  Created by Mostfa on 28/04/2022.
//

import Foundation
@testable import GithubRepos

extension Decodable {
  static func loadFromFile(_ filename: String) -> Self {
    do {
      let path = Bundle(for: GithubReposTests.self).path(forResource: filename, ofType: nil)!
      let data = try Data(contentsOf: URL(fileURLWithPath: path))
      return try JSONDecoder().decode(Self.self, from: data)
    } catch {
      fatalError("Error: \(error)")
    }
  }
}
