import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/home_screen.dart';
import 'admin_state.dart';
import '../../services/biometric_preferences_service.dart';
import '../../services/perfil_service.dart';
import 'profile/admin_personal_info_screen.dart';
import 'profile/admin_security_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  UsuarioPerfil? _perfil;
  bool _isLoading = true;

  PerfilService get _service {
    final token = Provider.of<AdminState>(context, listen: false).token;
    return PerfilService(token: token);
  }

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    try {
      final perfil = await _service.obtenerPerfil();
      setState(() => _perfil = perfil);
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.green[700],
        elevation: 2,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.green[300]!,
                                width: 3,
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _perfil?.nombre ?? '---',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _perfil?.email ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _perfil?.rol ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Cuenta
                    _buildSectionTitle('Cuenta'),
                    _buildOptionItem(
                      icon: Icons.person_outline,
                      title: 'Información personal',
                      subtitle: 'Actualiza tus datos personales',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => AdminPersonalInfoScreen(
                                  token:
                                      Provider.of<AdminState>(
                                        context,
                                        listen: false,
                                      ).token,
                                ),
                          ),
                        ).then((_) => _cargarPerfil());
                      },
                    ),
                    _buildOptionItem(
                      icon: Icons.security,
                      title: 'Seguridad',
                      subtitle: 'Cambiar contraseña, autenticación',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => AdminSecurityScreen(
                                  token:
                                      Provider.of<AdminState>(
                                        context,
                                        listen: false,
                                      ).token,
                                ),
                          ),
                        );
                      },
                    ),
                    _buildOptionItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notificaciones',
                      subtitle: 'Configurar preferencias de notificaciones',
                      onTap: () {
                        // TODO: Navegar a pantalla de notificaciones
                      },
                    ),
                    const SizedBox(height: 24),

                    // Configuración
                    _buildSectionTitle('Configuración'),
                    _buildOptionItem(
                      icon: Icons.language,
                      title: 'Idioma',
                      subtitle: 'Español',
                      onTap: () {
                        // TODO: Navegar a pantalla de idioma
                      },
                    ),
                    _buildOptionItem(
                      icon: Icons.dark_mode_outlined,
                      title: 'Tema',
                      subtitle: 'Claro',
                      onTap: () {
                        // TODO: Navegar a pantalla de tema
                      },
                    ),
                    const SizedBox(height: 24),

                    // Soporte
                    _buildSectionTitle('Soporte'),
                    _buildOptionItem(
                      icon: Icons.help_outline,
                      title: 'Ayuda y soporte',
                      subtitle: 'Preguntas frecuentes, contactar soporte',
                      onTap: () {
                        // TODO: Navegar a pantalla de ayuda
                      },
                    ),
                    _buildOptionItem(
                      icon: Icons.info_outline,
                      title: 'Acerca de',
                      subtitle: 'Versión 1.0.0',
                      onTap: () {
                        // TODO: Navegar a pantalla acerca de
                      },
                    ),
                    const SizedBox(height: 32),

                    // Cerrar sesión
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showLogoutConfirmationDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.red[100]!),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 8),
                            Text(
                              'Cerrar sesión',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.green[700]),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await BiometricPreferencesService.clearSession();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
