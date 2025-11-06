# API Service Layer Implementation Plan

This plan outlines the phased implementation of the API service layer in the Flutter project, following the approved design document. Each phase includes specific tasks, code quality checks, and a journal for tracking progress and deviations.

## Journal

### Phase 1: Setup and Base API Client

*   **Actions Taken:**
    *   Created `lib/src/data/models`, `lib/src/data/network`, `lib/src/data/services` directories.
    *   Created `lib/src/data/network/app_exceptions.dart` with custom exception classes.
    *   Created `lib/src/data/network/api_client.dart` with basic HTTP methods (`get`, `post`, `put`, `delete`) and generic error handling.
    *   Added `http`, `json_annotation`, `json_serializable`, and `build_runner` to `pubspec.yaml`.
    *   Ran `flutter pub get`.
    *   Ran `dart_fix` (no fixes needed).
    *   Ran `analyze_files` (some non-critical issues found, noted for later).
    *   Ran `dart_format` (formatted new files).
*   **Learnings:** Initial setup of `http` client and custom exceptions is straightforward. The `_getToken()` method in `ApiClient` is a placeholder and will need actual implementation for secure token retrieval.
*   **Surprises:** `mkdir -p` syntax for multiple directories in PowerShell required separate commands.
*   **Deviations:** None.

## Implementation Phases

### Phase 1: Setup and Base API Client

*   **Goal:** Establish the foundational API client and error handling mechanisms.
*   **Tasks:**
    *   [x] Create the directory structure: `lib/src/data/models`, `lib/src/data/network`, `lib/src/data/services`.
    *   [x] Create `lib/src/data/network/app_exceptions.dart` with custom exception classes (`ApiException`, `NetworkException`, `UnauthorizedException`, etc.).
    *   [x] Create `lib/src/data/network/api_client.dart`:
        *   Implement `ApiClient` class with `_baseUrl` and `http.Client`.
        *   Implement `get`, `post`, `put`, `delete` methods.
        *   Implement generic error handling to throw custom `AppException` types.
        *   Add a placeholder for `_getToken()` method for authorization headers.
    *   [x] Add `http`, `json_annotation` to `dependencies` in `pubspec.yaml`.
    *   [x] Add `json_serializable`, `build_runner` to `dev_dependencies` in `pubspec.yaml`.
    *   [x] Run `flutter pub get`.
    *   [x] Run the `dart_fix` tool to clean up the code.
    *   [x] Run the `analyze_files` tool one more time and fix any issues.
    *   [x] Run `dart_format` to make sure that the formatting is correct.
    *   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
    *   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
    *   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
    *   [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
    *   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 2: User Data Models and Service

*   **Goal:** Implement data models and API service for user-related operations.
*   **Tasks:**
    *   [ ] Create `lib/src/data/models/user.dart`:
        *   Define `User` and `UserCreate` classes with `@JsonSerializable` annotations.
        *   Implement `fromJson` and `toJson` factory methods.
    *   [ ] Run `dart run build_runner build --delete-conflicting-outputs` to generate `user.g.dart`.
    *   [ ] Create `lib/src/data/services/user_api_service.dart`:
        *   Implement `UserApiService` with `ApiClient` dependency.
        *   Implement `getMe`, `createUser`, `updatePassword` methods.
    *   [ ] Run the `dart_fix` tool to clean up the code.
    *   [ ] Run the `analyze_files` tool one more time and fix any issues.
    *   [ ] Run `dart_format` to make sure that the formatting is correct.
    *   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
    *   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
    *   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
    *   [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
    *   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 3: Integrate User Service into UI (Example)

*   **Goal:** Demonstrate integration of the `UserApiService` into a UI component.
*   **Tasks:**
    *   [ ] Identify a suitable UI component (e.g., a user profile screen or login screen) to integrate `UserApiService`.
    *   [ ] Modify the UI component to use `UserApiService` for data fetching (e.g., `getMe()`).
    *   [ ] Implement basic error display in the UI for API service exceptions.
    *   [ ] Run the `dart_fix` tool to clean up the code.
    *   [ ] Run the `analyze_files` tool one more time and fix any issues.
    *   [ ] Run `dart_format` to make sure that the formatting is correct.
    *   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
    *   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
    *   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
    *   [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
    *   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 4: Remaining API Services (Iterative)

*   **Goal:** Implement data models and API services for the remaining backend tags.
*   **Tasks:**
    *   [ ] For each remaining backend tag (e.g., `appointments`, `medical_records`, `payments`, `prescriptions`, `queue`, `reports`, `transactions`):
        *   [ ] Create `lib/src/data/models/<tag_name>.dart` with relevant data models and `json_serializable` annotations.
        *   [ ] Run `dart run build_runner build --delete-conflicting-outputs`.
        *   [ ] Create `lib/src/data/services/<tag_name>_api_service.dart` with `ApiClient` dependency and methods for relevant API operations.
    *   [ ] Run the `dart_fix` tool to clean up the code.
    *   [ ] Run the `analyze_files` tool one more time and fix any issues.
    *   [ ] Run `dart_format` to make sure that the formatting is correct.
    *   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
    *   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
    *   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
    *   [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
    *   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 5: Finalization and Documentation

*   **Goal:** Complete the implementation and update project documentation.
*   **Tasks:**
    *   [ ] Update any `README.md` file for the package with relevant information from the modification (if any).
    *   [ ] Update any `GEMINI.md` file in the project directory so that it still correctly describes the app, its purpose, and implementation details and the layout of the files.
    *   [ ] Ask the user to inspect the package (and running app, if any) and say if they are satisfied with it, or if any modifications are needed.
