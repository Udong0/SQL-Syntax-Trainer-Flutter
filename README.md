# SQL Syntax Trainer (Flutter + Ollama)

Aplikasi **SQL Syntax Trainer** adalah platform edukasi interaktif berbasis mobile/web (dibangun dengan Flutter) yang membantu pengguna untuk berlatih menulis query SQL secara real-time. Aplikasi ini ditenagai oleh **Ollama** (lokal) dengan model **Qwen2.5-Coder 7B** yang bertindak sebagai *Smart Evaluator* dan *Scenario Generator*.

<img width="959" height="498" alt="image" src="https://github.com/user-attachments/assets/299ee6c7-7ce4-4808-87c7-218a18bdc9e1" />
<img width="959" height="500" alt="image" src="https://github.com/user-attachments/assets/cb82b5d2-d384-42b5-b905-906d33822062" />
<img width="569" height="181" alt="image" src="https://github.com/user-attachments/assets/da54d6d7-60f4-4ef7-ac89-ce74c3f5f36d" />
<img width="778" height="481" alt="image" src="https://github.com/user-attachments/assets/78b86840-048a-445b-bee9-fe095b11ff48" />

## Fitur Utama

- **Smart SQL Evaluator:** Ketik query SQL di editor dan dapatkan feedback dengan menekan tombol **"Evaluate Query"**. AI akan mengecek *Syntax Error*, *Logic Error*, dan memberikan saran serta query yang paling optimal.
- **Infinite Levels (AI-Generated Scenarios):** Pilih tingkat kesulitan (*Beginner*, *Intermediate*, *Advanced*) dan tekan **"Generate AI Scenario"** — AI akan membuatkan struktur database baru (Tema, Tabel, dan Instruksi Soal) secara acak.
- **Copy to Clipboard:** Solusi (*Optimized Query*) yang diberikan AI dapat langsung disalin dengan satu klik.
- **Local AI (Edge):** Inferensi berjalan sepenuhnya di mesin lokal menggunakan Ollama — tidak memerlukan koneksi internet atau API key.

## Tech Stack

| Komponen | Teknologi |
|---|---|
| **Frontend Framework** | Flutter (Dart) |
| **State Management** | Provider |
| **AI Backend** | Ollama (lokal) — Qwen2.5-Coder 7B |
| **HTTP Client** | `http` package (REST API) |

## Arsitektur Aplikasi

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
│   └── gemini_service.dart            # Service layer (Ollama API integration)
```

### Alur Kerja:
1. **`SqlWorkspaceProvider`** mengelola state aplikasi (skenario aktif, query pengguna, hasil evaluasi).
2. **`GeminiService`** mengirim request ke Ollama via REST (`POST /v1/chat/completions`) dan mem-parsing response JSON.
3. **UI** menampilkan skenario di panel kiri dan editor + feedback di panel kanan.

## Persiapan & Cara Menjalankan (Setup)

### 1. Clone Repositori
```bash
git clone https://github.com/Udong0/SQL-Syntax-Trainer-Flutter.git
cd SQL-Syntax-Trainer-Flutter
```

### 2. Install Ollama
- Download dan install Ollama dari [https://ollama.com/download](https://ollama.com/download).
- Pull model yang digunakan:
```bash
ollama pull qwen2.5-coder:7b
```
> Ukuran model sekitar 4.7 GB. Direkomendasikan RAM minimal 8 GB.

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Jalankan Aplikasi
Pastikan Ollama sudah berjalan (otomatis berjalan sebagai background service setelah install), lalu:
```bash
flutter run
```
Pilih target perangkat (Chrome/Edge untuk web, atau emulator/desktop).

## Cara Penggunaan

1. **Generate Skenario:** Pilih tingkat kesulitan dari dropdown, lalu klik **"Generate AI Scenario"**. AI akan membuatkan tema database, skema tabel, dan soal SQL baru.
2. **Tulis Query:** Ketik query SQL di panel editor sebelah kanan.
3. **Evaluate:** Klik tombol **"Evaluate Query"** untuk mengirim query ke AI evaluator.
4. **Review Feedback:** Lihat hasil evaluasi di panel bawah — termasuk status valid/invalid, error, saran, dan solusi optimal.

---
*Dibuat untuk keperluan Tugas Kuliah — Demonstrasi integrasi Edge AI ke dalam aplikasi Flutter.*
