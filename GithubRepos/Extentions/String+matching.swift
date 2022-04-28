//
//  String+Matching.swift
//  GithubRepos
//
//  Created by Mostfa on 28/04/2022.
//

import Foundation


extension String {
  
  /// Used to match a string with other one, works as the following
  /// if the query: "123" and receiver is "145623", will return true, because 1, 2, 3 are contained in "145623"
  /// - Parameter query: a string we are searching for inside a string
  /// - Parameter threshold: number of chars that have to be exist in the receiver, default to 2
  /// - Returns: boolean value to indicate if there's a match or not
  func matching(query: String, threshold: Int = 2, optimized: Bool = true)-> Bool {
    optimized ? optimizedMatching(query: query,threshold: threshold):
    matching(query: query,threshold: threshold)
  }
  
  private func optimizedMatching(query: String, threshold: Int = 2)-> Bool {
    var dict: [Character:Bool] = [:]
    var charsCount = 0

    ///Time Complexity: O(N) + O(M) = O(M) where M is number of chars in a string, assuming that N the number of chars in a query is going to be less than M
    ///Space Complexity: O(M), taken by dict
    self.forEach { dict[$0] = true }
    
    for char in query {
      if dict[char] != nil {
        charsCount += 1
        if charsCount >= threshold { return true }
      }
    }
    
    return false
  }
  
  private func matching(query: String, threshold: Int = 2) -> Bool {
    ///O(M*N), time complexity where M is number of chars in query, N is the number of chars in Self.
    var charsCount = 0
    for c in query {
      if self.contains(c) { charsCount += 1}
      if charsCount >= threshold { return true }
    }
    return false
  }
  
}
