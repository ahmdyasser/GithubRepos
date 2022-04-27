//
//  ApplicationComponentsFactory.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import UIKit

/// The ApplicationComponentsFactory .
final class ApplicationComponentsFactory {
  
  private let servicesProvider: ServicesProvider

  init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider) {
    self.servicesProvider = servicesProvider
  }
}

extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {
  
  func reposListNavigationController(navigator: ReposNavigator) -> UINavigationController {
    let reposListVC = ReposListViewController.init()
    
    let navigationController = UINavigationController(rootViewController: reposListVC)
    
    navigationController.navigationBar.tintColor = .label
    return navigationController
  }
  
  func repoDetailController(_ repoID: Int) -> UIViewController {
    assertionFailure("Needs Implementation")
    return .init()
  }
  

}
