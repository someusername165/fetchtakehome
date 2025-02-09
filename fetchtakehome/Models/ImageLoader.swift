//
//  ImageLoader.swift
//  fetchtakehome
//
//  Created by Ahad Islam on 2/8/25.
//

import Foundation
import UIKit
import SwiftUICore

enum ImageLoaderError: Error {
    case failToDecodeData(Data)
}

struct ImageLoaderKey: EnvironmentKey {
    static let defaultValue = ImageLoader.shared
}

extension EnvironmentValues {
    var imageLoader: ImageLoader {
        get { self[ImageLoaderKey.self] }
    }
}

@globalActor
actor ImageLoader {
    static let shared = ImageLoader()
    
    private enum LoaderStatus {
        case inProgress(Task<UIImage, Error>)
        case fetched(UIImage)
    }
    
    private var images: [URLRequest: LoaderStatus] = [:]
    
    private static let folderPath = "cachedImages"
    
    private init() {}
    
    public func fetch(_ url: URL) async throws -> UIImage {
        let request = URLRequest(url: url)
        return try await fetch(request)
    }
    
    public func fetch(_ urlRequest: URLRequest) async throws -> UIImage {
        defer { checkMemory() }
        if let status = images[urlRequest] {
            switch status {
            case .inProgress(let task):
                return try await task.value
            case .fetched(let uIImage):
                return uIImage
            }
        }
        
        if let image = try imageFromFileSystem(urlRequest) {
            images[urlRequest] = .fetched(image)
            return image
        }
        
        let task: Task<UIImage, Error> = Task {
            let (imageData, _) = try await URLSession.shared.data(for: urlRequest)
            if let image = UIImage(data: imageData) {
                try persistImage(image, for: urlRequest)
                return image
            } else {
                throw ImageLoaderError.failToDecodeData(imageData)
            }
        }
        
        images[urlRequest] = .inProgress(task)
        
        let image = try await task.value
        
        images[urlRequest] = .fetched(image)
        
        return image
    }
    
    private func imageFromFileSystem(_ urlRequest: URLRequest) throws -> UIImage? {
        guard let url = try fileName(urlRequest) else {
            assertionFailure("Unable to generate a local path for \(urlRequest)")
            return nil
        }

        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    private func fileName(_ urlRequest: URLRequest) throws -> URL? {
        guard let fileName = urlRequest.url?.path.replacingOccurrences(of: "/", with: "", options: NSString.CompareOptions.literal, range: nil),
              let folder = getCacheFolderPath() else {
                  return nil
              }
        if !FileManager.default.fileExists(atPath: folder.path) {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        }
        return folder.appendingPathComponent(fileName)
    }
    
    private func getCacheFolderPath() -> URL? {
        // get the path url to the cache directory
        FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(Self.folderPath)
    }

    private func persistImage(_ image: UIImage, for urlRequest: URLRequest) throws {
        guard let url = try fileName(urlRequest),
              let data = image.jpegData(compressionQuality: 0.8) else {
            return
        }

        try data.write(to: url)
    }

    private func checkMemory() {
        /// eventually check if the current on memory needs to be reduced...
    }
}
