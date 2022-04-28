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
    // hStack
    let hStack = UIStackView(arrangedSubviews: [repoCellView.subtitle, repoCellView.date])
    hStack.distribution = .equalSpacing
    hStack.axis = .horizontal

    // vStack
    let vStack = UIStackView(arrangedSubviews: [repoCellView.title, hStack])
    vStack.setCustomSpacing(5, after: repoCellView.title)
    vStack.distribution = .equalSpacing
    vStack.axis = .vertical
    vStack.translatesAutoresizingMaskIntoConstraints = false
    vStack.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    vStack.isLayoutMarginsRelativeArrangement = true
    contentView.addSubview(repoCellView.thumbnailView)
    contentView.addSubview(vStack)
    repoCellView.thumbnailView.pin(to: contentView)

    let inset = CGFloat(0)

    NSLayoutConstraint.activate([
      vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
      vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
      vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
    ])

    // vStack Background
    let stackBackground = UIView.init()
    stackBackground.translatesAutoresizingMaskIntoConstraints = false
    vStack.insertSubview(stackBackground, at: 0)
    stackBackground.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.7)
    stackBackground.pin(to: vStack)
  }
}

extension UICollectionViewCell {
  func round(radius: CGFloat) {
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = radius
    contentView.layer.cornerCurve = .continuous
  }

}
