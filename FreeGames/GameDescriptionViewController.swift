//
//  GameDescriptionViewController.swift
//  FreeGames
//
//  Created by Илья Маркелов on 05.12.2021.
//

import UIKit

class GameDescriptionViewController: UIViewController {

    @IBOutlet var gameImageView: GameImageView!
//        didSet {
//            gameImageView.layer.cornerRadius = gameImageView.frame.width / 2
//        }
    
    
    @IBOutlet var descriptionLabel: UILabel!
    
    var mmoGame: MMOGames!
    private var spinnerView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        title = mmoGame.title
        descriptionLabel.text =
            """
                \(mmoGame.genre)
                \(mmoGame.platform)
                \(mmoGame.publisher)
                \(mmoGame.release_date)
            
                \(mmoGame.short_description)
            """
        gameImageView.fetchImage(from: mmoGame.thumbnail)
    }

}
