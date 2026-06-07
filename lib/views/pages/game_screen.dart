import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Impor package provider
import '../../viewmodels/game_viewmodel.dart'; // Hubungkan ke file ViewModel

class DinDinGameScreen extends StatelessWidget {
  const DinDinGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk mendengarkan perubahan di GameViewModel
    return Consumer<GameViewModel>(
      builder: (context, gameViewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF0E3F7),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  // Tombol Back menuju Menu Utama
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF3A1E54)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  
                  // 1. GAME TITLE & INSTRUCTION
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '🍇 DinDin',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A1E54),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Tap to drop the fruit',
                    style: TextStyle(fontSize: 14, color: Colors.purple),
                  ),
                  const SizedBox(height: 20),

                  // 2. SCOREBOARD (Data diambil dari gameViewModel)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Score Box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Score: ${gameViewModel.score}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple),
                        ),
                      ),
                      // Best Score Box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Best: ${gameViewModel.bestScore}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ),
                      // Sound Button
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.volume_up, color: Colors.purple),
                          onPressed: () {
                            print("Sound button clicked!");
                          },
                        ),
                      ),
                      // Reset Button (Memanggil fungsi resetGame dari ViewModel)
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.purple),
                          onPressed: () {
                            gameViewModel.resetGame();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // 3. NEXT FRUIT INDICATOR (Sekor diubah menjadi dinamis tanpa const)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Next: ', style: TextStyle(fontSize: 16)),
                        Text(
                          gameViewModel.nextFruit, // MEMBACA EMOJI ANTRIAN BERIKUTNYA
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. GAMEPLAY AREA (Menggunakan Stack untuk merender list buah)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          // Danger Zone Banner
                          Container(
                            width: double.infinity,
                            color: Colors.red.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.warning, color: Colors.red, size: 16),
                                SizedBox(width: 5),
                                Text(
                                  'Danger Zone',
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white, // Memastikan background putih mendeteksi tap sepenuhnya
                              child: GestureDetector(
                                onTapDown: (details) {
                                  // Memanggil fungsi handleAreaTap dari ViewModel dengan koordinat sentuhan
                                  gameViewModel.handleAreaTap(details.localPosition);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Stack(
                                  children: [
                                    if (gameViewModel.fruits.isEmpty)
                                      const Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '🎯 Try Tapping Here!',
                                              style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '(Fruits will appear where you tap)',
                                              style: TextStyle(color: Colors.grey, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    // Merender setiap buah acak warna-warni dari list ViewModel
                                    ...gameViewModel.fruits.map((fruit) {
                                      return Positioned(
                                        left: fruit.position.dx - 15,
                                        top: fruit.position.dy - 15,
                                        child: Text(
                                          fruit.emoji, // MEMBACA EMOJI DARI MODEL DATA
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                      );
                                    }),
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
}