# Deloitte-Challenge

This is a small demo app for Deloitte's Code Challenge. I used MVVM as the main Architecture as they required. Beside of that I created Global API Manager to handling networks communication. Alamofire was used in side that API Manager. ViewModel was used to communicate between view and network layer. Most of the common UI core modification was implemented using Extension. 

I'm using Swift 5 for this project. CocoaPod was used for Dependencies Management. 

To prevent spamming to OMBD API I limited the characters length to at least 5.

As there is no information about the movie's trailer. So I decide to navigate user to Youtube with the predefined keyword when user tapped on the trailer button.

## Build the app

Clone this repository to you MAC. Navigate to project's root folder and run pod install using
```
pod install
```
When pod installed build the app in iOS Simulator. If you want to try the app on real device. You need to install corresponding Provisioning profile and Developer certificate with App's Bundle ID.

## Screenshots
<p float="left">
    <img src="https://github.com/quocman-sutrix/Deloitte-Challenge/blob/master/screenshots/deloitte-3.png?raw=true" width="250" />
    <img src="https://github.com/quocman-sutrix/Deloitte-Challenge/blob/master/screenshots/deloitte-2.png?raw=true" width="250" />
    <img src="https://github.com/quocman-sutrix/Deloitte-Challenge/blob/master/screenshots/deloitte-1.png?raw=true" width="250" />
</p>