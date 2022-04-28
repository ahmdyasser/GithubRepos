//
//  RepoDetailViewController.swift
//  GithubRepos
//
//  Created by Mostfa on 28/04/2022.
//

import Combine
import UIKit

class RepoDetailViewController: UIViewController {

  // MARK: - Initialiser
  private var viewModel: RepoDetailViewModelType
  private let onAppear = PassthroughSubject<Repository, Error>()
  private var cancellableBag: [AnyCancellable] = []
  private let repo: Repository

  init(repo: Repository, viewModel: RepoDetailViewModelType) {
    self.viewModel = viewModel
    self.repo = repo
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    bind(to: viewModel)
    onAppear.send(repo)

  }

  private func bind(to viewModel: RepoDetailViewModelType) {
    cancellableBag.forEach { $0.cancel() }
    cancellableBag.removeAll()

    let input = RepoDetailViewModelInput.init(onAppear: self.onAppear
      .eraseToAnyPublisher())

    let output = viewModel.transform(input: input)

    output.sink(receiveCompletion: { _ in }) { newState in
      print(newState)
    }.store(in: &cancellableBag)
  }

}
