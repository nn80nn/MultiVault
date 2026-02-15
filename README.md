# MultiVault

A secure, privacy-focused password manager built with Flutter. MultiVault implements production-grade cryptography and security best practices to protect your sensitive data.

## Features

### Core Functionality
- Secure password storage with AES-256-GCM encryption
- Organize passwords with custom categories
- Search and filter passwords by category or keywords
- Favorite passwords for quick access
- Secure notes field for additional information
- Password breach checking using Have I Been Pwned (k-Anonymity)
- Import/Export functionality (JSON, CSV, encrypted formats)

### Security Features
- **Master Password Protection**: All data is encrypted with a key derived from your master password
- **AES-256-GCM Encryption**: Authenticated encryption with associated data (AEAD) for both confidentiality and integrity
- **PBKDF2-HMAC-SHA256**: 100,000 iterations for key derivation, optimized with native cryptography
- **SQLCipher Database**: Encrypted SQLite database for secure local storage
- **Biometric Authentication**: Optional fingerprint/face unlock (Android & iOS)
- **Screenshot Protection**: FLAG_SECURE on sensitive screens (Android)
- **No Cloud Backups**: android:allowBackup disabled to prevent cloud data leakage
- **Memory Security**: Sensitive data is actively zeroed from memory after use
- **No Logging**: Zero debug logging in production builds

### Privacy
- **Offline-First**: Works completely offline, no account required
- **Minimal Network Usage**: Only two network features:
  - HIBP breach checking (optional, uses k-anonymity)
  - Favicon loading for website icons (optional)
- **No Tracking**: No analytics, no telemetry, no third-party services
- **No Backup to Cloud**: Your vault stays on your device only

## Installation

### Prerequisites
- Flutter SDK 3.5.0 or higher
- Android Studio / Xcode for platform-specific builds
- Android device running API 21+ or iOS device running iOS 12+

### Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/multivault.git
cd multivault
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For debug mode
flutter run

# For release mode (Android)
flutter run --release

# For release mode (iOS)
flutter run --release --flavor production
```

## Usage

### First Time Setup

1. Launch the app
2. Create a strong master password (minimum 8 characters recommended)
3. Confirm your master password
4. Your encrypted vault is now created

**Important**: Your master password cannot be recovered. If you forget it, your vault data will be permanently inaccessible.

### Adding Passwords

1. Tap the '+' button on the vault screen
2. Fill in the password details:
   - Title (required)
   - Username (required)
   - Password (required)
   - URL (optional)
   - Notes (optional)
   - Category (optional)
3. Tap 'Save'

### Importing Data

1. Go to Settings
2. Tap 'Import Passwords'
3. Select format (JSON, CSV, or encrypted)
4. Choose file
5. Confirm import

### Exporting Data

1. Go to Settings
2. Tap 'Export Passwords'
3. Select format (JSON, CSV, or encrypted)
4. For encrypted exports, set an export password
5. File is saved to your device

## Architecture

### Project Structure

```
lib/
├── core/
│   ├── constants/          # App-wide constants
│   ├── di/                 # Dependency injection providers
│   ├── extensions/         # Dart extensions
│   ├── navigation/         # Router configuration
│   └── theme/              # Material Design theme
├── features/
│   ├── auth/               # Authentication & master password
│   ├── import_export/      # Import/export functionality
│   ├── settings/           # Settings & preferences
│   └── vault/              # Password vault (core feature)
│       ├── data/
│       │   ├── database/   # Drift database models
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   └── repositories/
│       └── presentation/
│           ├── screens/
│           └── widgets/
└── services/               # Cross-cutting services
    ├── biometric_service.dart
    ├── clipboard_service.dart
    ├── encryption_service.dart
    ├── hibp_service.dart
    └── screen_security_service.dart
```

### Security Architecture

#### Key Derivation Flow

```
Master Password
    ↓
PBKDF2-HMAC-SHA256 (100,000 iterations)
    ↓
256-bit Derived Key
    ↓
    ├─→ SHA-256 Hash (stored for verification)
    └─→ Hex encoding (used as SQLCipher key)
```

#### Encryption Flow

```
Plaintext Password
    ↓
AES-256-GCM Encryption
    ├─→ 12-byte random nonce
    ├─→ Ciphertext
    └─→ 16-byte authentication tag
    ↓
Base64([nonce || ciphertext+tag])
    ↓
