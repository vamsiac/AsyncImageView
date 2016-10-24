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
aImageView.imageURL = URL(string: "YOUR_IMAGE_URL")
self.view.addSubView(aImageView)
```

## Usage 2
Load image directly from string. This is just a convinience.
```Swift
let aImageView = AsyncImageView(frame: "YOUR_IMAGEVIEW_FRAME")
aImageView.imageURLString = "YOUR_IMAGE_URL_STRING"
self.view.addSubView(aImageView)
```

## Usage 3
Load image using completion handler. This usage is helpful if you need to load images asynchronously without subclassing UIImageView from AsyncImageView. 
For example, UIButton's imageView can be loaded asynchronously with this usage without requiring any subclassing of AsyncImageView.
```Swift
let button = UIButton(type: .custom)
button.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
button.loadImageAsync(fromURL: URL(string: "YOUR_IMAGE_URL")!, for: .normal) 
self.view.addSubview(button)
```
or simply
```Swift
let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
imageView.loadImageAsync(fromURL: URL(string: "YOUR_IMAGE_URL")!)
self.view.addSubview(imageView)
```
