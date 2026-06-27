import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/game_viewmodel.dart';

class DinDinGameScreen extends StatelessWidget {
  const DinDinGameScreen({super.key});

  // English Confirmation Dialog for Playing Again
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
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
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
                viewModel.replayGame(); // Triggers the next reactive background theme color
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, gameViewModel, child) {
        return Scaffold(
          backgroundColor: gameViewModel.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: gameViewModel.primaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '🍇 DinDin',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: gameViewModel.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Tap to drop the fruit',
                    style: TextStyle(fontSize: 14, color: gameViewModel.accentColor),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Score: ${gameViewModel.score}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: gameViewModel.accentColor),
                        ),
                      ),
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
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.volume_up, color: gameViewModel.accentColor),
                          onPressed: () {
                            print("Sound button clicked!");
                          },
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.refresh, color: gameViewModel.accentColor),
                          onPressed: () {
                            gameViewModel.resetGame();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

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
                          gameViewModel.nextFruit,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

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
                          Container(
                            width: double.infinity,
                            color: gameViewModel.accentColor.withOpacity(0.15),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.flag, color: gameViewModel.accentColor, size: 16),
                                const SizedBox(width: 5),
                                Text(
                                  'Finish Line',
                                  style: TextStyle(color: gameViewModel.accentColor, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: GestureDetector(
                                onTapDown: (details) {
                                  gameViewModel.handleAreaTap(details.localPosition);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Stack(
                                  children: [
                                    if (gameViewModel.fruits.isEmpty)
                                      Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '🎯 Try Tapping Here!',
                                              style: TextStyle(color: gameViewModel.accentColor, fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            const SizedBox(height: 5),
                                            const Text(
                                              '(Fruits will appear where you tap)',
                                              style: TextStyle(color: Colors.grey, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    
                                    ...gameViewModel.fruits.map((fruit) {
                                      int fruitIndex = gameViewModel.fruitPool.indexOf(fruit.emoji);
                                      double dynamicFontSize = 24.0 + (fruitIndex * 4.0);

                                      return AnimatedPositioned(
                                        duration: const Duration(milliseconds: 50),
                                        left: fruit.position.dx - (dynamicFontSize / 2),
                                        top: fruit.position.dy - (dynamicFontSize / 2),
                                        child: Text(
                                          fruit.emoji,
                                          style: BoxTextStyle(fontSize: dynamicFontSize),
                                        ),
                                      );
                                    }),

                                    if (gameViewModel.isGameFinished)
                                      Container(
                                        color: Colors.black.withOpacity(0.6),
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Center(
                                          child: Card(
                                            color: gameViewModel.backgroundColor,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            margin: const EdgeInsets.all(30),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '✨ Finish ✨',
                                                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: gameViewModel.primaryColor),
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    gameViewModel.currentQuote,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 16, color: gameViewModel.primaryColor, fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'Your Score: ${gameViewModel.score}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 15, color: gameViewModel.accentColor, fontWeight: FontWeight.w500),
                                                  ),
                                                  const SizedBox(height: 25),
                                                  ElevatedButton.icon(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: gameViewModel.primaryColor,
                                                      foregroundColor: Colors.white,
                                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                    ),
                                                    icon: const Icon(Icons.replay),
                                                    label: const Text('Play Again', style: TextStyle(fontWeight: FontWeight.bold)),
                                                    onPressed: () {
                                                      _showReplayConfirmation(context, gameViewModel);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
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

class BoxTextStyle extends TextStyle {
  const BoxTextStyle({super.fontSize}) : super(height: 1.0);
}