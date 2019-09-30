//
//  DetailViewController.swift
//  mvc-demo
//
//  Created by Niels Nørskov on 30/09/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import UIKit
import Combine

class DetailViewController: UIViewController
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    private var _imageSubscriber: AnyCancellable?
    
    var item: SearchItem?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let item = item else {
            assertionFailure("SearchItem must be set before presenting.")
            return
        }
        updateUI(with: item)
    }
    
    // MARK: - Private methods
    
    private func updateUI(with item: SearchItem)
    {
        title = item.title
        titleLabel.text = item.title
        descriptionLabel.text = item.description

        if let thumbnailURL = item.thumbnailURL  {
            _imageSubscriber = URLSession.shared.fetchImage(for: thumbnailURL, placeholder: #imageLiteral(resourceName: "placeholder"))
            .receive(on: DispatchQueue.main)
            .assign(to: \.imageView.image, on: self)
        }
    }
}
