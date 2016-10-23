//
//  AsyncImageView.swift
//  BasicExample
//
//  Created by Vamsi Chaitanya on 10/20/16.
//  Copyright © 2016 Vamsi Anguluru. All rights reserved.
//

import UIKit

/// Completion handler 
typealias DownloadCompletionBlock = (UIImage?) -> Void

class AsyncImageView: UIImageView {
    
    /// Returns the cached image or nil if connection fails.
    var completionHandler:(DownloadCompletionBlock)? {
        didSet {
            
        }
    }
    
    /// Sets the cache policy for the image download request. Default values is .returnCacheDataElseLoad.
    var cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad
    
    /// Fade animations while presenting Image
    var animate: Bool = true
    
    /// Returns the downloaded image if string is an appropriate URL.
    /// Converts the string to url and starts download.
    var imageURLString: String! {
        didSet {
            guard let escapedString = self.escapedString(string: imageURLString),
                let url = URL(string: escapedString) else {
                    print("AsyncImageView: No image url string is invalid")
                    self.completionHandler?(nil)
                    
                    return
            }
            
            loadImageWithURL(url) { downloadedImage in
                guard let image = downloadedImage else {
                    self.completionHandler?(nil)
                    
                    return
                }
                
                DispatchQueue.main.async (execute: {
                    //Ignore if image is already assigned
                    if self.image != image {
                        self.image = image
                        
                        if self.animate {
                            self.alpha = 0.3
                            UIView.animate(withDuration: 0.4, animations: {
                                self.alpha = 1.0
                            })
                        }
                    }
                })
                self.completionHandler?(image)
            }
        }
    }
    
    /// returns the escaped string
    private func escapedString(string: String) -> String? {
        return string.removingPercentEncoding?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    /// will download the image asynchronously
    var imageURL: URL! {
        didSet {
            let stringURL = imageURL.absoluteString
            if let escapedString = self.escapedString(string: stringURL)
            {
                self.imageURLString = escapedString
            }
        }
    }
    
    /// Loads the image from URL and set the imageview image.
    func loadImage(fromURL url: URL) {
        self.imageURL = url
    }
    
    /// Convinience completion handler function to get the image.
    func getImageFromString(_ urlString: String, completion: DownloadCompletionBlock?) {
        guard let escapedImageURL = self.escapedString(string: urlString) , escapedImageURL != "" else {
            return
        }
        
        self.imageURLString = urlString
        self.completionHandler = completion
    }
    
    /// loads the image, save the image to cache, returns image in completion handler,
    fileprivate func loadImageWithURL(_ url: URL, completion: DownloadCompletionBlock?) {
        
        if let image = AsyncImageCache.imageCache.loadImageFromCache(url: url) {
            // found image in cache
            completion?(image)
            
        } else {
            // cannot find image in cahce, so download the image and save to cache
            var request = NSMutableURLRequest(url: url)
            self.buildURLRequest(urlRequest: &request)
            
            let downloadSession = URLSession(configuration: URLSessionConfiguration.default)
            
            let imageDownloadTask = downloadSession.downloadTask(with: request as URLRequest) { url, response, error in
                guard let localUrl = url, error == nil else {
                    completion?(nil)
                    return
                }
                
                do {
                    let imageCachePath = try AsyncImageCache.imageCache.copyToImageCache(fromTempCache: localUrl, imageUrl: (response?.url)!).path
                    
                    completion?(UIImage(contentsOfFile: imageCachePath))
                    
                } catch let error {
                    print("AsyncImageView: Failed to cppy image with URL \(response?.url) with error: \(error)")
                }
                
                
            }
            imageDownloadTask.resume()
        }
    }
    
    /**
     Builds URL request.
     Subclasses can use this method to override and add access tokens if required.
     
     - Parameter urlRequest: image url request.
     
     */
    func buildURLRequest(urlRequest: inout NSMutableURLRequest) {
        urlRequest.cachePolicy = self.cachePolicy
    }
    
}

private class AsyncImageCache: NSObject, FileManagerDelegate {
    
    static let imageCache = AsyncImageCache()
    
    private lazy var imageCacheFolder: URL = {
        let cacheDirectory = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let cacheDirName = "com.async.imagecache"
        try! FileManager.default.createDirectory(at: cacheDirectory.appendingPathComponent(cacheDirName), withIntermediateDirectories: true, attributes: nil)
        FileManager.default.delegate = self
        return cacheDirectory.appendingPathComponent(cacheDirName)
    }()
    
    /**
     Copies image to the cache directory
     Example: www.google.com/path/abc.png will be saved to User/.../Caches/google/path/abc.png
     
     - Parameter tempCacheUrl: url where the temporary cache file is stored.
     
     - Parameter imageUrl: Actual image url.
     */
    func copyToImageCache(fromTempCache tempCacheUrl: URL, imageUrl: URL) throws -> URL {
        let destinationFolderPath = self.imageSavePath(url: imageUrl)
        
        if FileManager.default.fileExists(atPath: destinationFolderPath.deletingLastPathComponent().path) == false {
            try FileManager.default.createDirectory(at: destinationFolderPath.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        }
        
        try FileManager.default.moveItem(at: tempCacheUrl, to: destinationFolderPath)
        return destinationFolderPath
    }
    
    func loadImageFromCache(url: URL) -> UIImage? {
        let imageCachePath = self.imageSavePath(url: url).path
        if FileManager.default.fileExists(atPath: imageCachePath) {
            return UIImage(contentsOfFile: imageCachePath)
        } else {
            return nil
        }
        
    }
    
    private func imageSavePath(url: URL) -> URL {
        return self.imageCacheFolder.appendingPathComponent(url.host?.appending(url.path).appending(url.query ?? "") ?? "")
    }
    
    //MARK:- File manager delegate
    
    fileprivate func fileManager(_ fileManager: FileManager, shouldProceedAfterError error: Error, movingItemAt srcURL: URL, to dstURL: URL) -> Bool {
        if (error as NSError).code == NSFileWriteFileExistsError {
            return true
        } else {
            return false
        }
    }
}

/// This extension is convenient for loading images asynchronously with out needing to subclass from AsyncImageView.
extension UIImageView {
    /// Loads the image from URL and set the imageview image.
    func loadImage(fromURL url: URL,into imageView: UIImageView) {
        
        AsyncImageView().loadImageWithURL(url) { (image) in
            guard let downloadedImage = image else {
                return
            }
            
            DispatchQueue.main.async (execute: {
                //Ignore if image is already assigned
                if self.image != image {
                    self.image = downloadedImage
                }
            })
        }
    }
}
