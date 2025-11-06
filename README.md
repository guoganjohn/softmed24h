# softmed24h

A new MeuMed project.

## API Service Layer

This project now includes a structured API service layer designed to handle all communication with the backend REST API. This layer promotes a clear separation of concerns, making the application more maintainable, testable, and scalable.

### Architecture:

*   **`ApiClient`**: A central client (`lib/src/data/network/api_client.dart`) responsible for core HTTP requests, managing base URLs, handling common headers (like `Authorization` tokens), and implementing generic error handling. It uses the `http` package for network operations.
*   **Feature-Specific API Services**: Dedicated service classes (e.g., `lib/src/data/services/user_api_service.dart`, `lib/src/data/services/appointments_api_service.dart`) encapsulate all API calls related to specific backend tags or domains. These services utilize the `ApiClient` to perform requests and transform raw JSON responses into structured Dart models.
*   **Data Models**: All data structures exchanged with the API are represented by Dart classes located in `lib/src/data/models/`. These models are annotated with `@JsonSerializable` and leverage `json_serializable` and `build_runner` for efficient and error-free JSON parsing and serialization.

### Benefits:

*   **Improved Maintainability**: API logic is centralized and organized by feature, making it easier to locate and modify.
*   **Enhanced Testability**: API services can be easily mocked for isolated unit and widget testing, reducing reliance on actual network calls during development.
*   **Consistent Error Handling**: A unified approach to error management ensures a better user experience and simplifies debugging.
*   **Reduced Code Duplication**: Common networking tasks and data transformations are handled in a single place.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
