//
//  RepoDetailView.swift
//  GithubRepos
//
//  Created by Mostfa on 28/04/2022.
//

import Foundation
import UIKit

class RepoDetailsView: UIView {

  let imageView: UIImageView = {

    let imageView = UIImageView.init()

    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false

    return imageView
  }()

  var stacksContainer: UIStackView?

  func configureUI() {
    addSubview(imageView)
    self.backgroundColor = .systemBackground

    let horizontalOffset: CGFloat = 0

    NSLayoutConstraint.activate([
      imageView.heightAnchor.constraint(equalToConstant: 150),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalOffset),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalOffset)
    ])

  }

  func makeRepoDetailRow(title: String = "", subtitle: String = "") -> UIView {

    let titleLabel = UILabel.init(frame: .zero)
    titleLabel.text = title

    let subTitleLabel = UILabel.init(frame: .zero)
    subTitleLabel.text = subtitle

    let stack = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])

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

}
