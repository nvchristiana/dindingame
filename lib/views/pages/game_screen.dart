import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/game_viewmodel.dart';

class DinDinGameScreen extends StatelessWidget {
  const DinDinGameScreen({super.key});

  // Fungsi Menu Pengaturan Bawah (Settings Bottom Sheet Overlay)
  void _showSettingsBottomSheet(BuildContext context, GameViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: viewModel.backgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Garis Handle Bar di Atas Sheet
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Text(
                    'Settings Menu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: viewModel.primaryColor,
                    ),
                  ),
                  const Divider(),
                  
                  // ==================== 1. DIFFICULTY (Radio) ====================
                  const SizedBox(height: 15),
                  _buildSectionTitle('Game Difficulty', viewModel),
                  Row(
                    children: ['Easy', 'Normal'].map((mode) {
                      return _buildRadioOption(
                        mode,
                        viewModel.difficulty,
                        (value) {
                          viewModel.setDifficulty(value!);
                          setModalState(() {}); 
                        },
                        viewModel,
                      );
                    }).toList(),
                  ),

                  // ==================== 2. GRID DISPLAY (Radio) ====================
                  const SizedBox(height: 15),
                  _buildSectionTitle('Grid Display', viewModel),
                  Row(
                    children: [
                      _buildRadioOptionBool(
                        'On',
                        true,
                        viewModel.isGridOn,
                        (value) {
                          viewModel.setGridOn(value!);
                          setModalState(() {});
                        },
                        viewModel,
                      ),
                      const SizedBox(width: 20),
                      _buildRadioOptionBool(
                        'Off',
                        false,
                        viewModel.isGridOn,
                        (value) {
                          viewModel.setGridOn(value!);
                          setModalState(() {});
                        },
                        viewModel,
                      ),
                    ],
                  ),

                  // ==================== 3. EMOJI THEME (Buttons) ====================
                  const SizedBox(height: 20),
                  _buildSectionTitle('Emoji Theme', viewModel),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Fruit', 'Food', 'Drink'].map((theme) {
                      bool isSelected = viewModel.selectedTheme == theme;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? viewModel.primaryColor : Colors.white,
                          foregroundColor: isSelected ? Colors.white : viewModel.primaryColor,
                          elevation: isSelected ? 3 : 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () { 
                          viewModel.setEmojiTheme(theme); 
                          setModalState(() {}); 
                        },
                        child: Text(
                          theme,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),

