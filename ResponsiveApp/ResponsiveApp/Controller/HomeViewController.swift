//
//  HomeViewController.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 1.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Overrides
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var segmentControl: UISegmentedControl?
    private var feed:Feed? {
        didSet {
            collectionView.reloadData()
            loadSegmentControl()
            applySegmentControlConstraints()
        }
    }
    
    // MARK: - Constants
    private let kCellId = "Cell"

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

    // MARK: - Helpers
    private func loadSegmentControl()  {
        let names = getCategoryNames()
        guard names.count > 0 else { return }
        segmentControl = UISegmentedControl(items: names)
        segmentControl?.addTarget(self, action: #selector(onSegmentControlValueChange), for: .valueChanged)
        segmentControl?.backgroundColor = .white
        segmentControl?.tintColor = .purple
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
        print(segmentControl!.selectedSegmentIndex)
    }
}

// MARK: CollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed?.categories[0].games.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! CustomCollectionViewCell
        let game = feed?.categories[0].games[indexPath.item]
        cell.configure(game: game!)
        return cell
    }
}

