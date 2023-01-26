//
//  LocationWeatherFinderViewController.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//

import UIKit

class LocationWeatherFinderViewController: UIViewController {
    
    // MARK: - Private properties -
    private lazy var errorView: ErrorView = {
        let errorView = ErrorView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        return errorView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            LocationCell.self,
            forCellWithReuseIdentifier: LocationCell.name
        )
        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("locationWeatherFinder.searcLocations", comment: "")
        searchController.searchBar.barStyle = .black
        return searchController
    }()
    
    private var errorViewHeightConstraint: NSLayoutConstraint!
        
    // MARK: - Public properties -
    var presenter: LocationWeatherFinderPresenterInterface!
    
    // MARK: - Lifecycle -
    override func loadView() {
        super.loadView()
        addViews()
        setUpConstraint()
        setUpNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape,
           let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = view.frame.height - 22
            layout.itemSize = CGSize(width: width - 16, height: 60)
            layout.invalidateLayout()
        } else if UIDevice.current.orientation.isPortrait,
                  let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = view.frame.width - 22
            layout.itemSize = CGSize(width: width - 16, height: 60)
            layout.invalidateLayout()
        }
    }
    
    // MARK: - Actions -
    
    // MARK: - Private methods -
    private func addViews() {
        view.addSubview(collectionView)
        view.addSubview(errorView)
    }
    
    private func setUpConstraint() {
        errorViewHeightConstraint = errorView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            errorViewHeightConstraint,
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setUpNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = titleTextAttributes
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.backgroundColor = .black
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        title = NSLocalizedString("locationWeatherFinder.title", comment: "")
    }
}

extension LocationWeatherFinderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - 22
        return CGSize(width: width - 16, height: 60)
    }
}


// MARK: - UICollectionView delegate -
extension LocationWeatherFinderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(indexPath: indexPath)
    }
}

// MARK: - UICollectionView dataSource -
extension LocationWeatherFinderViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCell.name, for: indexPath) as! LocationCell
        cell.configure(with: presenter.item(at: indexPath))
        return cell
    }
}

// MARK: - LocationWeatherFinderView interface -
extension LocationWeatherFinderViewController: LocationWeatherFinderViewInterface {
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func selectItem(indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    func showError(viewModel: ErrorViewModel) {
        guard errorViewHeightConstraint.constant == 0 else { return }
        errorViewHeightConstraint.constant = 70
        errorView.configure(with: viewModel)
        errorView.setNeedsLayout()
        errorView.layoutIfNeeded()
    }
    
    func hiddenError() {
        guard errorViewHeightConstraint.constant != 0 else { return }
        errorViewHeightConstraint.constant = 0
        errorView.setNeedsLayout()
        errorView.layoutIfNeeded()
    }
}

// MARK: - UISearchResultsUpdating -
extension LocationWeatherFinderViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            presenter.cleanData()
            return
        }
        presenter.getLocationWeatherFinder(at: text)
    }
}
