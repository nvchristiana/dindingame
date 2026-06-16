import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dindin_game/viewmodels/game_viewmodel.dart';
import 'package:dindin_game/views/pages/game_screen.dart'; 

void main() {
  // Menguji apakah halaman utama game berhasil ter-render dengan benar [source: 4, 5]
  testWidgets('Menampilkan komponen game screen saat pertama kali dibuka', (WidgetTester tester) async {
    
    // 1. ARRANGE & ACT: Pompa widget ke sistem testing [source: 4, 5]
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(),
        child: const MaterialApp(
          home: DinDinGameScreen(), 
        ),
      ),
    );

    // 2. ASSERT: Mencari teks panduan bermain yang terbukti tertulis di game_screen.dart [source: 4]
    expect(find.textContaining('Fruits will appear where you tap'), findsOneWidget); 
  });
}