//
//  AllRemarksInfoViewController.swift
//  LandmarkRemark
//
//  Created by Arvin on 26/9/21.
//

import UIKit

class AllRemarksInfoViewController: UIViewController {

    // section to be used in our diffable datasource
    enum Section { case main }
    
    var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<Section, RemarkViewModel>!
    
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotes()
    }
    
    private func setup() {
        setupView()
        setupConstraints()
        setupDatasource()
    }
    
    // setup UI element's properties
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Landmarks"
        
        // CollectionView
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(RemarkCollectionViewCell.self, forCellWithReuseIdentifier: RemarkCollectionViewCell.reuseId)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        // searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for landmarks"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    // constraints setup for collectionView
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Space.padding),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /**
     * Call our viewModel manager to get the remarks list from our DB and supply it to our diffable datasource based on the updated list that we retrieved.
     */
    private func setupNotes() {
        ViewModelManager.shared.getRemarks { [weak self] error in
            guard let self = self else { return }
            
            guard error == nil else {
                self.presentAlert(withTitle: "Empty Remarks", andMessage: error!.rawValue, buttonTitle: "Ok")
                return
            }
            
            self.updateDatasource(using: ViewModelManager.shared.getAllRemarks())
        }
    }

}

// MARK: CollectionView Delegate

extension AllRemarksInfoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /**
     * Create our diffable datasource to manage our model and create/provide a cell based on our viewModel.
     */
    private func setupDatasource() {
        datasource = UICollectionViewDiffableDataSource<Section, RemarkViewModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, remarkViewModelIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemarkCollectionViewCell.reuseId, for: indexPath) as! RemarkCollectionViewCell
            cell.remarkViewModel = remarkViewModelIdentifier
            
            return cell
        })
    }
    
    /**
     * Create a snapshot from the passed Remarks view model list which subsequently updates our datasource.
     *
     * - Parameters:
     *      - remarksList: new list or remarks view model to supply into our datasource and update our items in the collectionView
     */
    private func updateDatasource(using remarksList: [RemarkViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RemarkViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(remarksList)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width * 0.85
        let cellHeight = collectionView.frame.height * 0.10
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // get our viewModel pointed to by the selected indexPath
        guard let remarkViewModel = datasource.itemIdentifier(for: indexPath) else { return }
        
        dismiss(animated: true) {
            // once we get our remark, we then post a notification that directs the UI to the exact location of the remark in the map.
            NotificationCenter.default.post(name: .LRCenterToSelectedLocation, object: self, userInfo: ["remarkViewModel":remarkViewModel])
        }
    }
}

// MARK: Search Controller conformance

extension AllRemarksInfoViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            // if search text is empty, then we update our datasource with the usual remarks list.
            // this is triggered upon tapping the search bar and deleting the entries entered in the search.
            ViewModelManager.shared.resetFilteredRemarks()
            updateDatasource(using: ViewModelManager.shared.getAllRemarks())
            return
        }
        
        // process the search text in our view model manager which updates its properties. Then update our diffable datasource with this new filtered list.
        ViewModelManager.shared.filterRemark(having: text)
        updateDatasource(using: ViewModelManager.shared.getFilteredRemarks())
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // just get all the remarks once the user cancels the search
        ViewModelManager.shared.resetFilteredRemarks()
        updateDatasource(using: ViewModelManager.shared.getAllRemarks())
    }
    
}
