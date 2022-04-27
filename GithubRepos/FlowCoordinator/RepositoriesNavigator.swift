//
//  ReposNavigator.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation


protocol ReposNavigator: AnyObject {
  /// Presents Repository details View.
  func showDetails(for repo: Int)
}
