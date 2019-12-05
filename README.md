# SpotlightSearch
Spotlight Search UI written in SwiftUI and Combine.

<!-- [![CI Status](https://img.shields.io/travis/boraseoksoon/SpotlightSearch.svg?style=flat)](https://travis-ci.org/boraseoksoon/SpotlightSearch) -->
[![Version](https://img.shields.io/cocoapods/v/SpotlightSearch.svg?style=flat)](https://cocoapods.org/pods/SpotlightSearch)
[![License](https://img.shields.io/cocoapods/l/SpotlightSearch.svg?style=flat)](https://cocoapods.org/pods/SpotlightSearch)
[![Platform](https://img.shields.io/cocoapods/p/SpotlightSearch.svg?style=flat)](https://cocoapods.org/pods/SpotlightSearch)

SpotlightSearch aims to provide macOS spotlight search UI/UX and beyond.<br>

Screenshots
-----------

![Alt Text](https://media.giphy.com/media/ZXB9LVcRqNi7W5dZel/giphy.gif)
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
     SpotlightSearch(searchKeywords:viewModel.searchableItems,
               isSearching:$isSearching,
               didChangeSearchText: { self.viewModel.searchText = $0 },
               didTapSearchItem: { self.viewModel.searchText = $0 }) {
                 Text("Your view goes here")
     }
 }
```

## Features

- [x] Written in SwiftUI and Combine 100%  
- [x] It aims to provide quick and beautiful search UI/UX out of box like macOS Spotlight Search in iOS and beyond. 
- [x] full geared toward MVVM.
- [x] target to be easy and simple to use API.

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

* SwiftUI

```Swift
import SwiftUI

/// Step1: 😙 import `Spotlight`
import SpotlightSearch

struct ContentView: View {
    /// Assuming your viewmodel is like example view model in the demo project, the way of how to use is as below.
    /// You can clone this repo then there is SwiftUIExample target demo project in it.
    @ObservedObject var viewModel: ItemListViewModel()
    @State private var isSearching = false
    
    // MARK: - Body
    var body: some View {
        /// Step2: 😆 Declare `Spotlight` externally.
        SpotlightSearch(searchKeywords:viewModel.searchableItems,
                  isSearching:$isSearching,
                  didChangeSearchText: { self.viewModel.searchText = $0 },
                  didTapSearchItem: { self.viewModel.searchText = $0 }) {
                    /// Step3: 😎 Let's wrap SwiftUI Views in it using trailing closure.
                    self.navigationView
        }
    }
}
```

## One Caveat
Currently, SpotlightSearch uses *GLOBAL API to change UITableViewCell and UITableView property GLOBALLY* like below
since SwiftUI is in the very early stage of development and there are plenty of lack APIs  out there and 
not possible to implement such UI Change while using SwiftUI 100%.

Take special care when applying SpotlightSearch into your app which might cause unexpected UI/UX change in your app. 
I will keep my eyes on the SwiftUI API change and when possible, I will fix this workaround as soon as released. 

Note that SpotlightSearch uses these implementation in the initializer as below at the latest version.

```Swift
// MARK: - Initializers
public init(searchKeywords: [String],
     isSearching: Binding<Bool>,
     didChangeSearchText: @escaping (String) -> Void,
     didTapSearchItem: @escaping (String) -> Void,
     wrappingClosure: @escaping () -> Content) {
    
    /// FIXME: THOSE GLOBAL THINGS MAY BE APPLIED TO ALL APP ALTHOUGH MODULE IS SEPARATED.
    /// BUT, THERE IS NO SUCH THING AS API BY WHICH I CAN MODIFY SWIFTUI.
    UITableView.appearance().allowsSelection = false
    UITableView.appearance().separatorStyle = .none
    UITableView.appearance().backgroundColor = .clear
    UITableView.appearance().tableFooterView = UIView()
    UITableView.appearance().contentInset = UIEdgeInsets(top:0,
                                                         left: 0,
                                                         bottom: 300,
                                                         right: 0)
    
    UITableViewCell.appearance().selectionStyle = .none
    UITableViewCell.appearance().backgroundColor = .clear
    
    self.content = wrappingClosure
    self._isSearching = isSearching
    
    self.didTapSearchItem = didTapSearchItem
    self.didChangeSearchText = didChangeSearchText
    
    self.spotlightSearchVM = SpotlightSearchVM(searchKeywords: searchKeywords,
                                               didChangeSearchText: didChangeSearchText)
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

<img align="left" width="240" height="428" src="https://firebasestorage.googleapis.com/v0/b/boraseoksoon-ff7d3.appspot.com/o/SpotlightSearch%2Fo1.png?alt=media&token=f5003b58-f10f-4858-bb27-f4b0e06f6f70">
<img align="left" width="240" height="428" src="https://firebasestorage.googleapis.com/v0/b/boraseoksoon-ff7d3.appspot.com/o/SpotlightSearch%2Fo2.png?alt=media&token=6374ba2c-0e58-478f-81a8-11eb5a5662e2">
<img align="left" width="240" height="428" src="https://firebasestorage.googleapis.com/v0/b/boraseoksoon-ff7d3.appspot.com/o/SpotlightSearch%2Fo4.png?alt=media&token=11e22574-b854-45bf-a0a3-4b0c596db3f9">



