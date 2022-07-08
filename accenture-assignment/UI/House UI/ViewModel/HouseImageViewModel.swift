//
//  HouseImageViewModel.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import Foundation
import Combine

class HouseImageViewModel<Image> {
    private var task: ImageDataLoaderTask?
    private let model: HouseItem
    private let imageLoader: ImageDataLoader
    private let imageTransformer: (Data) -> Image?
    
    @Published var onImageLoad: Image? = .none
    @Published var isLoadingImage: Bool = false
    
    init(task: ImageDataLoaderTask? = nil, model: HouseItem, imageLoader: ImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.task = task
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    var name: String {
        return model.name
    }
    
    var title: String {
        return model.title
    }
    
    func loadImageData() {
        if let imageURL = model.imageURL {
            isLoadingImage = true
            task = imageLoader.loadImageData(from: imageURL) { [weak self] result in
                self?.handle(result)
            }
        } else {
            onImageLoad = .none
        }
    }
    
    private func handle(_ result: ImageDataResult) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad = image
        }
        isLoadingImage = false
    }
    
    func cancleImageDataload() {
        task?.cancel()
        task = nil
    }
}
