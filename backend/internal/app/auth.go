package app

import (
	"context"
	"errors"
	"net/http"
	"strings"
	"time"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

type contextKey string
const adminContextKey = contextKey("admin")

func signToken(secret string, user AdminUser, ttl time.Duration) (string, error) {
	claims := jwt.MapClaims{
		"sub":  user.ID,
		"role": user.Role,
		"exp":  time.Now().Add(ttl).Unix(),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(secret))
}

func parseToken(secret, tokenString string) (AdminUser, error) {
	token, err := jwt.Parse(tokenString, func(t *jwt.Token) (interface{}, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("metode signing tidak valid")
		}
		return []byte(secret), nil
	})
	if err != nil || !token.Valid {
		return AdminUser{}, errors.New("token tidak valid")
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return AdminUser{}, errors.New("klaim token tidak valid")
	}

	return AdminUser{
		ID:   claims["sub"].(string),
		Role: claims["role"].(string),
	}, nil
}

func verifyPassword(hash, password string) bool {
	return bcrypt.CompareHashAndPassword([]byte(hash), []byte(password)) == nil
}

func bearerToken(r *http.Request) string {
	authHeader := r.Header.Get("Authorization")
	if strings.HasPrefix(authHeader, "Bearer ") {
		return strings.TrimPrefix(authHeader, "Bearer ")
	}
	cookie, err := r.Cookie("admin_token")
	if err == nil {
		return cookie.Value
	}
	return ""
}

func withAdmin(ctx context.Context, admin AdminUser) context.Context {
	return context.WithValue(ctx, adminContextKey, admin)
}

func adminFromContext(ctx context.Context) AdminUser {
	admin, _ := ctx.Value(adminContextKey).(AdminUser)
	return admin
}