//
//  TableViewCell.swift
//  FreeGames
//
//  Created by Илья Маркелов on 04.12.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var gameImageView: GameImageView! {
        didSet {
            gameImageView.contentMode = .scaleAspectFit
            gameImageView.clipsToBounds = true
            gameImageView.layer.cornerRadius = gameImageView.frame.height / 2
            gameImageView.backgroundColor = .white
        }
    }

    @IBOutlet var nameLabel: UILabel!

    func configure(with game: MMOGames?) {
        nameLabel.text = game?.title
        gameImageView.fetchImage(from: game?.thumbnail ?? "")
    }

}
