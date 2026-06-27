import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/fruit_model.dart';

class GameViewModel extends ChangeNotifier {
  int _score = 0;
  int _bestScore = 0;
  final List<FruitModel> _fruits = [];
  final List<String> _fruitPool = ['🍒', '🍓', '🍇', '🍊', '🍎', '🍌', '🍍', '🍉'];
  
  String _nextFruit = '🍒';
  Timer? _fallingTimer;
  bool _isGameFinished = false;

  // 100% English Positive Quotes
  final List<String> _quotes = [
    "You did amazing! Keep shining! ✨",
    "Progress over perfection. Great job! 🌟",
    "Being the best doesn't mean being number one. ❤️",
    "Wonderful effort! You are getting better every game! 🚀",
    "You gave it your all, and that's what truly counts! 💯",
    "A fantastic attempt! Believe in your potential. ⚡",
    "Success is about giving your best effort every day. 🎯",
    "Beautifully played! Take a deep breath and smile. 😊"
  ];
  String _currentQuote = "";
  int _playCount = 0;

  GameViewModel() {
    _generateNextFruit();
  }

  int get score => _score;
  int get bestScore => _bestScore;
  List<FruitModel> get fruits => _fruits;
  String get nextFruit => _nextFruit;
  bool get isGameFinished => _isGameFinished;
  List<String> get fruitPool => _fruitPool;
  String get currentQuote => _currentQuote;

  // Dynamic Pastel Theme Colors
  Color get backgroundColor {
    int index = _playCount % 4;
    if (index == 1) return const Color(0xFFFCE8E6); // Pastel Red
    if (index == 2) return const Color(0xFFE6F4EA); // Pastel Green
    if (index == 3) return const Color(0xFFE8F0FE); // Pastel Blue
    return const Color(0xFFF0E3F7); // Default Purple
  }

  Color get primaryColor {
    int index = _playCount % 4;
    if (index == 1) return const Color(0xFF660E0D); // Deep Red
    if (index == 2) return const Color(0xFF0D441D); // Deep Green
    if (index == 3) return const Color(0xFF0B2F61); // Deep Blue
    return const Color(0xFF3A1E54); // Default Deep Purple
  }

  Color get accentColor {
    int index = _playCount % 4;
    if (index == 1) return Colors.red;
    if (index == 2) return Colors.green;
    if (index == 3) return Colors.blue;
    return Colors.purple;
  }

  void _generateNextFruit() {
    _nextFruit = _fruitPool[Random().nextInt(4)];
  }

  void handleAreaTap(Offset position) {
    if (_isGameFinished) return;

    _score++;
    if (_score > _bestScore) {
      _bestScore = _score;
    }
    
    double spawnX = position.dx;
    double spawnY = 20.0; 
    
    _fruits.add(FruitModel(position: Offset(spawnX, spawnY), emoji: _nextFruit));
    _generateNextFruit();
    _startFallingMechanism();
    
    notifyListeners();
  }

  void _startFallingMechanism() {
    if (_fallingTimer != null && _fallingTimer!.isActive) return;

    _fallingTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      bool valuesChanged = false;
      double groundLevel = 410.0; 

      for (int i = 0; i < _fruits.length; i++) {
        double targetY = groundLevel;

        for (int j = 0; j < _fruits.length; j++) {
          if (i == j) continue;

          if (_fruits[j].position.dy > _fruits[i].position.dy &&
              (_fruits[i].position.dx - _fruits[j].position.dx).abs() < 32.0) {
            
            double stopAt = _fruits[j].position.dy - 30.0;
            if (stopAt < targetY) {
              targetY = stopAt;
            }
          }
        }

        if (_fruits[i].position.dy < targetY) {
          double nextY = _fruits[i].position.dy + 8;
          if (nextY > targetY) nextY = targetY;

          _fruits[i] = FruitModel(
            position: Offset(_fruits[i].position.dx, nextY),
            emoji: _fruits[i].emoji,
          );
          valuesChanged = true;
        }
      }

      if (!valuesChanged) {
        timer.cancel();
        _checkMergeLogic();
      }

      notifyListeners();
    });
  }

  void _checkMergeLogic() {
    bool mergedOccurred = false;

    for (int i = 0; i < _fruits.length; i++) {
      for (int j = i + 1; j < _fruits.length; j++) {
        if (_fruits[i].emoji == _fruits[j].emoji) {
          double distance = (_fruits[i].position - _fruits[j].position).distance;
          
          if (distance < 38.0) {
            int currentIndex = _fruitPool.indexOf(_fruits[i].emoji);
            int nextIndex = (currentIndex + 1) % _fruitPool.length;
            String upgradedEmoji = _fruitPool[nextIndex];

            Offset midPoint = Offset(
              (_fruits[i].position.dx + _fruits[j].position.dx) / 2,
              (_fruits[i].position.dy + _fruits[j].position.dy) / 2,
            );

            var fruit1 = _fruits[i];
            var fruit2 = _fruits[j];
            _fruits.remove(fruit1);
            _fruits.remove(fruit2);

            _fruits.add(FruitModel(position: midPoint, emoji: upgradedEmoji));

            _score += 15;
            if (_score > _bestScore) _bestScore = _score;

            mergedOccurred = true;
            break;
          }
        }
      }
      if (mergedOccurred) break;
    }

    if (mergedOccurred) {
      _startFallingMechanism();
    } else {
      _checkFinishCondition();
    }
  }

  void _generateNextFruitOnFinish() {
     _currentQuote = _quotes[Random().nextInt(_quotes.length)];
  }

  void _checkFinishCondition() {
    for (var fruit in _fruits) {
      if (fruit.position.dy < 60.0) {
        _isGameFinished = true;
        _generateNextFruitOnFinish();
        _fallingTimer?.cancel();
        break;
      }
    }
    notifyListeners();
  }

  void replayGame() {
    _playCount++; 
    _score = 0;
    _isGameFinished = false;
    _fruits.clear();
    _generateNextFruit();
    notifyListeners();
  }

  void resetGame() {
    _fallingTimer?.cancel();
    _score = 0;
    _isGameFinished = false;
    _fruits.clear();
    _generateNextFruit();
    notifyListeners();
  }

  @override
  void dispose() {
    _fallingTimer?.cancel();
    super.dispose();
  }
}