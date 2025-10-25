# VisionFit Projesi Kurulum Rehberi

## 🔧 Gerekli Konfigürasyonlar

### 1. Flutter Uygulaması Konfigürasyonu

`lib/config/app_config.dart` dosyasındaki URL'leri kendi sunucu adreslerinizle değiştirin:

```dart
class AppConfig {
  static const String apiBaseUrl = 'https://your-api-server.com:7146';
  static const String comfyUIBaseUrl = 'http://your-comfyui-server.com:5000';
  // ... diğer endpoint'ler
}
```

### 2. Backend API Konfigürasyonu

#### Veritabanı Bağlantısı
`backend/VisionFit_API/VisionFit_API/appsettings.json` dosyasındaki connection string'i güncelleyin:

```json
{
  "ConnectionStrings": {
    "VisionFitDB": "Server=YOUR_SERVER_NAME;Database=VisionFitDB;User Id=YOUR_USERNAME;Password=YOUR_PASSWORD;TrustServerCertificate=True"
  }
}
```

#### Development Ayarları
`appsettings.Development.json` dosyasını `appsettings.Development.example.json` dosyasından kopyalayarak oluşturun ve kendi değerlerinizi girin.

### 3. Environment Variables (Opsiyonel)

Projenin kök dizininde `.env` dosyası oluşturun ve `config.example.env` dosyasındaki değerleri kendi değerlerinizle değiştirin.

## 🚀 Çalıştırma

### Flutter Uygulaması
```bash
flutter pub get
flutter run
```

### Backend API
```bash
cd backend/VisionFit_API/VisionFit_API
dotnet restore
dotnet run
```

## ⚠️ Güvenlik Notları

- Gerçek API URL'lerini ve veritabanı bilgilerini GitHub'a yüklemeyin
- Production ortamında güçlü şifreler kullanın
- JWT secret key'lerini güvenli tutun
- SSL sertifikalarını doğru şekilde yapılandırın

## 📁 Dosya Yapısı

```
visio_fit/
├── lib/
│   └── config/
│       └── app_config.dart          # API URL'leri
├── backend/
│   └── VisionFit_API/
│       └── VisionFit_API/
│           ├── appsettings.json     # Genel ayarlar
│           └── appsettings.Development.json  # Development ayarları
├── config.example.env               # Environment variables örneği
└── README-SETUP.md                 # Bu dosya
```
