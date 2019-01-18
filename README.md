# Crypto Exchange Demo App

A Work In Progress :construction: crypto exchange app to try off Flutter potential

<img src="showcase.gif" width="400px" >

## Why this app?

I have been working on a similar app built with React Native and encounter some problems especially in implementing a custom design therefore I make this project as experiment to try out if those problems could be addressed in a better way using Flutter.

## React Native Problems and Flatter Solutions:

### 1. FlatList sticky header with a transparent background

#### Requirements

For this situation the whole app has a background image and on top of it we need a:

- Banner section (with scrolling)
- TabBar navigation section
- SortBar section
- TabView container
- Scrollable coins items inside each TabView container

When the user scroll up we want to the banner disappear, the TabBar and SortBar stick on top and (if there are many coin items) allow the user to scroll around the items.

#### React Native way

One why to achieve this in React Native could be move the rendering of the [react-native-tab-view](https://github.com/react-native-community/react-native-tab-view) (yes, this is the fastest way to the a TabView in React Native app) component inside the FlatList first item together with a SortBar component and use stickyHeaderIndices to make it stick on top when scrolling up.

But still, once we scroll up the list, all the items in the TabView will go under the transparent sticky header.

#### Flutter way

In Flatter we have CustomScrollView and Slivers that allow us to handle each aspect of the scrolling.

- For the background image we can customize the [Scaffold](lib/home.dart).
- For the banner we can use the simple [carousel_slider].(https://pub.dartlang.org/packages/carousel_slider) package.
- For the content we use slivers of a CustomScrollView and override the physics of the scrolling using ClampingScrollPhysics since we don't want the bouncing effect.
- The result can be see in the [market/main_tab.dart](lib/pages/market/main_tab.dart).

## Flutter showcase:

- [x] Sliver to build a custom scroll design
- [x] Change scrolling physics
- [x] Carousel banner
- [x] RxDart and Bloc pattern
- [ ] Localization
- [ ] CodePush
