//
//  ReposListNavigator.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation

protocol ReposListNavigator: AnyObject {
  /// Presents Repository details View.
  func showDetails(for repo: Int)
}
