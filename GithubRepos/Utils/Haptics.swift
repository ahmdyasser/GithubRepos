//
//  Haptics.swift
//  GithubRepos
//
//  Created by Mostfa Essam on 16/03/2022.
//  Copyright © 2022 Esraa Eid. All rights reserved.
//

import Foundation
import UIKit

class Haptics {

  static func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
  }

  static func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
  }
}
