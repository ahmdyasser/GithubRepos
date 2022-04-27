//
//  ReposListFlowCoordinator.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation
import UIKit

/// The `ReposListFlowCoordinator` takes control over the form Repos List screen.

class ReposListFlowCoordinator: FlowCoordinator {
  fileprivate let window: UIWindow
  fileprivate var reposNavigationController: UINavigationController?
  fileprivate let dependencyProvider: GitHubReposFlowCoordinatorDependencyProvider
  
  init(window: UIWindow, dependencyProvider: GitHubReposFlowCoordinatorDependencyProvider) {
    self.window = window
    self.dependencyProvider = dependencyProvider
  }
  
  func start() {
    let reposNavigationController = dependencyProvider.reposListNavigationController(navigator: self)
    window.rootViewController = reposNavigationController
    self.reposNavigationController = reposNavigationController
  }
}

extension ReposListFlowCoordinator: ReposNavigator {
  
  func showDetails(for repo: Int) {
    
  }
  
}
