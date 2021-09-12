//
//  DownloadImageManager.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/12/21.
//

import UIKit
import RxSwift
import RxRelay

class DonwloadImageManager {
    
    let state = PublishRelay<DownloadImageState>()

    func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            state.accept(.error)
            return
        }
        state.accept(.downloading)
        getData(from: url) { data, response, error in
            DispatchQueue.main.async() { [weak self] in
                guard let self = self else { return }
                guard let data = data, error == nil else {
                    self.state.accept(.error)
                    return
                }
                if let image = UIImage(data: data) {
                    self.state.accept(.success(image: image))
                } else {
                    self.state.accept(.error)
                }
                
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