Stored in encrypted database
```

#### Key Security Properties

1. **No Key Storage**: Database encryption key is never stored. It's derived on-the-fly from the master password during login.
2. **Authenticated Encryption**: GCM mode provides both confidentiality and integrity. Any tampering is detected during decryption.
3. **Memory Zeroing**: Sensitive data (keys, decrypted passwords) is explicitly zeroed from memory using `zeroMemory()` in `finally` blocks.
4. **Transaction Atomicity**: Critical operations (like password re-encryption) are wrapped in database transactions for all-or-nothing guarantees.

### Network Transparency

MultiVault makes network requests in two scenarios only:

#### 1. Have I Been Pwned (HIBP) Breach Checking

**When**: Optional password strength check when creating/editing passwords
**What**: Checks if password appears in known data breaches
**Privacy**: Uses k-Anonymity protocol:
- Only first 5 characters of SHA-1 hash are sent
- Server returns all breaches matching that prefix
- Client checks locally for full match
- Original password never leaves device

**Example**:
```
Password: "P@ssw0rd123"
SHA-1: "5BAA61E4C9B93F3F0682250B6CF8331B7EE68FD8"
Sent to API: "5BAA6" (first 5 chars)
Privacy guarantee: ~1.2 million possible passwords per prefix
```

**Endpoint**: `https://api.pwnedpasswords.com/range/{hash-prefix}`

#### 2. Favicon Loading

**When**: Optional icon display for website passwords
**What**: Loads website favicon for visual identification
**Privacy**:
- Direct request to target website
- No third-party service used
- Only triggered when password has a URL

**Example**:
```
Password URL: "https://github.com"
Favicon: "https://github.com/favicon.ico"
```

**Note**: You can disable both features by:
- HIBP: Don't use the "Check strength" feature
- Favicons: No setting needed - only loads when viewing password with URL

## Development

### Code Style

- Follow Dart style guide
- Use meaningful variable names
- Add security comments for sensitive operations
- Document all public APIs

### Security Considerations

When contributing, ensure:

1. **Never log sensitive data**: No `print()`, `debugPrint()`, or `log()` calls with passwords, keys, or personal data
2. **Always zero memory**: Use `try-finally` with `zeroMemory()` for sensitive operations
3. **Use transactions**: Wrap multi-step database operations in transactions
4. **Validate inputs**: Check file sizes, formats, and user inputs at boundaries
5. **Sanitize errors**: Don't leak implementation details in user-facing error messages

### Building Release Versions

#### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

#### iOS

```bash
# Build IPA
flutter build ipa --release
```

### Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## Security Audit Results

MultiVault has been designed with security-first principles:

**Strengths**:
- AES-256-GCM authenticated encryption
- No database key storage (derived on-the-fly)
- Comprehensive memory zeroing
- Transaction-wrapped critical operations
- k-Anonymity for breach checking
- Screenshot protection on sensitive screens
- No cloud backups
- Zero logging in production

**Known Limitations**:
- No export key rotation (export password reuse possible)
- No password expiry reminders
- No secure element integration (uses platform secure storage)

**Overall Security Rating**: 4/5 (Production-ready for personal use)

## Dependencies

### Core
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `shared_preferences` - Simple key-value storage

### Security
- `cryptography` & `cryptography_flutter` - Native PBKDF2 implementation
- `encrypt` - AES-GCM encryption wrapper
- `crypto` - SHA-256 hashing
- `flutter_secure_storage` - Platform secure storage
- `local_auth` - Biometric authentication
- `flutter_windowmanager` - Screenshot protection (Android)

### Database
- `drift` - Type-safe SQLite wrapper
- `sqlite3_flutter_libs` - SQLite with SQLCipher support
- `sqlcipher_flutter_libs` - SQLCipher encryption

### UI/UX
- `flutter_slidable` - Swipe actions
- `file_picker` - File selection
- `intl` - Internationalization

## License

MIT License

Copyright (c) 2024 MultiVault

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Disclaimer

MultiVault is provided as-is for personal use. While we implement industry-standard security practices, no password manager is 100% secure. Always:

- Use a strong, unique master password
- Keep your device secure with a lock screen
- Regularly back up your vault (using the encrypted export feature)
- Keep the app updated to receive security patches

**Remember**: The security of your vault depends on your master password. Choose wisely and never share it.
