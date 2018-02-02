//
//  HomeViewController.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 1.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let kCellId = "Cell"
    private var feed:Feed? {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkCommunicationManager.shared.fetchFeed(completionSuccess: { [weak self] feed in
            self?.feed = feed
    //        print(feed)
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

