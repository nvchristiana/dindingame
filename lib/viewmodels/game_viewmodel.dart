import 'dart:math';
import 'package:flutter/material.dart';
import '../models/fruit_model.dart';

class GameViewModel extends ChangeNotifier {
  int _score = 0;
  int _bestScore = 0;
  final List<FruitModel> _fruits = [];
  final List<String> _fruitPool = ['🍇', '🍎', '🍊', '🍉', '🍌', '🍒', '🍓', '🍍'];
  
  // Variabel untuk menyimpan buah di antrean berikutnya
  String _nextFruit = '🍇';

  GameViewModel() {
    // Acak buah pertama kali saat game dibuka
    _generateNextFruit();
  }

  int get score => _score;
  int get bestScore => _bestScore;
  List<FruitModel> get fruits => _fruits;
  String get nextFruit => _nextFruit; // Getter agar bisa dibaca UI

  // Fungsi internal untuk mengacak buah berikutnya
  void _generateNextFruit() {
    _nextFruit = _fruitPool[Random().nextInt(_fruitPool.length)];
  }

  void handleAreaTap(Offset position) {
    _score++;
    if (_score > _bestScore) {
      _bestScore = _score;
    }
    
    // 1. Jatuhkan buah yang SEDANG AKTIF di antrean "Next" saat ini
    _fruits.add(FruitModel(position: position, emoji: _nextFruit));
    
    // 2. Setelah dijatuhkan, acak buah BARU untuk antrean berikutnya
    _generateNextFruit();
    
    notifyListeners();
  }

  void resetGame() {
    _score = 0;
    _fruits.clear();
    _generateNextFruit(); // Reset antrean buah baru
    notifyListeners();
  }
}