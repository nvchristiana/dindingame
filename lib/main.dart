import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Impor package provider untuk MVVM
import 'viewmodels/game_viewmodel.dart'; // Impor ViewModel kita
import 'views/pages/main_menu.dart'; // Impor Menu Utama kita

void main() {
  runApp(
    // Membungkus seluruh aplikasi dengan Provider agar GameViewModel bisa diakses di semua halaman
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DinDinMainMenu(), // Halaman awal aplikasi tetap Menu Utama
    );
  }
}