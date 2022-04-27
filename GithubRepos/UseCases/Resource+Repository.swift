//
//  Resource+Repository.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation

extension Resource {
  
  static func repositories() -> Resource {
    let url = GHContants.baseUrl.appendingPathComponent("/repositories")
    let parameters: [String : CustomStringConvertible] = [:]
    return Resource(url: url, parameters: parameters)
  }
  
  static func details(repoURL: String) -> Resource? {
    ///RepoURL is usually passed from backend Response, so it's safer to leave it optional, in case backend response was messed up :)
    guard let url = URL.init(string: repoURL) else {
      return nil
    }
    return Resource(url: url, parameters: [:])
  }
  
  static func repoDate(repoURL: String) -> Resource? {
    ///RepoURL is usually passed from backend Response, so it's safer to leave it optional, in case backend response was messed up :)
    guard let url = URL.init(string: repoURL) else {
      return nil
    }
    return Resource(url: url, parameters: [:])
  }
}
