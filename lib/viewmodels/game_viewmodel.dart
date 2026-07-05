import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/fruit_model.dart';

class GameViewModel extends ChangeNotifier {
  int _score = 0;
  int _bestScore = 0;
  final List<FruitModel> _fruits = [];
  
  // DATA POOL EMOJI: Mengelola 3 Tema Utama secara dinamis
  final Map<String, List<String>> _allThemes = {
    'Fruit': ['🍒', '🍓', '🍇', '🍊', '🍎', '🍌', '🍍', '🍉'],
    'Food': ['🥨', '🥯', '🥞', '🍔', '🍕', '🌮', '🍣', '🍱'],
    'Drink': ['☕', '🍵', '🥤', '🧋', '🍺', '🍷', '🍸', '🍹'],
  };

  String _selectedTheme = 'Fruit'; // Pilihan default awal
  List<String> _currentPool = ['🍒', '🍓', '🍇', '🍊', '🍎', '🍌', '🍍', '🍉'];
  
  String _nextFruit = '🍒';
  Timer? _fallingTimer;
  bool _isGameFinished = false;

  final List<String> _quotes = [
    "You did amazing! Keep shining! ✨",
    "Progress over perfection. Great job! 🌟",
    "Wonderful effort! You are getting better every game! 🚀",
    "Success is about giving your best effort every day. 🎯",
    "Beautifully played! Take a deep breath and smile. 😊"
  ];
  String _currentQuote = "";
  int _playCount = 0;

  String _difficulty = 'Normal'; 
  String _boxTheme = 'Classic';
  bool _isGridOn = false;

  GameViewModel() {
    _updatePool();
  }

  // ==================== ENKAPSULASI / GETTERS ====================
  int get score => _score;
  int get bestScore => _bestScore;
  List<FruitModel> get fruits => _fruits;
  String get nextFruit => _nextFruit;
  bool get isGameFinished => _isGameFinished;
  List<String> get fruitPool => _currentPool;
  String get currentQuote => _currentQuote;
  String get difficulty => _difficulty;
  String get boxTheme => _boxTheme;
  String get selectedTheme => _selectedTheme;
  bool get isGridOn => _isGridOn;

  // ==================== LOGIKA CORE MVVM ====================
  
  // Fungsi Mengganti Tema Kumpulan Emoji
  void setEmojiTheme(String themeName) {
    _selectedTheme = themeName;
    _updatePool();
    resetGame(); // Reset game agar item tema lama otomatis bersih dari kotak
    notifyListeners();
  }

  void _updatePool() {
    _currentPool = _allThemes[_selectedTheme]!;
    _generateNextFruit();
  }

  void setDifficulty(String value) {
    _difficulty = value;
    notifyListeners();
  }

  void setBoxTheme(String value) {
    _boxTheme = value;
    notifyListeners();
  }

  void setGridOn(bool value) {
    _isGridOn = value;
    notifyListeners();
  }

  // Logika Pewarnaan Wadah Gameplay
  Color get boxThemeColor {
    if (_boxTheme == 'Wood') return const Color(0xFFF5DEB3);
    if (_boxTheme == 'Grass') return const Color(0xFFE8F5E9);
    return Colors.white; 
  }

  // Logika Perubahan Tema Warna Latar Belakang (Dinamis tiap Sesi)
  Color get backgroundColor {
    int index = _playCount % 4;
    if (index == 1) return const Color(0xFFFCE8E6); 
    if (index == 2) return const Color(0xFFE6F4EA); 
    if (index == 3) return const Color(0xFFE8F0FE); 
    return const Color(0xFFF0E3F7); 
  }

  Color get primaryColor {
    int index = _playCount % 4;
    if (index == 1) return const Color(0xFF660E0D); 
    if (index == 2) return const Color(0xFF0D441D); 
    if (index == 3) return const Color(0xFF0B2F61); 
    return const Color(0xFF3A1E54); 
  }

  Color get accentColor {
    int index = _playCount % 4;
    if (index == 1) return Colors.red;
    if (index == 2) return Colors.green;
    if (index == 3) return Colors.blue;
    return Colors.purple;
  }

  void _generateNextFruit() {
    _nextFruit = _currentPool[Random().nextInt(4)];
  }

  // Menerima Aksi Ketukan Jari dari View (Screen)
  void handleAreaTap(Offset position) {
    if (_isGameFinished) return;
    
    _score++;
    if (_score > _bestScore) {
      _bestScore = _score;
    }
    
    _fruits.add(FruitModel(position: Offset(position.dx, 20.0), emoji: _nextFruit));
    _generateNextFruit();
    _startFallingMechanism();
    notifyListeners();
  }

  // Simulasi Mekanisme Gravitasi Jatuh Berbasis Software (60 FPS)
  void _startFallingMechanism() {
    if (_fallingTimer != null && _fallingTimer!.isActive) return;
    
    _fallingTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      bool valuesChanged = false;
      double groundLevel = 410.0; 
      double fallingSpeed = _difficulty == 'Easy' ? 4.0 : 8.0;

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
          double nextY = _fruits[i].position.dy + fallingSpeed; 
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

  // Logika Pengecekan Tabrakan & Evolusi Penggabungan (Merge Logic)
  void _checkMergeLogic() {
    bool mergedOccurred = false;
    
    for (int i = 0; i < _fruits.length; i++) {
      for (int j = i + 1; j < _fruits.length; j++) {
        if (_fruits[i].emoji == _fruits[j].emoji) {
          double distance = (_fruits[i].position - _fruits[j].position).distance;
          
          if (distance < 38.0) {
            int currentIndex = _currentPool.indexOf(_fruits[i].emoji);
            int nextIndex = (currentIndex + 1) % _currentPool.length;
            String upgradedEmoji = _currentPool[nextIndex];
            
            Offset midPoint = Offset(
              (_fruits[i].position.dx + _fruits[j].position.dx) / 2, 
              (_fruits[i].position.dy + _fruits[j].position.dy) / 2,
            );
            
            // Penghapusan indeks aman dari belakang (j dulu baru i agar indeks tidak geser)
            _fruits.removeAt(j); 
            _fruits.removeAt(i);
            
            _fruits.add(FruitModel(position: midPoint, emoji: upgradedEmoji));
            _score += 15;
            
            if (_score > _bestScore) {
              _bestScore = _score;
            }
            
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

  // Validasi Kondisi Kekalahan (Menyentuh Garis Batas Atas)
  void _checkFinishCondition() {
    for (var fruit in _fruits) {
      if (fruit.position.dy < 60.0) {
        _isGameFinished = true;
        _currentQuote = _quotes[Random().nextInt(_quotes.length)];
        _fallingTimer?.cancel();
        break;
      }
    }
    notifyListeners();
  }

  // Reset Sesi Bermain Lagi
  void replayGame() { 
    _playCount++; 
    resetGame(); 
  }

  // Reset Total Kondisi Board Permainan
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