//
//  ImageLoader.swift
//  ScrollViewStickyTopSearchBar
//
//  Created by Maxim Macari on 19/3/21.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    let url: URL?
    
    private var cancellable: AnyCancellable?
    
    init(imageURL: String) {
        if let url = URL(string: imageURL){
            self.url = url
            return
        }
        print("Error imageURL")
        self.url = nil
    }
    
    deinit {
        cancel()
    }
    
    func load(){
        guard let url = url else {
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map{ UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] in
                self?.image = $0
            }
    }
    
    func cancel(){
        cancellable?.cancel()
    }
}
