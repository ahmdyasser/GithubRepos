//
//  GHContants.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation
import Keys

struct GHContants {
  static let apiKey = GithubReposKeys().gitHubPersonalToken
  static let baseUrl = URL(string: "https://api.github.com")!
}
