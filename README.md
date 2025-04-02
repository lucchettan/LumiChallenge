# Lumi Challenge
<img src="https://github.com/user-attachments/assets/86ff9f4e-6e44-429d-a8b5-965f6503c1e9" alt="Lumi Icon" width="120" />

A modern iOS app built with SwiftUI that displays hierarchical content with a book-like page navigation interface.

## Project Summary

LumiChallenge is a content viewing application that displays nested content in a clean, intuitive interface. The app fetches JSON content from a server and presents it in a tab-based navigation system that allows users to swipe between pages. It features:

- Page-based navigation with smooth transitions
- Hierarchical content display with sections and nested items
- Full-screen image viewing with zoom capabilities
- Offline mode with local content caching
- Error handling and network resilience

## Installation & Running the App

### Requirements

- iOS 17.0+ / macOS 13.0+
- Xcode 14.0+
- Swift 5.7+

### Getting Started

1. Clone the repository
```bash
git clone https://github.com/yourusername/LumiChallenge.git
cd LumiChallenge
```

2. Open the project in Xcode
```bash
open LumiChallenge.xcodeproj
```

3. Select a simulator or device and press Run (⌘+R)

## Architecture

This project is built using Swift and SwiftUI, following the MVVM (Model-View-ViewModel) architectural pattern and Clean Architecture principles.

### Key Components

- **Models**: Data structures representing content items (pages, sections, text, images)
- **Views**: SwiftUI views that display content and handle user interactions
- **ViewModels**: Business logic components that transform data and manage view state
- **Resources**: Network and cache services that handle data fetching and persistence

### Project Structure

```
LumiChallenge/
├── Models/              # Data models and structures
├── Views/               # SwiftUI views and components
│   ├── Components/      # Reusable UI components
├── ViewModels/          # View models for business logic
├── Resources/           # Network services and utilities, Assets, configuration files
```

## Implementation Details

### Content Fetching and Display

The app fetches content from a remote JSON API and displays it in a hierarchical structure. Pages can be navigated using a swipe gesture, similar to a book's pages.

### Page Extraction Algorithm

The app extracts nested pages from the content structure, flattening them into a sequence that can be navigated like a book. This eliminates the need for deep navigation while maintaining the logical hierarchy of content.

### Offline Support

The app includes a caching system that allows users to view content even when offline:

- Content is automatically cached when fetched
- If a network request fails, the app falls back to cached content
- Users are informed when they're viewing offline content
- A retry mechanism allows refreshing when connectivity is restored

### Image Handling

The app provides async image viewing experience:

- Asynchronous image loading with loading indicators
- Full-screen image viewing with pinch-to-zoom
- Double-tap to zoom in/out
- Reload option for failed image loads

## Bonus Implementations

### 1. Network Resilience

The app includes error handling and network resilience features:

- Custom error types with meaningful messages
- Automatic fallback to cached content
- Visual indicators for connection status
- Retry mechanisms for failed requests

### 2. Image Zoom & Manipulation

The image viewer includes advanced features:

- Smooth pinch-to-zoom with gesture recognition
- Double-tap to zoom in/out
- Memory-efficient image caching
- Failed-load retry options

## Attributions

This project does not use any third-party libraries, focusing instead on native iOS frameworks:

- SwiftUI for the user interface
- Combine for reactive programming
- Swift concurrency (async/await) for asynchronous operations
- FileManager for local caching
