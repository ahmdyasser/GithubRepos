//
//  RoundedCellViewComponents.swift
//  GithubRepos
//
//  Created by Mostfa on 28/04/2022.
//

import UIKit

struct RoundedCellViewComponents {
  let title: UILabel = {
    let title = UILabel.init()
    title.adjustsFontForContentSizeCategory = true
    title.translatesAutoresizingMaskIntoConstraints = false
    title.numberOfLines = 0
    title.lineBreakMode = .byWordWrapping
    title.textAlignment = .left
    title.font = .systemFont(ofSize: 13, weight: .semibold)

    return title
  }()

  let subtitle: UILabel = {
    let subtitle = UILabel()
    subtitle.adjustsFontForContentSizeCategory = true
    subtitle.translatesAutoresizingMaskIntoConstraints = false
    subtitle.numberOfLines = 0
    subtitle.lineBreakMode = .byWordWrapping
    subtitle.textAlignment = .left
    subtitle.font = .systemFont(ofSize: 9, weight: .bold)
    return subtitle
  }()

  let date: UILabel = {
    let date = UILabel()
    date.adjustsFontForContentSizeCategory = true
    date.translatesAutoresizingMaskIntoConstraints = false
    date.numberOfLines = 0
    date.lineBreakMode = .byWordWrapping
    date.textAlignment = .left
    date.font = .systemFont(ofSize: 9, weight: .bold)
    return date
  }()

  var thumbnailView: UIImageView = {
    let imageView = UIImageView.init()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
}
