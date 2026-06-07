import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dindin_game/viewmodels/game_viewmodel.dart'; // Sesuaikan dengan nama projekmu

void main() {
  // group() digunakan untuk mengelompokkan beberapa test case yang sejenis
  group('GameViewModel Unit Testing', () {
    
    test('Skor harus bertambah 1 dan buah baru masuk ke list saat area papan di-tap', () {
      // 1. ARRANGE (Persiapan): Menyiapkan kondisi awal dan objek ViewModel 
      final gameViewModel = GameViewModel();
      expect(gameViewModel.score, 0);       // Memastikan skor awal murni 0
      expect(gameViewModel.fruits.length, 0); // Memastikan list buah awal kosong

      // 2. ACT (Aksi): Memanggil fungsi/method tap papan yang ingin kita uji logikanya 
      gameViewModel.handleAreaTap(const Offset(150.0, 300.0));

      // 3. ASSERT (Verifikasi): Memeriksa apakah hasilnya sesuai ekspektasi kita 
      expect(gameViewModel.score, 1);         // Skor harus naik menjadi 1
      expect(gameViewModel.fruits.length, 1);  // Jumlah buah di list harus jadi 1
      expect(gameViewModel.fruits.first.position, const Offset(150.0, 300.0)); // Posisi koordinat harus pas
    });

    test('Skor dan daftar buah harus kembali bersih ke angka 0 saat tombol reset ditekan', () {
      // 1. ARRANGE (Persiapan): Buat objek dan simulasikan jika pemain sudah mengetuk papan 
      final gameViewModel = GameViewModel();
      gameViewModel.handleAreaTap(const Offset(150.0, 300.0));
      expect(gameViewModel.score, 1); // Memastikan skor sudah terisi 1 sebelum di-reset

      // 2. ACT (Aksi): Jalankan fungsi reset game 
      gameViewModel.resetGame();

      // 3. ASSERT (Verifikasi): Pastikan semua data kembali suci ke angka 0 
      expect(gameViewModel.score, 0);
      expect(gameViewModel.fruits.isEmpty, true);
    });
    
  });
}