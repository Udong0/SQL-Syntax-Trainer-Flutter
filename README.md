# SQL Syntax Trainer (Flutter + Gemini AI)

Aplikasi **SQL Syntax Trainer** adalah platform edukasi interaktif berbasis mobile/web (dibangun dengan Flutter) yang membantu pengguna untuk berlatih menulis query SQL secara real-time. Alih-alih terhubung langsung ke database konvensional, aplikasi ini ditenagai oleh **Google Gemini API** (khususnya `gemini-1.5-flash`) yang bertindak sebagai *Smart Evaluator*.
<img width="959" height="498" alt="image" src="https://github.com/user-attachments/assets/299ee6c7-7ce4-4808-87c7-218a18bdc9e1" />
<img width="959" height="500" alt="image" src="https://github.com/user-attachments/assets/cb82b5d2-d384-42b5-b905-906d33822062" />
<img width="569" height="181" alt="image" src="https://github.com/user-attachments/assets/da54d6d7-60f4-4ef7-ac89-ce74c3f5f36d" />


## Fitur Utama 🚀

- **Smart SQL Evaluator:** Mengetik query SQL di editor dan mendapatkan feedback seketika. AI akan mengecek *Syntax Error*, *Logic Error*, dan memberikan saran (Hint) atau query yang paling optimal.
- **Infinite Levels (AI-Generated Scenarios):** Tidak perlu repot menyiapkan soal! Cukup pilih tingkat kesulitan (*Beginner*, *Intermediate*, *Advanced*) dan aplikasi akan meminta AI untuk membuatkan struktur database baru (Tema, Tabel, dan Instruksi Soal) secara acak dan dinamis.
- **Copy to Clipboard:** Solusi (*Optimized Query*) yang diberikan oleh AI dapat langsung disalin hanya dengan satu klik.
- **Secure API Key Management:** Menggunakan package `flutter_dotenv` untuk melindungi kerahasiaan API Key Google Gemini agar tidak ter-*commit* ke repositori publik.
- **Debounced Validation:** Aplikasi menggunakan *timer debounce* (1.5 detik) yang otomatis mengirimkan query ke API hanya saat pengguna selesai mengetik, untuk menghemat kuota *request* ke AI.

## Tech Stack 💻
- **Frontend Framework:** Flutter (Dart)
- **State Management:** Provider
- **AI Integration:** `google_generative_ai` (Google Gemini SDK)
- **Environment Management:** `flutter_dotenv`

## Persiapan & Cara Menjalankan (Setup) 🛠️

Ikuti langkah-langkah di bawah ini untuk menjalankan aplikasi di perangkat lokal Anda:

### 1. Clone Repositori
```bash
git clone https://github.com/Udong0/SQL-Syntax-Trainer-Flutter.git
cd SQL-Syntax-Trainer-Flutter
```

### 2. Dapatkan Gemini API Key
Anda memerlukan API Key gratis dari Google AI Studio.
- Kunjungi [Google AI Studio](https://aistudio.google.com/).
- Login menggunakan akun Google Anda dan buat **API Key** baru.

### 3. Setup File Konfigurasi `.env`
Agar API Key Anda aman, aplikasi ini tidak menuliskannya langsung ke dalam kode.
1. Buat sebuah file baru bernama `.env` di root direktori proyek (sejajar dengan file `pubspec.yaml`).
2. Buka file `.env` dan masukkan API Key Anda dengan format seperti ini:
   ```env
   GEMINI_API_KEY=AIzaSyxxxxxxxxxxxxxxxxx
   ```
*(Catatan: File `.env` sudah masuk ke dalam `.gitignore` sehingga tidak akan terunggah ke GitHub)*.

### 4. Install Dependencies
```bash
flutter pub get
```

### 5. Jalankan Aplikasi
Anda dapat menjalankannya di emulator, browser, maupun desktop:
```bash
flutter run
```

## Arsitektur State 🧩
*   Aplikasi ini menggunakan **`SqlWorkspaceProvider`** untuk menangani pertukaran data antara *UI* (Editor & Panel) dan *Service* (`GeminiService`).
*   Saat pengguna mengetik, state dikelola secara reaktif dan memicu evaluasi otomatis setelah *user* berhenti mengetik sejenak.

---
*Dibuat untuk keperluan latihan dan demonstrasi integrasi AI Generatif ke dalam aplikasi Flutter.*
