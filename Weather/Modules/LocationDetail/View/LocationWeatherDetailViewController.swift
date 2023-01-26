//
//  LocationWeatherDetailViewController.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//

import UIKit

class LocationWeatherDetailViewController: UIViewController {
    
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
            LocationWeatherDetailCell.self,
            forCellWithReuseIdentifier: LocationCell.name
        )
        return collectionView
    }()
    
    private var errorViewHeightConstraint: NSLayoutConstraint!
        
    // MARK: - Public properties -
    var presenter: LocationWeatherDetailPresenterInterface!
    
    // MARK: - Lifecycle -
    override func loadView() {
        super.loadView()
        addViews()
        setUpConstraint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
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
}

// MARK: - UICollectionView delegate flowLayout -
extension LocationWeatherDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - 22
        return CGSize(width: width - 16, height: 60)
    }
}

// MARK: - UICollectionView dataSource -
extension LocationWeatherDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCell.name, for: indexPath) as! LocationWeatherDetailCell
        cell.configure(with: presenter.item(at: indexPath))
        return cell
    }
}

// MARK: - LocationWeatherFinderView interface -
extension LocationWeatherDetailViewController: LocationWeatherDetailViewInterface {
    
    func loadTitle(with name: String) {
        title = name
    }
    
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

