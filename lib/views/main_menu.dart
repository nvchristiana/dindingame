import 'package:flutter/material.dart';
import 'game_screen.dart'; // Menghubungkan ke file game_screen.dart

class DinDinMainMenu extends StatelessWidget {
  const DinDinMainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E3F7),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🍇',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 10),
              const Text(
                'DinDin',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3A1E54),
                ),
              ),
              const Text(
                'A Hyper-Casual Drop & Merge Game',
                style: TextStyle(fontSize: 16, color: Colors.purple),
              ),
              const SizedBox(height: 50),
              
              // BUTTON TO NAVIGATE TO GAME SCREEN
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A1E54),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DinDinGameScreen(),
                    ),
                  );
                },
                child: const Text(
                  'PLAY NOW',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}