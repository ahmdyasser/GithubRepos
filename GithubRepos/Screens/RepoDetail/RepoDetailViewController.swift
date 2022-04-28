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
  private let repoDetailsView: RepoDetailsView = .init()

  init(repo: Repository, viewModel: RepoDetailViewModelType) {
    self.viewModel = viewModel
    self.repo = repo
    super.init(nibName: nil, bundle: nil)
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    guard let stacksContainer = repoDetailsView.stacksContainer else {
      return
    }
    stacksContainer.axis = stacksContainer.axis == .vertical ? .horizontal: .vertical
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = repoDetailsView
  }
  // MARK: - View Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    bind(to: viewModel)
    onAppear.send(repo)
    repoDetailsView.configureUI()
  }

  private func bind(to viewModel: RepoDetailViewModelType) {
    cancellableBag.forEach { $0.cancel() }
    cancellableBag.removeAll()

    let input = RepoDetailViewModelInput.init(onAppear: self.onAppear
      .eraseToAnyPublisher())

    let output = viewModel.transform(input: input)

    output.sink(receiveCompletion: { _ in }) { newState in
      print(newState)
      switch newState {

      case .loading:
        return
      case .success(let result):
        self.loadImage(imagePublisher: result.cover)
        self.makeDetailsStack(result)
      }
    }.store(in: &cancellableBag)
  }

  func loadImage(imagePublisher: AnyPublisher<UIImage?, Never>) {
    imagePublisher.sink { image in
      DispatchQueue.main.async {
        self.repoDetailsView.imageView.image = image
      }
    }.store(in: &self.cancellableBag)
  }

}
extension RepoDetailViewController {

  func makeDetailsStack(_ repo: RepoDetailViewModelDTO) {
    let topOffset: CGFloat = 10

    let forksRow = repoDetailsView.makeRepoDetailRow(title: "Forks", subtitle: "\(repo.forksCount)")
    let watchersRow = repoDetailsView.makeRepoDetailRow(title: "Watchers", subtitle: "\(repo.watchersCount)")
    let openIssuesRow = repoDetailsView.makeRepoDetailRow(title: "Open Issues", subtitle: "\(repo.openIssuesCount)")
    let nameRow = repoDetailsView.makeRepoDetailRow(title: "Name", subtitle: "\(repo.name)")

    let stackContainer = UIStackView.init(arrangedSubviews: [nameRow, watchersRow, openIssuesRow, forksRow])
    stackContainer.setCustomSpacing(10, after: nameRow)
    stackContainer.setCustomSpacing(10, after: watchersRow)
    stackContainer.setCustomSpacing(10, after: openIssuesRow)
    stackContainer.translatesAutoresizingMaskIntoConstraints = false
    repoDetailsView.stacksContainer = stackContainer
    stackContainer.axis = .vertical
    view.addSubview(stackContainer)
    let margins = view.layoutMarginsGuide

    NSLayoutConstraint.activate([
      stackContainer.topAnchor.constraint(equalTo: repoDetailsView.imageView.bottomAnchor, constant: topOffset),
      stackContainer.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
      stackContainer.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0) ])
  }
}
