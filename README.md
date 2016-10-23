# AsyncImageView
Drop in replacement for downloading UIImages asynchronously

# Supported OS & SDK Versions
* Swift 3
* iOS 10 or Later
* Developed in XCode 8

# Installation
Drag AsynImageView.Swift to your project.

# Usage
Image can be asynchronously loaded in three different ways using AsyncImageView

## Usage 1
Load image from URL
```Swift
let aImageView = AsyncImageView(frame: "YOUR_IMAGEVIEW_FRAME")
aImageView.imageURL = URL(string: "www.yourimageURL.com/yourimage.png"
self.view.addSubView(aImageView)
```

## Usage 2
Load image directly from string. This is just a convinience.
```Swift
let aImageView = AsyncImageView(frame: "YOUR_IMAGEVIEW_FRAME")
aImageView.imageURLString = "www.yourimageURL.com/yourimage.png
self.view.addSubView(aImageView)
```

