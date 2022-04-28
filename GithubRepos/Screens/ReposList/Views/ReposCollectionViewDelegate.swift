//
//  ReposCollectionViewDelegate.swift
//  GithubRepos
//
//  Created by Mostfa on 28/04/2022.
//

import UIKit
import Combine
class ReposCollectionViewDelegate: NSObject, UICollectionViewDelegate {

  private weak var onPageRequest: PassthroughSubject<Void, Never>?

  init(_ onPageRequest: PassthroughSubject<Void, Never>) {
    self.onPageRequest = onPageRequest
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    if let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) {
      if indexPath.row == dataSourceCount - 3 {
        onPageRequest?.send()

      }
    }
  }
}
