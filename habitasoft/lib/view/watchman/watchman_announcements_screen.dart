import 'package:flutter/material.dart';
import '../../models/anuncio_model.dart';
import '../../services/anuncio_service.dart';
import '../../services/auth_service.dart';

class WatchmanAnnouncementsScreen extends StatefulWidget {
  final String userName;
  final String? token;

  const WatchmanAnnouncementsScreen({
    super.key,
    required this.userName,
    this.token,
  });

  @override
  State<WatchmanAnnouncementsScreen> createState() =>
      _WatchmanAnnouncementsScreenState();
}

class _WatchmanAnnouncementsScreenState
    extends State<WatchmanAnnouncementsScreen> {
  List<Anuncio> _anuncios = [];
  bool _isLoading = true;
  String? _error;
  int _condominioId = 1;

  AnuncioService get _service => AnuncioService(token: widget.token);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _condominioId = await AuthService.obtenerCondominioIdGuardia(widget.token);
    _cargarAnuncios();
  }

  Future<void> _cargarAnuncios() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final anuncios = await _service.listarGuardia(_condominioId);
      anuncios.sort((a, b) {
        if (a.destacado != b.destacado) return b.destacado ? 1 : -1;
        final fa = a.fechaCreacion ?? '';
        final fb = b.fechaCreacion ?? '';
        return fb.compareTo(fa);
      });
      if (mounted) setState(() => _anuncios = anuncios);
    } catch (e) {
      if (mounted) setState(() => _error = 'Error: ${e.toString()}');
    }
    if (mounted) setState(() => _isLoading = false);
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
      appBar: AppBar(
        title: const Text('Avisos del Administrador'),
        backgroundColor: const Color(0xFF15806C),
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error!, style: const TextStyle(color: Colors.red)),
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
                      'No hay avisos disponibles',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _cargarAnuncios,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _anuncios.length,
                  itemBuilder: (ctx, i) => _buildAnnouncementCard(_anuncios[i]),
                ),
              ),
    );
  }

  Widget _buildAnnouncementCard(Anuncio anuncio) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color:
              anuncio.destacado
                  ? const Color(0xFFFF9800).withOpacity(0.3)
                  : Colors.grey[200]!,
          width: anuncio.destacado ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        anuncio.titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (anuncio.destacado)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: Color(0xFFFF9800),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'DESTACADO',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFFFF9800),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey[100]),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anuncio.contenido,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anuncio.creadorNombre != null
                              ? 'Por: ${anuncio.creadorNombre}'
                              : '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatFecha(anuncio.fechaCreacion),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
