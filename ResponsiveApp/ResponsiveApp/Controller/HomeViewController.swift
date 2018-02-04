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
    private let kSegueToWKViewController = "WKSegueID"
    private let kInitialSegmentSelectedIdnex = 0
    private let kCollectionViewMargin = 10.0 as CGFloat
    private let kSegmentControlTopMargin = 16 as CGFloat
    private let kAspectRatio = 16.0/9.0 as CGFloat
    private let kFontSizePlusPadding = 23.0 as CGFloat
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var segmentControl: UISegmentedControl?
    private var feed:Feed? {
        didSet {
            if let feed = feed {
                loadSegmentControl()
                currentCategory = feed.categories[segmentControl!.selectedSegmentIndex]
            }
        }
    }
    
    private var currentCategory:GameCategory? {
        didSet {
            if currentCategory != nil {
                let range = Range(uncheckedBounds: (0, collectionView.numberOfSections))
                let indexSet = IndexSet(integersIn: range)
                collectionView.reloadSections(indexSet)
            }
        }
    }

    private var numberOfCellsPerRow:CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 3.0
        } else if UIApplication.shared.statusBarOrientation == .landscapeLeft ||
            UIApplication.shared.statusBarOrientation == .landscapeRight {
            return 3.0
        }
        return 2.0
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Home", comment: "Home screen title")
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSegueToWKViewController {
            if let destinationViewController = segue.destination as? WKViewController,
               let gameCellIndex = collectionView.indexPathsForSelectedItems?.first,
               let game = currentCategory?.games[gameCellIndex.item],
               let url = EndPoints.getGameUrl(gameCode: game.gameCode) {
                destinationViewController.inject(url: url)
                destinationViewController.title = game.name
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
        segmentControl?.selectedSegmentIndex = kInitialSegmentSelectedIdnex
        self.view.addSubview(segmentControl!)
        applySegmentControlConstraintsForiOS11()
    }
    
    private func applySegmentControlConstraintsForiOS11() {
        segmentControl?.translatesAutoresizingMaskIntoConstraints = false
        var constraints:[NSLayoutConstraint] = []
        if #available(iOS 11.0, *) {
            constraints.append(segmentControl!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: kSegmentControlTopMargin))
        } else {
            constraints.append(segmentControl!.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: kSegmentControlTopMargin))
        }
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
    
    @IBAction func onSwipe(_ sender: UISwipeGestureRecognizer) {
        guard let feed = feed, let selectedIndex = segmentControl?.selectedSegmentIndex else { return }
        switch sender.direction {
        case .left:
            if selectedIndex < feed.categories.count-1 {
                segmentControl?.selectedSegmentIndex = selectedIndex + 1
                onSegmentControlValueChange()
            }
        case .right:
            if selectedIndex > 0 {
                segmentControl?.selectedSegmentIndex = selectedIndex - 1
                onSegmentControlValueChange()
            }
        default:
            break
        }
    }
}

// MARK: - CollectionView DataSource
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

