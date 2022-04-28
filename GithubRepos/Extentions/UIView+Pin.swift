//
//  UIView+Pin.swift
//  GithubRepos
//
//  Created by Mostfa on 28/04/2022.
//

import Foundation
import UIKit

public extension UIView {

  func pin(to view: UIView) {
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: view.leadingAnchor),
      trailingAnchor.constraint(equalTo: view.trailingAnchor),
      topAnchor.constraint(equalTo: view.topAnchor),
      bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}
