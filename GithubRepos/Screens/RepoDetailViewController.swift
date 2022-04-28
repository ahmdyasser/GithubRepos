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

  let imageView: UIImageView = .init()

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
    configureUI()
    self.view.backgroundColor = .systemBackground

  }

  func configureUI() {
    view.addSubview(imageView)
    imageView.backgroundColor = .green
    imageView.translatesAutoresizingMaskIntoConstraints = false

    let firstRow = makeRepoDetailRow()
    let secondRow = makeRepoDetailRow()
    let thirdRow = makeRepoDetailRow()

    let stackContainer = UIStackView.init(arrangedSubviews: [firstRow, secondRow, thirdRow])
    stackContainer.setCustomSpacing(10, after: firstRow)
    stackContainer.setCustomSpacing(10, after: secondRow)
    stackContainer.setCustomSpacing(10, after: thirdRow)

    stackContainer.axis = .vertical

    view.addSubview(stackContainer)
    stackContainer.translatesAutoresizingMaskIntoConstraints = false

    let topOffset: CGFloat = 10
    let horizontalOffset: CGFloat = 0

    let margins = view.layoutMarginsGuide

    NSLayoutConstraint.activate([
      stackContainer.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: topOffset),
      stackContainer.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
      stackContainer.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),

      imageView.heightAnchor.constraint(equalToConstant: 150),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalOffset),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalOffset)
    ])

  }
  func makeRepoDetailRow() -> UIView {
    let topOffset: CGFloat = 10
    let label = UILabel.init(frame: .zero)
    label.text = "Hello"
    let label2 = UILabel.init(frame: .zero)
    label2.text = "409"
    let stack = UIStackView(arrangedSubviews: [label, label2])
    stack.axis = .horizontal
    stack.distribution = .fill
    stack.spacing = 8
    let backgroundV = ShadowView.init()
    backgroundV.backgroundColor = .systemBackground
    backgroundV.translatesAutoresizingMaskIntoConstraints = false
    stack.insertSubview(backgroundV, at: 0)
    backgroundV.pin(to: stack)

    stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    stack.isLayoutMarginsRelativeArrangement = true

    return stack
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
      }
    }.store(in: &cancellableBag)
  }

  func loadImage(imagePublisher: AnyPublisher<UIImage?, Never>) {
    imagePublisher.sink { image in
      self.imageView.image = image
      self.imageView.contentMode = .scaleAspectFill
      self.imageView.clipsToBounds = true

    }.store(in: &self.cancellableBag)
  }

}
