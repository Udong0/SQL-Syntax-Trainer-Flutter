# SQL Syntax Trainer (Flutter + Groq AI)

Aplikasi **SQL Syntax Trainer** adalah platform edukasi interaktif berbasis mobile/web (dibangun dengan Flutter) yang membantu pengguna untuk berlatih menulis query SQL secara real-time. Aplikasi ini ditenagai oleh **Groq API** dengan model **Llama 3.3 70B Versatile** yang bertindak sebagai *Smart Evaluator* dan *Scenario Generator*.

<img width="959" height="498" alt="image" src="https://github.com/user-attachments/assets/299ee6c7-7ce4-4808-87c7-218a18bdc9e1" />
<img width="959" height="500" alt="image" src="https://github.com/user-attachments/assets/cb82b5d2-d384-42b5-b905-906d33822062" />
<img width="569" height="181" alt="image" src="https://github.com/user-attachments/assets/da54d6d7-60f4-4ef7-ac89-ce74c3f5f36d" />

## Fitur Utama 🚀

- **Smart SQL Evaluator:** Mengetik query SQL di editor dan mendapatkan feedback langsung dengan menekan tombol **"Evaluate Query"**. AI akan mengecek *Syntax Error*, *Logic Error*, dan memberikan saran (Hint) serta query yang paling optimal.
- **Infinite Levels (AI-Generated Scenarios):** Tidak perlu repot menyiapkan soal! Cukup pilih tingkat kesulitan (*Beginner*, *Intermediate*, *Advanced*) dan tekan tombol **"Generate AI Scenario"** — AI akan membuatkan struktur database baru (Tema, Tabel, dan Instruksi Soal) secara acak dan dinamis.
- **Copy to Clipboard:** Solusi (*Optimized Query*) yang diberikan oleh AI dapat langsung disalin hanya dengan satu klik.
- **Secure API Key Management:** Menggunakan package `flutter_dotenv` untuk melindungi kerahasiaan API Key agar tidak ter-*commit* ke repositori publik.

## Tech Stack 💻

| Komponen | Teknologi |
|---|---|
| **Frontend Framework** | Flutter (Dart) |
| **State Management** | Provider |
| **AI Backend** | Groq API — Llama 3.3 70B Versatile |
| **HTTP Client** | `http` package (REST API) |
| **Environment Management** | `flutter_dotenv` |

## Arsitektur Aplikasi 🧩

```
lib/
├── main.dart                          # Entry point aplikasi
├── models/
│   ├── database_scenario.dart         # Model data skenario database
│   └── sql_evaluation.dart            # Model data hasil evaluasi SQL
├── providers/
│   └── sql_workspace_provider.dart    # State management (ChangeNotifier)
├── screens/
│   └── sql_workspace_screen.dart      # UI utama (Editor + Feedback Panel)
├── services/
│   └── gemini_service.dart            # Service layer (Groq API integration)
└── widgets/
```

### Alur Kerja:
1. **`SqlWorkspaceProvider`** mengelola state aplikasi (skenario aktif, query pengguna, hasil evaluasi).
2. **`GeminiService`** mengirim request ke Groq API via REST (`POST /openai/v1/chat/completions`) dan mem-parsing response JSON.
3. **UI** menampilkan skenario di panel kiri dan editor + feedback di panel kanan.

## Persiapan & Cara Menjalankan (Setup) 🛠️

### 1. Clone Repositori
```bash
git clone https://github.com/Udong0/SQL-Syntax-Trainer-Flutter.git
cd SQL-Syntax-Trainer-Flutter
```

### 2. Dapatkan Groq API Key (Gratis)
- Kunjungi [Groq Console](https://console.groq.com).
- Sign up / Login (bisa menggunakan akun Google).
- Buat **API Key** baru di halaman API Keys.
- Groq menyediakan **free tier** tanpa kartu kredit (limit ~6000 request/hari).

### 3. Setup File Konfigurasi `.env`
Buat file `.env` di root direktori proyek (sejajar dengan `pubspec.yaml`):
```env
GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
> ⚠️ File `.env` sudah masuk ke dalam `.gitignore` sehingga tidak akan terunggah ke GitHub.

### 4. Install Dependencies
```bash
flutter pub get
```

### 5. Jalankan Aplikasi
```bash
flutter run
```
Pilih target perangkat (Chrome/Edge untuk web, atau emulator/desktop).

## Cara Penggunaan 📖

1. **Generate Skenario:** Pilih tingkat kesulitan dari dropdown, lalu klik **"Generate AI Scenario"**. AI akan membuatkan tema database, skema tabel, dan soal SQL baru.
2. **Tulis Query:** Ketik query SQL Anda di panel editor sebelah kanan.
3. **Evaluate:** Klik tombol **"Evaluate Query"** untuk mengirim query ke AI evaluator.
4. **Review Feedback:** Lihat hasil evaluasi di panel bawah — termasuk status valid/invalid, error, saran, dan solusi optimal.

## Mengapa Groq? 🤔

Aplikasi ini awalnya menggunakan Google Gemini API, namun dipindahkan ke **Groq** karena:
- **Free tier yang lebih besar** — ~6000 request/hari tanpa kartu kredit.
- **Kecepatan tinggi** — Groq menggunakan LPU (*Language Processing Unit*) custom yang sangat cepat.
- **OpenAI-compatible API** — Format request/response standar, mudah untuk migrasi ke provider lain jika diperlukan.

---
*Dibuat untuk keperluan Tugas Kuliah — Demonstrasi integrasi AI Generatif ke dalam aplikasi Flutter.*
