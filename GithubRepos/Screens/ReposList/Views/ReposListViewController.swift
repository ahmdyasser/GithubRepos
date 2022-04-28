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

  typealias ReposDataSource = UICollectionViewDiffableDataSource<ReposListViewController.Section, RepoViewModel>

  private var cancellableBag: [AnyCancellable] = []
  private let viewModel: RepositoryListViewModelType
  private let onSelection = PassthroughSubject<Int, Never>()
  private let onSearch = PassthroughSubject<String, Never>()
  private let onAppear = PassthroughSubject<Void, Never>()
  private let onPageRequest = PassthroughSubject<Void, Never>()

  private lazy var collectionViewDataSource = makeDataSource()
  private lazy var collectionViewDelegate = ReposCollectionViewDelegate(onPageRequest: self.onPageRequest,
                                                                             onItemSelected: self.onSelection)

  private var repoListView = RepoListView()

  override func loadView() {
    view = repoListView
  }

  // MARK: - Initialiser
  init(viewModel: RepositoryListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("No support for Storyboard")
  }

  // MARK: - View Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    setupUIDelegates()
    bind(to: viewModel)
    onAppear.send()

  }
  // MARK: - View Model Binding
  private func bind(to viewModel: RepositoryListViewModelType) {

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
    case .failure:
      return
    }
  }

  func update(with repos: [RepoViewModel], animate: Bool = true) {
    DispatchQueue.main.async {
      var snapshot = ReposSnapshot.init()
      snapshot.appendSections([.main])
      snapshot.appendItems(repos, toSection: .main)
      self.collectionViewDataSource.apply(snapshot, animatingDifferences: animate)
    }
  }

  func makeDataSource() -> ReposDataSource {
    return ReposDataSource.init(collectionView: repoListView.repoCollectionView) { collectionView, indexPath, viewModel in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedCell.reuseIdentifier,
                                                          for: indexPath) as? RoundedCell
      else { assertionFailure("Failed to dequeue")
        return .init()
      }

      cell.accessibilityIdentifier = "\(AccessibilityIdentifiers.RepositoryList.cellID) \(indexPath.row)"
      cell.bind(to: viewModel)

      return cell
    }
  }

  private func setupUIDelegates() {
    repoListView.searchController.searchBar.delegate = self
    repoListView.searchController.searchResultsUpdater = self
    repoListView.repoCollectionView.delegate = collectionViewDelegate
  }

  private func configureUI() {
    title = NSLocalizedString("Repositories", comment: "Top Repos")
    repoListView.repoCollectionView.dataSource = collectionViewDataSource
    navigationItem.searchController = self.repoListView.searchController
    repoListView.searchController.isActive = false
    collectionViewDelegate.onScroll = { [weak self] in
      self?.repoListView.searchController.isActive = false
        self?.repoListView.searchController.searchBar.resignFirstResponder()

    }
  }

}

// MARK: - Search Delegate
extension ReposListViewController: UISearchBarDelegate, UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
    self.onSearch.send(searchController.searchBar.text ?? "")
  }

}
