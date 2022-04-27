//
//  FlowCoordinatorDependencyProviders.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import UIKit.UINavigationController

/// The `ApplicationFlowCoordinatorDependencyProvider` protocol defines methods to satisfy external dependencies of the ApplicationFlowCoordinator
protocol ApplicationFlowCoordinatorDependencyProvider: GitHubReposFlowCoordinatorDependencyProvider {}

protocol GitHubReposFlowCoordinatorDependencyProvider: AnyObject {
  /// Creates a controller list all repos.
  func reposListNavigationController(navigator: ReposNavigator)  -> UINavigationController
  
  // Creates UIViewController to show the details of a repo with specified identifier
  func repoDetailController(_ repoID: Int) -> UIViewController
}

