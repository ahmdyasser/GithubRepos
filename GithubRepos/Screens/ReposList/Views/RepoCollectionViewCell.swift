//
//  RepoCollectionViewCell.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Combine
import UIKit

class RoundedCell: UICollectionViewCell {
  static let reuseIdentifier = "RoundedCellReuseIdentifier"

  var imageLoader: ImageLoaderServiceType?
  var imageURL: String?
  var currentImageDownloader: AnyCancellable?
  var dateDownloader: AnyCancellable?
  var repoCellView: RoundedCellViewComponents = .init()

  // Inits
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
    round(radius: 8)
  }

  required init?(coder: NSCoder) {
    fatalError("Storyboards not supported.")
  }

  func configure() {
    contentView.backgroundColor = .systemGray6
    setupDetailsStack()
  }

  override func prepareForReuse() {
    cancelImageLoading()
  }

  func bind(to viewModel: RepoViewModel) {
    cancelImageLoading()
    repoCellView.title.text = viewModel.title
    repoCellView.subtitle.text = viewModel.ownerName
    currentImageDownloader = viewModel.cover.sink {image in self.showImage(image: image) }
    dateDownloader = viewModel.date.sink(receiveValue: { self.setDate(string: $0)})
  }

  private func setDate(string: String?) {
    DispatchQueue.main.async {
      //      self.cancelImageLoading()
      UIView.transition(with: self.repoCellView.date,
                        duration: 0.3,
                        options: [.curveEaseOut, .transitionCrossDissolve],
                        animations: {
        self.repoCellView.date.text = string
      })
    }

  }

  private func showImage(image: UIImage?) {
    DispatchQueue.main.async {
      self.cancelImageLoading()
      UIView.transition(with: self.repoCellView.thumbnailView,
                        duration: 0.3,
                        options: [.curveEaseOut, .transitionCrossDissolve],
                        animations: {
        self.repoCellView.thumbnailView.image = image
      })
    }

  }

  func cancelImageLoading() {
    repoCellView.thumbnailView.image = nil
    currentImageDownloader = nil
  }

}

extension RoundedCell {

  // MARK: - Cell Details Stacks
  private func setupDetailsStack() {
    // HSTACK
    let HStack = UIStackView(arrangedSubviews: [repoCellView.subtitle, repoCellView.date])
    HStack.distribution = .equalSpacing
    HStack.axis = .horizontal

    // VSTACK
    let VStack = UIStackView(arrangedSubviews: [repoCellView.title, HStack])
    VStack.setCustomSpacing(5, after: repoCellView.title)
    VStack.distribution = .equalSpacing
    VStack.axis = .vertical
    VStack.translatesAutoresizingMaskIntoConstraints = false
    VStack.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    VStack.isLayoutMarginsRelativeArrangement = true
    contentView.addSubview(repoCellView.thumbnailView)
    contentView.addSubview(VStack)
    repoCellView.thumbnailView.pin(to: contentView)

    let inset = CGFloat(0)

    NSLayoutConstraint.activate([
      VStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
      VStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
      VStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
    ])

    // VSTACK Background
    let stackBackground = UIView.init()
    stackBackground.translatesAutoresizingMaskIntoConstraints = false
    VStack.insertSubview(stackBackground, at: 0)
    stackBackground.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.7)
    stackBackground.pin(to: VStack)
  }
}

extension UICollectionViewCell {
  func round(radius: CGFloat) {
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = radius
    contentView.layer.cornerCurve = .continuous
  }

}
