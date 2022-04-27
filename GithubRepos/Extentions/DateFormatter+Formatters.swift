//
//  DateFormatter+Formatters.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation

extension DateFormatter {
  
  static let gitHubDateForamtter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    return df
  }()
  
  static let compactDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeStyle = .none
    return df
  }()
  
  static func compactDate(_ dateString: String) -> String? {
    
    guard let date = gitHubDateForamtter.date(from: dateString) else {
      assertionFailure("Trying to convert a date \(dateString) which not matching \(String(describing: gitHubDateForamtter.dateFormat))")
      return nil
    }
    
    return compactDateFormatter.string(from: date)
  }
}
