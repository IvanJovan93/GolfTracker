# GolfTracker

GolfTracker is a SwiftUI application that retrieves and displays user profiles of friends using an external JSON API. The app efficiently manages image caching and handles asynchronous data loading while following best practices in Swift development.

---- Purpose ----
The primary purpose of the app is to present a user-friendly interface for viewing user profiles, where each profile includes essential information like names, profile pictures, and other relevant data. The app aims to enhance user experience by providing fast loading times and seamless image management.

---- Architecture ----
The architecture of GolfTrackerApp is based on the following principles:

**1. Separation of Concerns**
Each component of the app has a distinct responsibility, making it easier to maintain and test.

View Layer: SwiftUI views such as UserProfilesListView handle the presentation logic.
ViewModel Layer: Classes like UserProfilesViewModel manage the app’s state and business logic, mediating between the view and the data layer.
Data Layer: Protocols and classes like UserListLoaderProtocol, RemoteUserLoaderService, and HTTPClientProtocol manage data retrieval, adhering to the Dependency Injection principle.

**2. Dependency Injection**
The app uses a ServiceContainer to manage service instances. This approach enhances testability and reduces tight coupling between components. For example, RemoteUserLoaderService depends on HTTPClientProtocol, allowing for easy swapping of different implementations during testing or future development.

**3. MVVM Pattern**
The Model-View-ViewModel (MVVM) design pattern is employed:

Model: Represents the data structures like UserProfile that conform to Decodable.
View: SwiftUI views render the UI based on the ViewModel’s published properties.
ViewModel: The UserProfilesViewModel fetches data, handles business logic, and updates the view when the data changes.

**4. Caching Mechanism**
The ImageCacheManager class handles image caching to optimize performance and reduce unnecessary network requests. It employs a concurrent queue to manage concurrent image fetching and caching operations efficiently.

**6. Protocol-Oriented Programming**
Protocols are heavily utilized throughout the app, allowing for a flexible and modular design. For instance, HTTPClientProtocol and UserListLoaderProtocol define contracts that can be implemented by different classes, promoting code reuse and simplifying testing.


---- Positive Points of the Architecture ----

Scalability: The use of dependency injection and protocols makes it easier to scale components independently.
Testability: Services can be mocked, allowing for unit testing of ViewModels and Views without relying on real data.
Maintainability: Clear separation of concerns and adherence to SOLID principles lead to a codebase that is easier to maintain and extend.

