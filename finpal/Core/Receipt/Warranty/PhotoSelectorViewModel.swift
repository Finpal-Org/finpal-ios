//
//  PhotoSelectorViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/20/25.
//

import SwiftUI
import PhotosUI

class PhotoSelectorViewModel: ObservableObject {
    @Published var images = [UIImage]()
    @Published var selectedPhotos = [PhotosPickerItem]()
    
    @MainActor
    func convertDataToImage() {
        images.removeAll()
        
        if !selectedPhotos.isEmpty {
            for eachItem in selectedPhotos {
                Task {
                    if let imageData = try? await eachItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: imageData) {
                            images.append(image)
                        }
                    }
                }
            }
        }
        
        selectedPhotos.removeAll()
    }
    
    func removeImage(at index: Int) {
        if index >= 0 && index < images.count {
            images.remove(at: index)
        }
    }
}
