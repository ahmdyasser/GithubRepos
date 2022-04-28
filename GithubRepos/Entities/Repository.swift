//
//  Repository.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import Foundation

/// Repository represents a single GH Repository.
struct Repository: Codable, Hashable, Identifiable {
  let id: Int
  let nodeID, name, fullName: String
  let owner: Owner
  let url: String
  let createdAt: String?

  enum CodingKeys: String, CodingKey {
    case id
    case nodeID = "node_id"
    case name
    case fullName = "full_name"
    case owner, url
    case createdAt = "created_at"
  }
}

extension Repository {
  // MARK: - Owner
  struct Owner: Codable, Hashable, Identifiable {
    let id: Int
    let nodeID: String
    let avatarURL: String
    let login: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
      case login, id
      case nodeID = "node_id"
      case avatarURL = "avatar_url"
      case gravatarID = "gravatar_id"
      case url
      case htmlURL = "html_url"
      case followersURL = "followers_url"
      case followingURL = "following_url"
      case gistsURL = "gists_url"
      case starredURL = "starred_url"
      case subscriptionsURL = "subscriptions_url"
      case organizationsURL = "organizations_url"
      case reposURL = "repos_url"
      case eventsURL = "events_url"
      case receivedEventsURL = "received_events_url"
      case siteAdmin = "site_admin"
    }
  }
}
