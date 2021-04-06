
<p align="center">
<img src="https://www.flaticon.com/svg/vstatic/svg/622/622669.svg?token=exp=1617739924~hmac=ffe4453967acec3822ad20920c65f163" alt="SpotlightSearch" title="SpotlightSearch" width="200"/>
</p>
<br>
<br>

# SpotlightSearch
Spotlight Search UI written in SwiftUI and Combine.

<!-- [![CI Status](https://img.shields.io/travis/boraseoksoon/SpotlightSearch.svg?style=flat)](https://travis-ci.org/boraseoksoon/SpotlightSearch) -->
[![Version](https://img.shields.io/cocoapods/v/SpotlightSearch.svg?style=flat)](https://cocoapods.org/pods/SpotlightSearch)
[![License](https://img.shields.io/cocoapods/l/SpotlightSearch.svg?style=flat)](https://cocoapods.org/pods/SpotlightSearch)
[![Platform](https://img.shields.io/cocoapods/p/SpotlightSearch.svg?style=flat)](https://cocoapods.org/pods/SpotlightSearch)

a SwiftUI library that helps you search on iOS in a similar way MacOS Spotligt does.<br>

Screenshots
-----------

![Alt Text](https://github.com/boraseoksoon/SpotlightSearch/blob/master/gif/dark_theme.gif)
![Alt Text](https://github.com/boraseoksoon/SpotlightSearch/blob/master/gif/white_theme.gif)
![Alt Text](https://media.giphy.com/media/RfeIpyRRdJDCce9jfN/giphy.gif)


<!-- short link: https://gph.is/g/amnjBwJ -->
<!-- html5 video link :https://giphy.com/gifs/ZXB9LVcRqNi7W5dZel/html5 -->

![SpotlightSearch Screenshot](https://firebasestorage.googleapis.com/v0/b/boraseoksoon-ff7d3.appspot.com/o/SpotlightSearch%2FScreen%20Shot%202019-12-05%20at%2010.00.16%20PM.png?alt=media&token=677b17ed-9bb0-4fe9-94f2-00619b33ee80)

Youtube video URL Link for how it works in dark mode: <br>
[link0](https://youtu.be/iaPvEpq8Ci4)

Youtube video URL Link for how it works in normal mode: <br>
[link0](https://youtu.be/wfLU_tlXeX0)

At a Glance
-----------

```swift
// MARK: - Body
var body: some View {
    SpotlightSearch(
        isSearching:$isSearching,
        didChangeSearchText: { self.viewModel.searchText = $0 },
        didTapSearchItem: { self.viewModel.searchText = $0 }) {
            self.searchButton
    }
}
```

## Features

- [x] Written in SwiftUI and Combine 100%  
- [x] Search items on iOS in a similar way that macOS Spotlight does.
- [x] One liner, no brainer API

<br>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
It includes examples for UIKit as well as SwiftUI.

## Requirements

- iOS 13.0 or later
- Swift 5.0 or later
- Xcode 11.0 or later


Getting Started
--------------- 

* SwiftUI Simplified version. just copy and paste below code. It will work. 

1. clone repository 
2. Switch and select 'QuickExample' target.
3. Build and run.

In 'QuickExample' directory, there are sample codes.

```Swift

/// Step1: 😆 import `SpotlightSearch`!
import SpotlightSearch
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = TestViewModel()
    @State private var isSearching = false
    
    // MARK: - Body
    
    /// Step2: 😆 Declare `SpotlightSearch` externally.
    var body: some View {
        SpotlightSearch(
            searchKeywords:viewModel.keywords,
            isSearching:$isSearching,
            didTapItem: { print("chosen : \($0)") }) {

                /// Step3: 😎 your UI goes here in the closure. All Set!
                yourMainView
        }
    }
}

// MARK: - Variables
extension ContentView {
    var yourMainView: some View {
        Button(action: {
            withAnimation(.easeIn(duration: 0.3)) {
                isSearching.toggle()
            }
        }) {
            ZStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80.0, height: 80.0)
                    .foregroundColor(.blue)
            }
        }
    }
}

class TestViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var keywords: [String] = ["Objective-C",
                                         "Clojure",
                                         "Swift",
                                         "Javascript",
                                         "Python",
                                         "Haskell",
                                         "Scala",
                                         "Rust",
                                         "C",
                                         "C++",
                                         "Dart",
                                         "C#",
                                         "F#",
                                         "LISP",
                                         "Golang",
                                         "Kotlin",
                                         "Java",
                                         "Assembly",
                                         "안녕하세요",
                                         "감사합니다",
                                         "사랑합니다",
                                         "행복하세요"]
}


```

## Installation

There are two ways officially to use SpotlightSearch in your project:
- using CocoaPods
- using Swift Package Manager

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the [Get Started](http://cocoapods.org/#get_started) section for more details.

#### Podfile

First, 
```ruby
pod 'SpotlightSearch'
```
then in your root project,
```ruby
pod install
```

### Installation with Swift Package Manager (Xcode 11+)

[Swift Package Manager](https://swift.org/package-manager/) (SwiftPM) is a tool for managing the distribution of Swift code as well as C-family dependency. From Xcode 11, SwiftPM got natively integrated with Xcode.

SpotlightSearch support SwiftPM from version 5.1.0. To use SwiftPM, you should use Xcode 11 to open your project. Click `File` -> `Swift Packages` -> `Add Package Dependency`, enter [SpotlightSearch repo's URL](https://github.com/boraseoksoon/SpotlightSearch). Or you can login Xcode with your GitHub account and just type `SpotlightSearch` to search.

After select the package, you can choose the dependency type (tagged version, branch or commit). Then Xcode will setup all the stuff for you.

If you're a framework author and use SpotlightSearch as a dependency, update your `Package.swift` file:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/boraseoksoon/SpotlightSearch", from: "0.1.1")
    ],
    // ...
)
```

## Author

boraseoksoon@gmail.com

## License

SpotlightSearch is available under the MIT license. See the LICENSE file for more info.


## References 

[PhotoCell](https://apps.apple.com/us/app/observable/id1488022000?ls=1) : 
Time and Location-based photo browsing iOS app where you can download the photos and edit as you like for free.

<img align="left" width="240" height="428" src="https://firebasestorage.googleapis.com/v0/b/boraseoksoon-ff7d3.appspot.com/o/BSZoomGridScrollView%2Fo1.png?alt=media&token=f5003b58-f10f-4858-bb27-f4b0e06f6f70">
<img align="left" width="240" height="428" src="https://firebasestorage.googleapis.com/v0/b/boraseoksoon-ff7d3.appspot.com/o/BSZoomGridScrollView%2Fo2.png?alt=media&token=6374ba2c-0e58-478f-81a8-11eb5a5662e2">
<img align="left" width="240" height="428" src="https://firebasestorage.googleapis.com/v0/b/boraseoksoon-ff7d3.appspot.com/o/BSZoomGridScrollView%2Fo4.png?alt=media&token=11e22574-b854-45bf-a0a3-4b0c596db3f9">
