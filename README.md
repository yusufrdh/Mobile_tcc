## 🛠️ Perubahan Teknis (Update Terbaru)

### Frontend (Flutter)
- **Autentikasi:** Implementasi `AuthController` untuk integrasi penuh login, register, dan lupa sandi menggunakan `http` package.
- **Session Management:** Penggunaan `SessionManager` berbasis `shared_preferences` untuk menyimpan sesi user secara persisten.
- **State Management:** Implementasi *dynamic loading* pada `Dashboard` dan `Profile` untuk menampilkan nama user yang *login* secara *real-time*.
- **Security:** Konfigurasi `android:usesCleartextTraffic="true"` untuk akses API lokal pada emulator.
- **Fitur Baru:** Implementasi QR Code generator pada kartu pendonor dan fitur edit profil yang tersinkronisasi langsung ke database.

### Backend (Golang & Database)
- **Database:** Migrasi skema `users` dengan dukungan UUID, NIK, dan sistem koordinat (lat/long) untuk perhitungan jarak.
- **API:** Penambahan *endpoint* `/mobile/register`, `/mobile/forgot-password`, dan `/mobile/donor` (update profil) dengan penanganan JSON payload yang *robust*.
- **Security:** Implementasi `bcrypt` untuk enkripsi *password* pengguna baru dan *reset* sandi.
- **Fixes:** Penanganan error `column u.location does not exist` dengan optimasi query jarak langsung menggunakan kolom lat/long.

---

## 📋 List Revisi & Bug (Yang Masih Kurang)

Saat ini masih terdapat beberapa poin yang harus segera diselesaikan:

1. **Dashboard Stok Darah Real-time:**
   - **Status:** Masih menggunakan data dummy (hardcode).
   - **Tindakan:** Perlu implementasi *fetch* data stok asli dari tabel `blood_stock` di database.

2. **Sistem Tanggap Darurat (Emergency Broadcast):**
   - **Status:** Dalam tahap perencanaan struktur data.
   - **Tindakan:** Integrasi *endpoint* `/mobile/broadcast/active` untuk menerima notifikasi darurat.

3. **Riwayat Donasi:**
   - **Status:** Belum terhubung ke UI.
   - **Tindakan:** Membuat *handler* backend untuk narik data dari tabel `donation_history` berdasarkan `donor_id`.

4. **Notifikasi (Push Notification):**
   - **Status:** Sistem backend (FCM) sudah siap.
   - **Tindakan:** Integrasi `firebase_messaging` di sisi Flutter untuk menangkap *broadcast* darurat dari backend.
