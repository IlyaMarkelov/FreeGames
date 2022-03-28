//
//  GameImageView.swift
//  FreeGames
//
//  Created by Илья Маркелов on 04.12.2021.
//

import UIKit

class GameImageView: UIImageView {
    func fetchImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            image = #imageLiteral(resourceName: "picture")
            return
        }
        
        // Use image from cache
        if let cachedImage = getCachedImage(from: imageURL) {
            image = cachedImage
        }
        
        // Download image from url
        ImageManager.shared.fetchImage(from: imageURL) { data, response in
            self.saveDataToCache(with: data, and: response)
            if imageURL.lastPathComponent == response.url?.lastPathComponent {
                print("Image from url: ", imageURL.lastPathComponent)
                self.image = UIImage(data: data)
                let itemSize = CGSize.init(width: 70, height: 70)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
                let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
                self.image?.draw(in: imageRect)
                self.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
    }
    
    private func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func getCachedImage(from url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        guard let cachedResponse = URLCache.shared.cachedResponse(for: request) else { return nil }
        guard url.lastPathComponent == cachedResponse.response.url?.lastPathComponent else { return nil }
        print("Image from cache: ", url.lastPathComponent)
        return UIImage(data: cachedResponse.data)
    }
}
