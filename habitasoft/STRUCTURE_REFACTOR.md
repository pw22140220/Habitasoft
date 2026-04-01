# Refactorización de Estructura de Archivos - Habitasoft

## 📁 Nueva Estructura de Directorios

```
lib/view/
├── auth/                    # Pantallas de autenticación (comunes a todos)
│   ├── home_screen.dart          # Pantalla de login principal
│   └── biometric_prompt_sheet.dart # Modal de activación biométrica
│
├── resident/               # Pantallas para residentes
│   ├── dashboard.dart           # Dashboard principal
│   ├── amenities_screen.dart    # Reserva de amenidades
│   ├── announcements_screen.dart # Anuncios comunitarios
│   ├── notifications_screen.dart # Notificaciones
│   ├── payment_reminders_screen.dart # Recordatorios de pago
│   ├── profile_screen.dart      # Perfil del usuario
│   ├── qr_generation_screen.dart # Generación de QR para visitas
│   ├── account_settings_screen.dart # Configuración de cuenta
│   ├── change_password_screen.dart # Cambio de contraseña
│   ├── edit_profile_screen.dart # Editar perfil
│   ├── privacy_security_screen.dart # Privacidad y seguridad
│   └── legal_document_screen.dart # Documentos legales
│
├── admin/                  # Pantallas para administradores (vacío por ahora)
│   └── (futuras pantallas de admin)
│
└── guard/                 # Pantallas para guardias (vacío por ahora)
    └── (futuras pantallas de guardia)
```

## 🔄 Cambios Realizados

### 1. **Movimiento de Archivos**
- `home_screen.dart` → `auth/home_screen.dart`
- `biometric_prompt_sheet.dart` → `auth/biometric_prompt_sheet.dart`
- Todas las demás pantallas → `resident/`

### 2. **Actualización de Imports**
Todos los imports han sido actualizados para usar rutas relativas correctas:

#### Ejemplos:
- **Antes**: `import 'package:habitasoft/view/dashboard.dart';`
- **Después**: `import 'dashboard.dart';` (dentro de `resident/`)

- **Antes**: `import 'home_screen.dart';` (desde `account_settings_screen.dart`)
- **Después**: `import '../auth/home_screen.dart';`

- **Antes**: `import '../services/auth_service.dart';` (desde `home_screen.dart`)
- **Después**: `import '../../services/auth_service.dart';`

### 3. **Actualización de main.dart**
- **Antes**: `import 'package:habitasoft/view/home_screen.dart';`
- **Después**: `import 'package:habitasoft/view/auth/home_screen.dart';`

## 🎯 Beneficios de la Nueva Estructura

### 1. **Escalabilidad**
- Fácil añadir nuevas pantallas por rol
- Separación clara de responsabilidades
- Mejor organización para equipos grandes

### 2. **Mantenibilidad**
- Fácil encontrar pantallas por rol
- Menos conflictos en merge
- Mejor comprensión del código

### 3. **Seguridad**
- Separación lógica por permisos de usuario
- Fácil implementar guards de ruta por rol
- Mejor control de acceso

## 📋 Reglas para Nuevas Pantallas

### 1. **Pantallas de Autenticación (`auth/`)**
- Login, registro, recuperación de contraseña
- Modales relacionados con auth
- **Ejemplo**: `login_screen.dart`, `register_screen.dart`

### 2. **Pantallas de Residentes (`resident/`)**
- Todas las funcionalidades para residentes
- Dashboard, perfil, reservas, pagos, etc.
- **Ejemplo**: `new_feature_screen.dart`

### 3. **Pantallas de Administradores (`admin/`)**
- Gestión de condominio
- Reportes, configuración del sistema
- **Ejemplo**: `admin_dashboard.dart`, `user_management_screen.dart`

### 4. **Pantallas de Guardias (`guard/`)**
- Verificación de visitas
- Control de acceso
- **Ejemplo**: `guard_dashboard.dart`, `visitor_check_screen.dart`

## 🔧 Convenciones de Imports

### Dentro del mismo directorio:
```dart
import 'dashboard.dart';
import 'profile_screen.dart';
```

### Desde otro directorio de view:
```dart
import '../auth/home_screen.dart';      // Desde resident/ a auth/
import '../resident/dashboard.dart';    // Desde auth/ a resident/
```

### Desde servicios:
```dart
import '../../services/auth_service.dart';      // Desde view/auth/
import '../../services/biometric_service.dart'; // Desde view/resident/
```

## 🧪 Verificación de Compilación
- ✅ No hay errores de compilación
- ✅ Solo warnings de estilo (no críticos)
- ✅ Todos los imports funcionan correctamente

## 🚀 Próximos Pasos

### 1. **Implementar Riverpod**
- Crear providers por módulo/rol
- Separar estado por dominio

### 2. **Añadir Pantallas de Admin**
- Crear `admin/dashboard.dart`
- Implementar gestión de usuarios
- Añadir reportes y analytics

### 3. **Añadir Pantallas de Guardia**
- Crear `guard/dashboard.dart`
- Implementar verificación de QR
- Añadir registro de visitas

### 4. **Mejorar Routing**
- Implementar named routes
- Añadir guards por rol
- Mejorar navegación entre módulos

## 📊 Estado Actual
```
✅ auth/        - 2 archivos
✅ resident/    - 12 archivos
🔲 admin/       - 0 archivos (listo para futuras features)
🔲 guard/       - 0 archivos (listo para futuras features)
```

La refactorización está completa y lista para continuar con el desarrollo!