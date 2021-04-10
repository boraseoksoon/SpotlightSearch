
<p align="center">
<img src="https://www.apple.com/v/app-store/a/images/overview/icon_search__d0w979yulru6_large_2x.png" alt="SpotlightSearch" title="SpotlightSearch" width="250"/>
</p>
<sub>Icon credits: Apple(https://www.apple.com/ca/app-store/)</sub>
<br>
<br>

# SpotlightSearch

<!-- [![CI Status](https://img.shields.io/travis/boraseoksoon/SpotlightSearch.svg?style=flat)](https://travis-ci.org/boraseoksoon/SpotlightSearch) -->
[![Version](https://img.shields.io/cocoapods/v/SpotlightSearch.svg?style=flat)](https://cocoapods.org/pods/SpotlightSearch)
[![License](https://img.shields.io/cocoapods/l/SpotlightSearch.svg?style=flat)](https://cocoapods.org/pods/SpotlightSearch)
[![Platform](https://img.shields.io/cocoapods/p/SpotlightSearch.svg?style=flat)](https://cocoapods.org/pods/SpotlightSearch)

a SwiftUI library that helps you search on iOS in a similar way MacOS Spotlight does.<br>

SpotlightSearch is purely written in SwiftUI and Combine.

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

Drop it. 

```swift

var body: some View {
    SpotlightSearch(
        viewModel: spotlightViewModel,
        isSearching:$isSearching,
        didSearchKeyword: search,
        didTapItem: { print("didTapItem : \($0)") }) {
            /// 😎 your main UI goes here.
            Text("Your all main views goes here")
        }
}

```

If you would like use NavigationView, 

```swift

var body: some View {
    NavigationView {
        SpotlightSearch(
            viewModel: spotlightViewModel,
            isSearching:$isSearching,
            didSearchKeyword: search,
            didTapItem: { print("didTapItem : \($0)") }) {
                /// 😎 your main UI goes here.
                Text("Your all main views goes here")
        }
    }
}

```

<br>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
It includes examples for UIKit as well as SwiftUI.

## Requirements

- iOS 14.1 or later
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

//
//  ContentView.swift
//  QuickExample
//
//  Created by Seoksoon Jang on 2019/12/05.
//  Copyright © 2019 Seoksoon Jang. All rights reserved.
//

/// Step0: 😆 import `SpotlightSearch`!
import SpotlightSearch
import SwiftUI

struct ContentView: View {
    /// Step1: 🙃 This is "View Model" for Spotlight Search exclusively. 
    /// InitialDataSource can be mutated in runtime. 
    /// In order to mutate, use update method of SpotlightSearchViewModel. (refer to code example down below)
    /// InitialDataSource can be []. Then internally, Google auto suggestion is used out of box.
    
    @ObservedObject var spotlightViewModel = SpotlightSearchViewModel(initialDataSource:["Swift", "Clojure"])
    @State private var isSearching = false
    
    // This is your View Model Example.
    // It should be independent of SpotlightSearchViewModel.
    // It should never be related to SpotlightSearchViewModel.
    // Totally separate one.
    @ObservedObject var viewModel = LocalViewModel(helloText: "")
    
    // MARK: - Body
    
    /// Step2: 😆 Declare `SpotlightSearch` and inject spotlightViewModel.
    var body: some View {
        SpotlightSearch(
            viewModel: spotlightViewModel,
            isSearching:$isSearching,   // To show SpotlightSearch,
            didSearchKeyword: search,   // To update data source of SpotlightSearch,
            didTapItem: { print("didTapItem : \($0)") }) {  // When a search item is clicked,
            /// Step3: 😎 your UI goes here.
            
            NavigationView {
                yourMainView
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

// MARK: - Variables
extension ContentView {
    var yourMainView: some View {
        VStack {
            TextField("say something", text: $viewModel.helloText)
                .padding(100)
            
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
            
            Spacer()
        }
        
    }
}

// MARK: - Private Methods
extension ContentView {
    /// Optional Step: 🙃
    /// InitialDataSource of SpotlightSearchViewModel can be mutated in runtime. 
    /// In order to mutate, use update method of SpotlightSearchViewModel. (refer to code example down below)
    /// InitialDataSource can be []. Then internally, Google auto suggestion is used out of box.
    
    private func search(searchKeyword: String) {
        DispatchQueue.global().async {
            // Assuming you did finish your logic to fetch new data from anywhere.
            let res = generateRandomString(upto:500, isDuplicateAllowed: true)
            
            
            // after that, update data source.
            DispatchQueue.main.async {
                // To update data source of SpotlightSearch,
                // if not used, initialDataSource is used for your data source
                spotlightViewModel.update(dataSource:res)
            }
        }
    }
}

// This is your View Model Example.
// It should be independent of SpotlightSearchViewModel.
// It should never be related to SpotlightSearchViewModel.
// Totally separate one.
class LocalViewModel: ObservableObject {
    @Published var helloText: String
    
    init(helloText: String) {
        self.helloText = helloText
    }
}



```

The output is as follows:

![Alt Text](https://media.giphy.com/media/RfeIpyRRdJDCce9jfN/giphy.gif)

## Features

- [x] Written in SwiftUI and Combine 100%  
- [x] Provides Search UI on iOS in a similar way that macOS Spotlight does.
- [x] One liner, no brainer API

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

### Observers

[Observers](https://apps.apple.com/us/app/observers/id1560569802) : 
Location-based video browsing iOS app for showing what it may looks like!

![Image of Yaktocat](https://is2-ssl.mzstatic.com/image/thumb/PurpleSource114/v4/c7/3c/98/c73c983f-dce4-ae3c-f0ce-9609e5a2f509/440229b7-e3d3-4b0a-8c3e-59dedf901b0c_Simulator_Screen_Shot_-_iPhone_12_Pro_Max_-_2021-04-07_at_17.51.01.png/1284x2778bb.png)

![Image of Yaktocat](https://is4-ssl.mzstatic.com/image/thumb/PurpleSource124/v4/d3/d6/c6/d3d6c6dd-21e3-e29f-2181-f3591b36ab15/e0b39a29-3aa3-450b-a2b2-72a7a41b917d_Simulator_Screen_Shot_-_iPad_Pro__U002812.9-inch_U0029__U00284th_generation_U0029_-_2021-04-07_at_18.24.34.png/2048x2732bb.png)

![Image of Yaktocat](https://is5-ssl.mzstatic.com/image/thumb/PurpleSource114/v4/f5/e0/31/f5e031be-6ea1-fbe7-01c9-b02c16e19833/dde58902-490f-46ab-8251-06b6e4575db7_Simulator_Screen_Shot_-_iPhone_12_Pro_Max_-_2021-04-07_at_19.00.45.png/1284x2778bb.png)

<br><br><br>

### PhotoCell

[PhotoCell](https://apps.apple.com/us/app/observable/id1488022000?ls=1) : 
Time and Location-based photo browsing iOS app where you can download the photos and edit as you like for free.

<img align="left" src="https://firebasestorage.googleapis.com/v0/b/boraseoksoon-ff7d3.appspot.com/o/BSZoomGridScrollView%2Fo1.png?alt=media&token=f5003b58-f10f-4858-bb27-f4b0e06f6f70"> 

<img align="left" src="https://firebasestorage.googleapis.com/v0/b/boraseoksoon-ff7d3.appspot.com/o/BSZoomGridScrollView%2Fo2.png?alt=media&token=6374ba2c-0e58-478f-81a8-11eb5a5662e2"> 

<img align="left" src="https://firebasestorage.googleapis.com/v0/b/boraseoksoon-ff7d3.appspot.com/o/BSZoomGridScrollView%2Fo4.png?alt=media&token=11e22574-b854-45bf-a0a3-4b0c596db3f9">
