package app

import (
	"os"
	"strconv"
	"time"
	"github.com/joho/godotenv"
)

type Config struct {
	Port             string
	DatabaseURL      string
	JWTSecret        string
	QRSecretKey      string
	TokenTTL         time.Duration
	AuthRequired     bool
	DemoMode         bool
	FirebaseCredPath string
	PMILatitude      float64
	PMILongitude     float64
	PMIName          string
	PMILocation      string
	EligibleRadius   float64
}

func LoadConfig() Config {
	_ = godotenv.Load() // Abaikan error jika .env tidak ada

	authReq, _ := strconv.ParseBool(getEnv("AUTH_REQUIRED", "true"))
	demoMode, _ := strconv.ParseBool(getEnv("DEMO_MODE", "false"))

	return Config{
		Port:             getEnv("PORT", "8080"),
		DatabaseURL:      getEnv("DATABASE_URL", "postgres://postgres:postgres@localhost:5432/bank_darah?sslmode=disable"),
		JWTSecret:        getEnv("JWT_SECRET", "super-secret-key-ganti-di-production"),
		QRSecretKey:      getEnv("QR_SECRET_KEY", "32-byte-long-secret-key-for-aes!"),
		TokenTTL:         24 * time.Hour,
		AuthRequired:     authReq,
		DemoMode:         demoMode,
		FirebaseCredPath: getEnv("FIREBASE_CRED_PATH", "google-services.json"),
		PMILatitude:      -7.7956, // Default Jogja
		PMILongitude:     110.3695,
		PMIName:          "PMI Kota Yogyakarta",
		PMILocation:      "UTD PMI Kota Yogyakarta",
		EligibleRadius:   25.0, // 25 KM
	}
}

func getEnv(key, fallback string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return fallback
}