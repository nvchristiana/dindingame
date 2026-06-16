# DinDin Game - MVVM Architecture Implementation

A hyper-casual drop-and-merge mobile game built using Flutter and Dart, implementing the MVVM (Model-View-ViewModel) architectural pattern and Provider for state management.

## MVVM Architectural Components

This project strictly adheres to the separation of concerns by dividing the application into three core layers:

1. **Model**: Represents the data structures and business entities. In this project, `FruitModel` handles the tracking of local coordinate data (`Offset`) and emoji types for each spawned fruit item.
2. **ViewModel**: Manages the application state and core business logic. Extending `ChangeNotifier`, `GameViewModel` encapsulates all game operations such as score tracking, high score evaluation, and notifying UI views reactively via `notifyListeners()`.
3. **View**: Represents the user interface layer. Built utilizing declarative Flutter widgets (`DinDinMainMenu` and `DinDinGameScreen`), this layer remains passive and relies on the `Consumer` widget to rebuild UI components flexibly whenever changes occur in the ViewModel layer.

## Dependencies

- `provider`: ^6.1.5 (State management)

## AFL 3 - Automated Testing Implementation

Proyek ini telah dilengkapi dengan pengujian otomatis (*automated testing*) berlapis untuk memastikan kualitas kode dan fungsionalitas UI berjalan dengan stabil:

- **Unit Testing (`test/game_viewmodel_test.dart`)**: Menguji isolasi logika bisnis pada `GameViewModel` untuk memastikan fungsi penambahan skor (`handleAreaTap`) dan pembersihan data (`resetGame`) berjalan dengan benar sesuai dengan pola pengujian AAA (*Arrange, Act, Assert*).
- **Widget Testing (`test/widget_test.dart`)**: Menguji komponen antarmuka pengguna pada `DinDinGameScreen` menggunakan `WidgetTester` untuk memastikan elemen teks petunjuk permainan awal ter-render dengan sempurna di pohon widget aplikasi.

## How to Run the Application

1. Clone this repository to your local machine.
2. Ensure you have the Flutter SDK installed and properly configured.
3. Open the project folder in your preferred code editor (e.g., VS Code).
4. Run the following command in the terminal to fetch packages:
```bash
   flutter pub get