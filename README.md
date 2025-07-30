# 🔐 Password Vault

A secure and user-friendly **Password Management Application** built with Flutter. This app prioritizes **on-device encryption**, offering secure storage, retrieval, and export of your passwords.

---

## 🚀 Features

### ✅ Secure On-Device Encryption
- All passwords are encrypted using **AES-256 GCM**.
- Utilizes **Android Keystore System** (via `flutter_secure_storage`) for master key management.
- Encrypted local database with **`sqflite_sqlcipher`**.

### 🔑 Password Management
- Add, view, edit, and delete password entries (Name, Username, Password, URL, Notes).
- Copy passwords securely to clipboard.

### 🔐 Encrypted Export & Import
- Export all password entries to a `.pvault` file (internally CSV format, externally AES-encrypted).
- Encryption uses **PBKDF2 + AES-256 GCM**.
- Import requires correct password for decryption.

### 📱 Cross-Platform Ready (Android-Focused)
- Built with Flutter for cross-platform potential.
- Focused on **robust Android security** best practices.

---

## 🛠 Technologies Used

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform mobile app SDK |
| `flutter_secure_storage` | Master key management using Android Keystore |
| `sqflite_sqlcipher` | Encrypted local SQLite database |
| `encrypt` | AES-256 GCM implementation |
| `pointycastle` | PBKDF2 for key derivation |
| `path_provider`, `path` | File system path access |
| `csv` | CSV export/import format |
| `permission_handler` | Runtime permissions |
| `file_picker` | Importing `.pvault` files |
| `share_plus` | Exporting/sharing encrypted `.pvault` file |

---

## ⚙️ Setup and Installation

### 📋 Prerequisites

- **Flutter SDK**  
  [Install Flutter](https://flutter.dev/docs/get-started/install) and add it to your system `PATH`.

- **Android Studio**  
  [Download Android Studio](https://developer.android.com/studio)  
  - Install SDK Tools (API 34+)
  - Accept licenses via:
    ```bash
    flutter doctor --android-licenses
    ```

- **VS Code (Recommended)**  
  - [Download VS Code](https://code.visualstudio.com/)  
  - Install **Flutter extension** from Extensions marketplace.

---

## 📦 Project Setup

### 🔃 Clone or Create a New Project

#### Option 1: Create New Project
```bash
flutter create password_vault_app
cd password_vault_app

## 📁 Add Dependencies
### Edit your pubspec.yaml and ensure these are listed:

yaml
Copy
Edit
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  flutter_secure_storage: ^9.0.0
  sqflite_sqlcipher: ^2.3.0
  path_provider: ^2.1.3
  path: ^1.9.0
  encrypt: ^5.0.1
  pointycastle: ^3.7.3
  csv: ^5.1.1
  permission_handler: ^11.3.1
  share_plus: ^9.0.0
  file_picker: ^6.2.0
Then run:

bash
Copy
Edit
flutter pub get
## 🔐 Android Permissions
Edit android/app/src/main/AndroidManifest.xml:

xml
Copy
Edit
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

<application
    android:requestLegacyExternalStorage="true"
    ...>
</application>
## ▶️ Running the App
1. Connect Device or Start Emulator
bash
Copy
Edit
flutter devices
2. Run the App
bash
Copy
Edit
flutter run
Alternatively, open lib/main.dart in VS Code and press F5 to debug.

## 🗂 Project Structure
bash
Copy
Edit
password_vault_app/
├── lib/
│   ├── main.dart                # Entry point
│   ├── models/
│   │   └── password_entry.dart  # Password entry data model
│   ├── services/
│   │   ├── crypto_service.dart   # Encryption/decryption logic
│   │   ├── database_service.dart # Encrypted DB operations
│   │   └── export_service.dart   # Encrypted import/export logic
│   └── screens/
│       └── home_page.dart        # Main UI for managing passwords
├── android/                    # Native Android project
├── ios/                        # iOS support (future)
├── pubspec.yaml                # Project metadata and dependencies


## 🌱 Future Enhancements
- ✅ Biometric Authentication (Face/Touch ID)

- 🔄 Cloud Sync (Encrypted data across devices)

- 💡 Autofill Integration (AutofillService on Android)

- 🧠 "Save on the Go" (AccessibilityService)

- 🔒 Password Strength Indicator

- 🔐 Strong Password Generator

### 🛡️ Security Note
This application uses industry-standard cryptography (AES-256 GCM, PBKDF2 with salt, encrypted local storage). However, always ensure your device is secure (locked, not rooted) and never share your master password.