                  // ==================== 4. BOX STYLE (Buttons) ====================
                  const SizedBox(height: 20),
                  _buildSectionTitle('Gameplay Box Style', viewModel),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Classic', 'Wood', 'Grass'].map((theme) {
                      bool isSelected = viewModel.boxTheme == theme;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? viewModel.primaryColor : Colors.white,
                          foregroundColor: isSelected ? Colors.white : viewModel.primaryColor,
                          elevation: isSelected ? 3 : 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () { 
                          viewModel.setBoxTheme(theme); 
                          setModalState(() {}); 
                        },
                        child: Text(
                          theme,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Dialog Konfirmasi Bermain Lagi (Replay Dialog Confirmation) - DIPASANG KEMBALI
  void _showReplayConfirmation(BuildContext context, GameViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: viewModel.backgroundColor,
          title: Text(
            'Confirmation',
            style: TextStyle(fontWeight: FontWeight.bold, color: viewModel.primaryColor),
          ),
          content: const Text(
            'You have already played today. Are you sure you want to play again?',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: viewModel.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Yes', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                viewModel.replayGame(); 
              },
            ),
          ],
        );
      },
    );
  }

  // Helper Widget: Judul per bagian menu
  Widget _buildSectionTitle(String title, GameViewModel vm) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: vm.primaryColor.withOpacity(0.8),
      ),
    );
  }

  // Helper Widget: Pilihan Radio untuk Teks
  Widget _buildRadioOption(String label, String group, Function(String?) onChange, GameViewModel vm) {
    return Row(
      children: [
        Radio<String>(
          value: label,
          groupValue: group,
          activeColor: vm.accentColor,
          onChanged: onChange,
        ),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  // Helper Widget: Pilihan Radio untuk Boolean
  Widget _buildRadioOptionBool(String label, bool value, bool group, Function(bool?) onChange, GameViewModel vm) {
    return Row(
      children: [
        Radio<bool>(
          value: value,
          groupValue: group,
          activeColor: vm.accentColor,
          onChanged: onChange,
        ),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  // ==================== UI LAYOUT UTAMA GAME ====================
  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, gameViewModel, child) {
        return Scaffold(
          backgroundColor: gameViewModel.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: gameViewModel.primaryColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.refresh, color: gameViewModel.primaryColor),
                            onPressed: () => gameViewModel.resetGame(),
                          ),
                          IconButton(
                            icon: Icon(Icons.settings, color: gameViewModel.primaryColor),
                            onPressed: () => _showSettingsBottomSheet(context, gameViewModel),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '🍇 DinDin',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: gameViewModel.primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Tap to drop the items',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: gameViewModel.accentColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Dashboard Skor
                  Row(
                    children: [
                      _buildScoreCard('SCORE', gameViewModel.score.toString(), gameViewModel.accentColor),
                      const SizedBox(width: 15),
                      _buildScoreCard('BEST SCORE', gameViewModel.bestScore.toString(), Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Wadah Antrean Berikutnya
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8), 
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next: ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: gameViewModel.primaryColor.withOpacity(0.7),
                          ),
                        ),
                        Text(gameViewModel.nextFruit, style: const TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // AREA UTAMA GAME
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15)],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: gameViewModel.accentColor.withOpacity(0.12),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.flag, color: gameViewModel.accentColor, size: 16),
                                const SizedBox(width: 5),
                                Text('Finish Line', style: TextStyle(color: gameViewModel.accentColor, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: gameViewModel.boxThemeColor, 
                              child: GestureDetector(
                                onTapDown: (details) => gameViewModel.handleAreaTap(details.localPosition),
                                behavior: HitTestBehavior.opaque,
                                child: Stack(
                                  children: [
                                    if (gameViewModel.isGridOn)
                                      Positioned.fill(child: CustomPaint(painter: GridPainter())),

                                    if (gameViewModel.selectedTheme == 'Fruit' && gameViewModel.boxTheme == 'Classic')
                                      const Center(child: Opacity(opacity: 0.08, child: Text('🍇', style: TextStyle(fontSize: 150)))),

                                    if (gameViewModel.fruits.isEmpty)
                                      Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('🎯 Try Tapping Here!', style: TextStyle(color: gameViewModel.accentColor, fontWeight: FontWeight.bold, fontSize: 16)),
                                            const Text('(Items appear where you tap)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    
                                    ...gameViewModel.fruits.map((item) {
                                      int idx = gameViewModel.fruitPool.indexOf(item.emoji);
                                      double size = 24.0 + (idx * 4.0);
                                      return AnimatedPositioned(
                                        duration: const Duration(milliseconds: 50),
                                        left: item.position.dx - (size / 2),
                                        top: item.position.dy - (size / 2),
                                        child: Text(item.emoji, style: TextStyle(fontSize: size, height: 1.0)),
                                      );
                                    }),

                                    if (gameViewModel.isGameFinished)
                                      _buildFinishOverlay(gameViewModel, context),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScoreCard(String label, String score, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color.withOpacity(0.5), letterSpacing: 1)),
            Text(score, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishOverlay(GameViewModel vm, BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Card(
          color: vm.backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(30),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('✨ Finish ✨', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: vm.primaryColor)),
                const SizedBox(height: 15),
                Text(vm.currentQuote, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: vm.primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: vm.primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                  icon: const Icon(Icons.replay),
                  label: const Text('Play Again'),
                  onPressed: () => _showReplayConfirmation(context, vm), // Sambungkan ke dialog konfirmasi
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.grey.withOpacity(0.15)..strokeWidth = 1.0;
    double step = 30.0; 
    for (double x = 0; x < size.width; x += step) canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    for (double y = 0; y < size.height; y += step) canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}