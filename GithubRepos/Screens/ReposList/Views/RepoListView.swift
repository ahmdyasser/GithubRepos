//
//  RepoListView.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation
import UIKit

class RepoListView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Elements
   lazy var searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.tintColor = .label
    searchController.searchBar.searchTextField.accessibilityIdentifier = AccessibilityIdentifiers.RepositoryList.searchFieldID
    return searchController
  }()

  lazy var repoCollectionView: UICollectionView = {

    let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: createLayout()!)
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.register(RoundedCell.self, forCellWithReuseIdentifier: RoundedCell.reuseIdentifier)

    return collectionView
  }()

  func setupView() {
    addSubview(repoCollectionView)
  }

  func createLayout() -> UICollectionViewLayout? {

    let layout = UICollectionViewCompositionalLayout { _, environment in

      let itemsPerRow = environment.traitCollection.horizontalSizeClass == .compact ? 2 : 6
      let coverRatio: CGFloat = 2 / 3
      let widthRatio: CGFloat = 1 / CGFloat(itemsPerRow)
      let heightRatio = widthRatio / coverRatio

      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(widthRatio),
                                            heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      let inset = 2.5
      item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalWidth(heightRatio))

      item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

      let section = NSCollectionLayoutSection.init(group: group)

      return section
    }

    return layout
  }
}
