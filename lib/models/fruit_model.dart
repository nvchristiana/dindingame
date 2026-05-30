import 'package:flutter/material.dart';

class FruitModel {
  final Offset position;
  final String emoji; // MENYIMPAN JENIS EMOJI BUAH

  FruitModel({
    required this.position, 
    required this.emoji, // Wajib diisi saat buah dibuat
  });
}