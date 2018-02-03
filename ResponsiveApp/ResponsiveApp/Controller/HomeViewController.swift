//
//  HomeViewController.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 1.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Constants
    private let kCellId = "Cell"
    private let kInitialSegmentSelectedIdnex = 0
    private let kCollectionViewMargin = 10.0 as CGFloat
    private let kAspectRatio = 16.0/9.0 as CGFloat
    private let kFontSizePlusPadding = 23.0 as CGFloat
    
    private var numberOfCellsPerRow:CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 3.0
        } else if UIApplication.shared.statusBarOrientation == .landscapeLeft ||
            UIApplication.shared.statusBarOrientation == .landscapeRight {
            return 3.0
        }
        return 2.0
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var segmentControl: UISegmentedControl?
    private var feed:Feed? {
        didSet {
            if let feed = feed {
                loadSegmentControl()
                applySegmentControlConstraints()
                currentCategory = feed.categories[segmentControl!.selectedSegmentIndex]
            }
        }
    }
    private var currentCategory:GameCategory? {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkCommunicationManager.shared.fetchFeed(completionSuccess: { [weak self] feed in
            self?.feed = feed
        }) { error in
            if let error = error as? NetworkError {
                switch error {
                case .noDataError:
                    print("No Data")
                case .statusCodeError(let message):
                    print(message)
                case .jsonDecodingError(let error):
                    print("JsonDecodingError:\(error.localizedDescription)")
                }
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }

    // MARK: - Helpers
    private func loadSegmentControl()  {
        let names = getCategoryNames()
        guard names.count > 0 else { return }
        segmentControl = UISegmentedControl(items: names)
        segmentControl?.addTarget(self, action: #selector(onSegmentControlValueChange), for: .valueChanged)
        segmentControl?.backgroundColor = .white
        segmentControl?.tintColor = .purple
        segmentControl?.selectedSegmentIndex = kInitialSegmentSelectedIdnex
        self.view.addSubview(segmentControl!)
        applySegmentControlConstraints()
    }
    
    private func applySegmentControlConstraints() {
        segmentControl?.translatesAutoresizingMaskIntoConstraints = false
        var constraints:[NSLayoutConstraint] = []
        constraints.append(segmentControl!.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor))
        constraints.append(segmentControl!.leftAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leftAnchor))
        constraints.append(segmentControl!.rightAnchor.constraint(equalTo: self.view.layoutMarginsGuide.rightAnchor))
        NSLayoutConstraint.activate(constraints)
    }

    private func getCategoryNames() -> [String] {
        var names:[String] = []
        if let count = feed?.categories.count, count > 0 {
            names = feed!.categories.map { category in
                return category.name
            }
        }
        return names
    }
    
    // MARK: - Actions
    @objc private func onSegmentControlValueChange() {
        if let feed = feed {
            currentCategory = feed.categories[segmentControl!.selectedSegmentIndex]
        }
    }
}

// MARK: CollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return currentCategory?.games.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! CustomCollectionViewCell
        let game = currentCategory!.games[indexPath.item]
        cell.configure(game: game)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.size.width - kCollectionViewMargin * (numberOfCellsPerRow+1)) / numberOfCellsPerRow
        return CGSize(width: size, height: size / kAspectRatio + kFontSizePlusPadding)
    }
}

