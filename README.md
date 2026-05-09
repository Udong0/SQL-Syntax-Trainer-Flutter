# 🤖 EdgeAI Flutter — Tugas Kuliah

Aplikasi Flutter yang mendemonstrasikan konsep **Edge Computing dengan Kecerdasan Buatan (AI)**, 
di mana inferensi model ML berjalan langsung di perangkat (on-device) tanpa perlu koneksi internet atau server cloud.

---

## 📱 Fitur Utama

| Fitur | Model | Latensi Edge |
|-------|-------|-------------|
| Klasifikasi Gambar | MobileNetV3-Small (TFLite) | 80–150ms |
| Analisis Sentimen | BERT-Lite (TFLite) | 60–260ms |
| Deteksi Objek Real-time | YOLOv8n (TFLite) | 30–80ms |
| Benchmark Edge vs Cloud | — | Perbandingan langsung |

---

## 🏗 Arsitektur Proyek

```
lib/
├── main.dart                    # Entry point + App Theme
├── models/
│   └── ai_result.dart           # Data classes (Prediction, SentimentResult, dll)
├── services/
│   └── edge_ai_service.dart     # Logika inferensi AI + state management
├── screens/
│   ├── home_screen.dart         # Dashboard utama
│   ├── image_classification_screen.dart
│   ├── sentiment_analysis_screen.dart
│   ├── object_detection_screen.dart
│   ├── benchmark_screen.dart    # Perbandingan Edge vs Cloud
│   └── inference_log_screen.dart
└── widgets/
    └── common_widgets.dart      # Reusable UI components
```

---

## 🧠 Konsep Edge Computing AI

### Apa itu Edge Computing?
Edge computing adalah paradigma komputasi di mana pemrosesan data dilakukan **dekat dengan sumber data** (perangkat pengguna), bukan di server cloud yang jauh.

### Edge vs Cloud AI

| Aspek | Edge (On-Device) | Cloud AI |
|-------|-----------------|----------|
| **Latensi** | 30–200ms | 300–800ms |
| **Privasi** | ✅ Data tidak keluar perangkat | ❌ Data dikirim ke server |
| **Offline** | ✅ Bekerja tanpa internet | ❌ Butuh koneksi |
| **Biaya** | Gratis setelah deploy | Per-request billing |
| **Skalabilitas** | Terbatas oleh hardware | Tak terbatas |

### Model yang Digunakan (TensorFlow Lite)

1. **MobileNetV3-Small** — Model CNN ringan (~2.5MB) untuk klasifikasi gambar. 
   Dioptimasi dengan depthwise separable convolutions untuk perangkat mobile.

2. **BERT-Lite** — Versi distilasi dari BERT untuk NLP on-device.
   Mendukung pemahaman konteks teks dalam berbagai bahasa.

3. **YOLOv8n** — Varian nano dari YOLOv8 (~3.2MB), mendeteksi 80 kelas objek
   dengan arsitektur CSPDarknet + PAN-FPN yang efisien.

---

## 🚀 Cara Menjalankan

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code dengan Flutter extension

### Instalasi

```bash
# Clone atau buka folder proyek
cd flutter_edge_ai

# Install dependencies
flutter pub get

# Jalankan di emulator atau perangkat fisik
flutter run

# Build APK untuk Android
flutter build apk --release

# Build untuk iOS
flutter build ios --release
```

---

## 📚 Dependencies Utama

```yaml
provider: ^6.1.1          # State management
fl_chart: ^0.68.0          # Chart & visualisasi data  
image_picker: ^1.0.7       # Pilih gambar dari galeri/kamera
google_fonts: ^6.2.1       # Typography premium
flutter_animate: ^4.5.0    # Animasi modern
shimmer: ^3.0.0            # Loading skeleton effect
percent_indicator: ^4.2.3  # Progress indicator
```

---

## 🎓 Konsep Akademis

### Topik yang Dicakup

1. **Machine Learning Pipeline** — Pre-processing → Inference → Post-processing
2. **Model Quantization** — Konversi model dari FP32 ke INT8 untuk efisiensi edge
3. **Transfer Learning** — Penggunaan pre-trained model yang sudah dioptimasi
4. **Real-time Processing** — Manajemen thread dan async processing
5. **Privacy-preserving AI** — Federated learning dan on-device inference
6. **State Management** — Provider pattern dengan ChangeNotifier

### Referensi

- TensorFlow Lite: https://tensorflow.org/lite
- MobileNetV3: Howard et al. (2019) - "Searching for MobileNetV3"
- YOLOv8: Jocher et al. (2023) - Ultralytics YOLOv8
- BERT-Lite: Sun et al. (2020) - "MobileBERT"
- Edge Computing: Shi et al. (2016) - "Edge Computing: Vision and Challenges"

---

## 👨‍💻 Tentang Implementasi

Aplikasi ini **mensimulasikan** inferensi model TFLite karena integrasi model 
sebenarnya memerlukan file `.tflite` terpisah dan setup native. Simulasi mencerminkan:

- ✅ Timing realistis berdasarkan benchmark perangkat nyata
- ✅ Output probabilitas yang masuk akal
- ✅ Arsitektur kode yang sama dengan implementasi produksi
- ✅ UX flow yang identik dengan aplikasi sebenarnya

Untuk implementasi penuh dengan model nyata, gunakan package `tflite_flutter: ^0.10.4`.

---

*Tugas Kuliah — Edge Computing & AI Mobile | Flutter/Dart*
