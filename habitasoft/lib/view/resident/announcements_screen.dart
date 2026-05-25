import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'profile_screen.dart';
import '../../models/anuncio_model.dart';
import '../../services/anuncio_service.dart';
import '../../services/auth_service.dart';

class AnnouncementsScreen extends StatefulWidget {
  final String userName;
  final String? token;

  const AnnouncementsScreen({super.key, required this.userName, this.token});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  List<Anuncio> _anuncios = [];
  bool _isLoading = false;
  String? _error;
  int _condominioId = 1;

  AnuncioService get _service => AnuncioService(token: widget.token);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _condominioId = await AuthService.obtenerCondominioId(widget.token);
    _cargarAnuncios();
  }

  Future<void> _cargarAnuncios() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final anuncios = await _service.listarResidente(_condominioId);
      anuncios.sort((a, b) {
        if (a.destacado != b.destacado) {
          return b.destacado ? 1 : -1;
        }
        final fechaA = a.fechaCreacion ?? '';
        final fechaB = b.fechaCreacion ?? '';
        return fechaB.compareTo(fechaA);
      });
      setState(() => _anuncios = anuncios);
    } catch (e) {
      setState(() => _error = 'Error al cargar anuncios');
    }
    setState(() => _isLoading = false);
  }

  String _formatFecha(String? fecha) {
    if (fecha == null || fecha.length < 10) return '';
    final parts = fecha.substring(0, 10).split('-');
    if (parts.length != 3) return fecha;
    final meses = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    final mes = int.tryParse(parts[1]);
    if (mes == null || mes < 1 || mes > 12) return fecha;
    return '${parts[2]} ${meses[mes - 1]} ${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      bottomNavigationBar: _AnnouncementsBottomNavBar(
        userName: widget.userName,
        token: widget.token,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const _AnnouncementsHeader(),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _cargarAnuncios,
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      )
                      : _anuncios.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.announcement_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No hay anuncios disponibles',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: _cargarAnuncios,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          itemCount: _anuncios.length,
                          itemBuilder:
                              (ctx, i) => _AnuncioCard(
                                anuncio: _anuncios[i],
                                fechaFormateada: _formatFecha(
                                  _anuncios[i].fechaCreacion,
                                ),
                              ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementsHeader extends StatelessWidget {
  const _AnnouncementsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 18),
      decoration: const BoxDecoration(
        color: Color(0xFFFF9800),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          const SizedBox(width: 4),
          const Text(
            'Anuncios Comunitarios',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnuncioCard extends StatelessWidget {
  final Anuncio anuncio;
  final String fechaFormateada;

  const _AnuncioCard({required this.anuncio, required this.fechaFormateada});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            anuncio.destacado
                ? Border.all(color: const Color(0xFFFF9800), width: 1.5)
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  anuncio.destacado ? Icons.star : Icons.apartment,
                  color:
                      anuncio.destacado
                          ? const Color(0xFFFF9800)
                          : const Color(0xFFFF9800),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            anuncio.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                        if (anuncio.destacado)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9800).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.star,
                              size: 14,
                              color: Color(0xFFFF9800),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      anuncio.creadorNombre != null
                          ? '${anuncio.creadorNombre} • $fechaFormateada'
                          : fechaFormateada,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            anuncio.contenido,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementsBottomNavBar extends StatelessWidget {
  final String userName;
  final String? token;

  const _AnnouncementsBottomNavBar({required this.userName, this.token});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => DashboardScreen(userName: userName, token: token),
                ),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ProfileScreen(userName: userName, token: token),
                ),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0B64D8),
        unselectedItemColor: const Color(0xFF9E9E9E),
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24),
            activeIcon: Icon(Icons.home, size: 24),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined, size: 24),
            activeIcon: Icon(Icons.calendar_today, size: 24),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none, size: 24),
            activeIcon: Icon(Icons.notifications, size: 24),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 24),
            activeIcon: Icon(Icons.person, size: 24),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
