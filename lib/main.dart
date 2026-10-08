import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/game_viewmodel.dart';
import 'views/pages/main_menu.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Container(
          color: Colors.black, // Warna latar belakang di luar tampilan HP
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480), // Batas lebar layar HP
              child: child,
            ),
          ),
        );
      },
      home: const DinDinMainMenu(),
    );
  }
}
