//
//  RepoCollectionViewCell.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation
import Combine

import Combine
import UIKit


class RepoCell: UICollectionViewCell {
  static let reuseIdentifier = "RepoCellReuseIdentifier"
  
  let title: UILabel = {
    let title = UILabel.init()
    title.adjustsFontForContentSizeCategory = true
    title.numberOfLines = 0
    title.lineBreakMode = .byWordWrapping
    title.textAlignment = .left
    title.font = .systemFont(ofSize: 13, weight: .semibold)
    
    return title
  }()
  
  let subtitle = UILabel()
  let date = UILabel()
  var thumbnailView: UIImageView = {
    return .init()
  }()
  var imageLoader: ImageLoaderServiceType?
  var imageURL: String?
  var currentImageDownloader: AnyCancellable?
  var dateDownloader: AnyCancellable?
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  override func prepareForReuse() {
    cancelImageLoading()
  }
  
  func bind(to viewModel: RepoViewModel) {
    cancelImageLoading()
    title.text = viewModel.title
    subtitle.text = viewModel.ownerName
    currentImageDownloader = viewModel.cover.sink {image in self.showImage(image: image) }
    dateDownloader = viewModel.date.sink(receiveValue: { self.setDate(string: $0)})
  }
  
  required init?(coder: NSCoder) {
    fatalError("Storyboards not supported.")
  }
  
  private func setDate(string: String?) {
    DispatchQueue.main.async {
      //      self.cancelImageLoading()
      UIView.transition(with: self.date,
                        duration: 0.3,
                        options: [.curveEaseOut, .transitionCrossDissolve],
                        animations: {
        self.date.text = string
      })
    }
    
  }
  
  private func showImage(image: UIImage?) {
    DispatchQueue.main.async {
      self.cancelImageLoading()
      UIView.transition(with: self.thumbnailView,
                        duration: 0.3,
                        options: [.curveEaseOut, .transitionCrossDissolve],
                        animations: {
        self.thumbnailView.image = image
      })
    }
    
  }
  
  func cancelImageLoading() {
    thumbnailView.image = nil
    currentImageDownloader = nil
  }
  
  
}

extension RepoCell {
  
  func configure() {
    
    
    
    
    subtitle.adjustsFontForContentSizeCategory = true
    subtitle.numberOfLines = 0
    subtitle.lineBreakMode = .byWordWrapping
    subtitle.textAlignment = .left
    subtitle.font = .systemFont(ofSize: 9, weight: .bold)
    
    
    date.adjustsFontForContentSizeCategory = true
    date.numberOfLines = 0
    date.lineBreakMode = .byWordWrapping
    date.textAlignment = .left
    date.font = .systemFont(ofSize: 9, weight: .bold)
    
    
    contentView.backgroundColor = .systemGray6
    
    date.translatesAutoresizingMaskIntoConstraints = false
    subtitle.translatesAutoresizingMaskIntoConstraints = false
    title.translatesAutoresizingMaskIntoConstraints = false
    thumbnailView.translatesAutoresizingMaskIntoConstraints = false
    
    
    selectedBackgroundView = UIView()
    
    let HStack = UIStackView(arrangedSubviews: [subtitle, date])
    HStack.distribution = .equalSpacing
    HStack.axis = .horizontal
    
    
    let VStack = UIStackView(arrangedSubviews: [title, HStack])
    VStack.setCustomSpacing(5, after: title)
    VStack.distribution = .equalSpacing
    VStack.axis = .vertical
    VStack.translatesAutoresizingMaskIntoConstraints = false
    VStack.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    VStack.isLayoutMarginsRelativeArrangement = true
    contentView.addSubview(thumbnailView)
    contentView.addSubview(VStack)
    
    
    
    
    
    
    
    
    let inset = CGFloat(0)
    
    thumbnailView.pin(to: contentView)
    
    NSLayoutConstraint.activate([
      VStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:  inset),
      VStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant:  -inset),
      VStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant:  -inset)
    ])
    
    let v = UIView.init()
    v.translatesAutoresizingMaskIntoConstraints = false
    VStack.insertSubview(v, at: 0)
    v.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.7)
    v.pin(to: VStack)
    
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = 4.0
    contentView.layer.cornerCurve = .continuous
    
    
  }
}
