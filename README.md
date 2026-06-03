# Blood Bank Digital - Mobile Application

Aplikasi monitoring stok darah dan lokasi donor real-time untuk lingkup wilayah Yogyakarta.

## 🛠 Perubahan Teknis (Update Terbaru)

### Frontend (Flutter)
- **Autentikasi:** Implementasi `AuthController` menggunakan `http` package untuk sinkronisasi dengan backend.
- **Session Management:** Menggunakan `shared_preferences` untuk menyimpan status login dan data user.
- **State Management:** Migrasi `_HomeDashboardContent` ke `StatefulWidget` untuk menampilkan nama user secara dinamis dari sesi login.
- **Maps Integration:** Implementasi `url_launcher` untuk fitur navigasi ke lokasi PMI/RS.
- **Security:** Konfigurasi `android:usesCleartextTraffic="true"` di `AndroidManifest.xml` untuk akses HTTP pada emulator.

### Backend (Golang & Database)
- **Database:** Migrasi skema `users` dengan dukungan UUID dan NIK sebagai unik ID.
- **Data:** Penambahan data dummy 4 anggota kelompok dengan format email `NIM@student.upnyk.ac.id`.
- **API:** Struktur endpoint disiapkan untuk menerima JSON payload dari aplikasi mobile.

---

## 📝 List Revisi & Bug (Yang Masih Kurang)

Saat ini masih terdapat beberapa poin yang harus segera diselesaikan:

1. **Bug "Endpoint tidak ditemukan" (404):**
   - **Status:** Masih terjadi saat proses login.
   - **Penyebab:** Path request di `auth_controller.dart` belum sinkron 100% dengan handler di `server.go`.
   - **Tindakan:** Harus memastikan rute `POST /mobile/login` di backend sudah didaftarkan dan diakses dengan path yang tepat dari Flutter.

2. **Error Tipe Data (NoSuchMethodError):**
   - **Status:** Dalam tahap perbaikan (casting `Map<String, dynamic>`).
   - **Tindakan:** Memastikan struktur JSON yang dikirim backend sesuai dengan `Map` yang diharapkan oleh Flutter.

3. **Sinkronisasi Domain Email:**
   - **Status:** Perlu penyesuaian format email di database dan validasi input di `LoginPage`.
   - **Tindakan:** Menyamakan input user di aplikasi (email lengkap) dengan data di SQL agar proses pencarian user di database tidak null.

---

