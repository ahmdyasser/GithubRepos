//
//  ApplicationComponentsFactory.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import UIKit

/// The ApplicationComponentsFactory .
final class ApplicationComponentsFactory {

  fileprivate lazy var useCase: RepositoriesUseCase = RepositoriesUseCase.init(networkService: servicesProvider.network, imageLoaderService: servicesProvider.imageLoader)

  private let servicesProvider: ServicesProvider

  init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider) {
    self.servicesProvider = servicesProvider
  }
}

extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {

  func reposListNavigationController(navigator: ReposListNavigator) -> UINavigationController {
    let reposListVC = ReposListViewController.init(viewModel: RepoListViewModel.init(useCase: useCase,
                                                                                           navigator: navigator))

    let navigationController = UINavigationController(rootViewController: reposListVC)

    navigationController.navigationBar.tintColor = .label
    return navigationController
  }

  func repoDetailController(_ repoID: Int) -> UIViewController {
    assertionFailure("Needs Implementation")
    return .init()
  }

}
