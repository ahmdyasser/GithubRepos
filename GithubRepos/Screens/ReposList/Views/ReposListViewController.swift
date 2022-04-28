//
//  ViewController.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import UIKit
import Combine


extension ReposListViewController {
  enum Section {
    case main
  }
}

class ReposListViewController: UIViewController {
  
  typealias ReposSnapshot = NSDiffableDataSourceSnapshot<ReposListViewController.Section, RepoViewModel>
  
  typealias ReposDataSource = UICollectionViewDiffableDataSource<ReposListViewController.Section,RepoViewModel>

  
  private var cancellableBag: [AnyCancellable] = []
  private let viewModel: RepositoryListViewModelable
  private let onSelection = PassthroughSubject<Int, Never>()
  private let onSearch = PassthroughSubject<String, Never>()
  private let onAppear = PassthroughSubject<Void, Never>()
  private let onPageRequest = PassthroughSubject<Void, Never>()
  
  private lazy var dataSource = makeDataSource()
  
  
  //MARK: - View Elements
  private lazy var searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.tintColor = .label
    searchController.searchBar.delegate = self
    searchController.searchResultsUpdater = self
    searchController.searchBar.searchTextField.accessibilityIdentifier = AccessibilityIdentifiers.RepositoryList.searchFieldID
    return searchController
  }()
  
  lazy var repoCollectionView: UICollectionView = {
    
    let collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: createLayout()!)
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.delegate = self
    collectionView.register(RepoCell.self, forCellWithReuseIdentifier: RepoCell.reuseIdentifier)
    view.addSubview(collectionView)
    
    
    return collectionView
  }()
  
  //MARK: - Initalizer
  init(viewModel:  RepositoryListViewModelable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("No support for Storyboard")
  }
  
  
  
  //MARK: - View Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind(to: viewModel)
    onAppear.send()
    
  }
  
  private func bind(to viewModel: RepositoryListViewModelable) {
    
    cancellableBag.forEach { $0.cancel() }
    cancellableBag.removeAll()
    let input = RepositoryListViewModelInput(onAppear: onAppear.eraseToAnyPublisher(),
                                             onSearch: onSearch.eraseToAnyPublisher(),
                                             onRepoSelection: onSelection.eraseToAnyPublisher(), onPageRequest: onPageRequest.eraseToAnyPublisher())
    
    let output = viewModel.transform(input: input)
    
    output.sink(receiveValue: {[unowned self] state in
      self.render(state)
    }).store(in: &cancellableBag)
  }
  
  private func render(_ state: RepositoryListState) {
    switch state {
      
    case .loading:
      return
    case .success(let repos):
      self.update(with: repos)
    case .noResults:
      return
    case .failure(_):
      return
    }
  }
  
  func update(with repos: [RepoViewModel], animate: Bool = true) {
    DispatchQueue.main.async {
      var snapshot = ReposSnapshot.init()
      snapshot.appendSections([.main])
      snapshot.appendItems(repos, toSection: .main)
      self.dataSource.apply(snapshot, animatingDifferences: animate)
    }
  }
  
  
  func makeDataSource() -> ReposDataSource {
    return ReposDataSource.init(collectionView: repoCollectionView) { collectionView, indexPath, viewModel in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepoCell.reuseIdentifier,
                                                          for: indexPath) as? RepoCell
      else { assertionFailure("Failed to dequeue")
        return .init()
      }
      
      cell.accessibilityIdentifier = "\(AccessibilityIdentifiers.RepositoryList.cellID) \(indexPath.row)"
      cell.bind(to: viewModel) // TO Replace with configurator
      
      return cell
    }
  }
  
  private func configureUI() {
    title = NSLocalizedString("Repositories", comment: "Top Repos")
    view.accessibilityIdentifier = AccessibilityIdentifiers.RepositoryList.mainViewID
    repoCollectionView.dataSource = dataSource
    navigationItem.searchController = self.searchController
    searchController.isActive = false
    
  }
  
  func createLayout() -> UICollectionViewLayout? {
    
    
    let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
      
      let itemsPerRow = environment.traitCollection.horizontalSizeClass == .compact ? 2 : 6
      let movieCoverRatio: CGFloat = 2 / 3
      let widthRatio: CGFloat = 1 / CGFloat(itemsPerRow)
      let heightRatio = widthRatio / movieCoverRatio
      
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


extension ReposListViewController: UISearchBarDelegate, UISearchResultsUpdating, UICollectionViewDelegate {
  func updateSearchResults(for searchController: UISearchController) {
    self.onSearch.send(searchController.searchBar.text ?? "")
  }
  
  
}
