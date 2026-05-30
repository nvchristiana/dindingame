# DinDin Game - MVVM Architecture Implementation

[cite_start]A hyper-casual drop-and-merge mobile game built using Flutter and Dart, implementing the MVVM (Model-View-ViewModel) architectural pattern and Provider for state management[cite: 1, 2, 16].

## MVVM Architectural Components

[cite_start]This project strictly adheres to the separation of concerns by dividing the application into three core layers:

1. [cite_start]**Model**: Represents the data structures and business entities[cite: 10]. [cite_start]In this project, `FruitModel` handles the tracking of local coordinate data (`Offset`) and emoji types for each spawned fruit item[cite: 18].
2. [cite_start]**ViewModel**: Manages the application state and core business logic[cite: 12]. [cite_start]Extending `ChangeNotifier`, `GameViewModel` encapsulates all game operations such as score tracking, high score evaluation, and notifying UI views reactively via `notifyListeners()`[cite: 21].
3. [cite_start]**View**: Represents the user interface layer[cite: 11]. [cite_start]Built utilizing declarative Flutter widgets (`DinDinMainMenu` and `DinDinGameScreen`), this layer remains passive and relies on the `Consumer` widget to rebuild UI components flexibly whenever changes occur in the ViewModel layer[cite: 23, 24].

## Dependencies

- [cite_start]`provider`: ^6.1.5 (State management) [cite: 16]

## How to Run the Application

1. [cite_start]Clone this repository to your local machine[cite: 31].
2. Ensure you have the Flutter SDK installed and properly configured.
3. Open the project folder in your preferred code editor (e.g., VS Code).
4. Run the following command in the terminal to fetch packages:
   ```bash
   flutter pub get