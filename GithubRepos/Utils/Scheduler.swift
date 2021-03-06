//
//  Scheduler.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation

/// Used as a namespace
enum Scheduler {

  static var backgroundWorkScheduler: OperationQueue = {
    let operationQueue = OperationQueue()
    operationQueue.maxConcurrentOperationCount = 20
    operationQueue.qualityOfService = QualityOfService.userInitiated
    return operationQueue
  }()

  static let mainScheduler = RunLoop.main

}
