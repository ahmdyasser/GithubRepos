//
//  ShadowView.swift
//  GithubRepos
//
//  Created by Mostfa on 28/04/2022.
//

import Foundation
import UIKit

class ShadowView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.isOpaque = true
    self.backgroundColor = .black
    self.dropShadow()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func dropShadow() {
    self.layer.masksToBounds = false
    self.layer.cornerRadius = 15
    self.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
    self.layer.shadowOffset = CGSize(width: 3, height: 3)
    self.layer.shadowOpacity = 0.3
    self.layer.shadowRadius = 5
  }
}
