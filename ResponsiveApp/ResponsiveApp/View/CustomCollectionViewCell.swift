//
//  CustomCollectionViewCell.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 2.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var playNow: UnderlinedLabel!
    
    private var game:Game!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playNow.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.name.text = ""
        self.imageView.image = nil
        self.playNow.isHidden = true
    }
    
    public func configure(game:Game) {
        self.game = game
        self.name.text = game.name
        loadImage()
    }
    
    private func loadImage() {
        if let url = game.imageUrl {
            if let image = ImageCache.shared.getImage(url: url) {
                self.imageView.image = image
            } else {
                NetworkCommunicationManager.shared.getImage(url: url) { image, error in
                    guard error == nil else {
                        print(error?.localizedDescription ?? "")
                        return
                    }
                    
                    if let image = image {
                        ImageCache.shared.setImage(image: image, url: url)
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}
