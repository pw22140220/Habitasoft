import 'package:flutter/material.dart';

class AccessLog {
  final String id;
  final String visitorName;
  final String department;
  final String documentId;
  final DateTime entryTime;
  final DateTime? exitTime;
  final String status;
  final String verifiedBy;
  final String? notes;

  AccessLog({
    required this.id,
    required this.visitorName,
    required this.department,
    required this.documentId,
    required this.entryTime,
    this.exitTime,
    required this.status,
    required this.verifiedBy,
    this.notes,
  });
}

final List<AccessLog> mockAccessLogs = [
  AccessLog(
    id: 'log_001',
    visitorName: 'Luis Fernández',
    department: '305',
    documentId: 'INE: LFFN920315',
    entryTime: DateTime.now().subtract(const Duration(hours: 1)),
    status: 'Dentro',
    verifiedBy: 'Carlos Rodríguez',
    notes: 'Visita autorizada por residente',
  ),
  AccessLog(
    id: 'log_002',
    visitorName: 'María García',
    department: '402',
    documentId: 'INE: MGGD880522',
    entryTime: DateTime.now().subtract(const Duration(hours: 3)),
    exitTime: DateTime.now().subtract(const Duration(minutes: 30)),
    status: 'Salida',
    verifiedBy: 'Carlos Rodríguez',
  ),
  AccessLog(
    id: 'log_003',
    visitorName: 'Reparto: DHL',
    department: 'Administración',
    documentId: 'Guía: 1234567890',
    entryTime: DateTime.now().subtract(const Duration(hours: 2)),
    exitTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
    status: 'Salida',
    verifiedBy: 'Carlos Rodríguez',
    notes: 'Paquete firmado por recepción',
  ),
  AccessLog(
    id: 'log_004',
    visitorName: 'Carlos Mendoza',
    department: '208',
    documentId: 'INE: CMMR901212',
    entryTime: DateTime.now().subtract(const Duration(hours: 5)),
    status: 'Dentro',
    verifiedBy: 'Carlos Rodríguez',
  ),
  AccessLog(
    id: 'log_005',
    visitorName: 'Técnico CFE',
    department: 'Subestación',
    documentId: 'Orden: CFE-2026-0456',
    entryTime: DateTime.now().subtract(const Duration(hours: 6)),
    exitTime: DateTime.now().subtract(const Duration(hours: 4)),
    status: 'Salida',
    verifiedBy: 'Carlos Rodríguez',
    notes: 'Mantenimiento programado',
  ),
  AccessLog(
    id: 'log_006',
    visitorName: 'Ana Torres',
    department: '101',
    documentId: 'INE: ATLS950708',
    entryTime: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
    exitTime: DateTime.now().subtract(const Duration(days: 1, hours: 14)),
    status: 'Denegado',
    verifiedBy: 'Carlos Rodríguez',
    notes: 'No estaba en lista de autorizados',
  ),
];

class WatchmanHistoryScreen extends StatefulWidget {
  final String userName;

  const WatchmanHistoryScreen({super.key, required this.userName});

  @override
  State<WatchmanHistoryScreen> createState() => _WatchmanHistoryScreenState();
}

class _WatchmanHistoryScreenState extends State<WatchmanHistoryScreen> {
  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Dentro', 'Salida', 'Denegado'];

  List<AccessLog> get _filteredLogs {
    return mockAccessLogs.where((log) {
      return _selectedFilter == 'Todos' || log.status == _selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Accesos'),
        backgroundColor: const Color(0xFF15806C),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filtros
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtrar por estado:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        _filters.map((f) {
                          final isSelected = _selectedFilter == f;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(f),
                              selected: isSelected,
                              onSelected:
                                  (_) => setState(() => _selectedFilter = f),
                              selectedColor: const Color(0xFF15806C),
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Resumen del día
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildStatCard(
                  'Total',
                  mockAccessLogs.length.toString(),
                  Colors.blue,
                ),
                _buildStatCard(
                  'Dentro',
                  mockAccessLogs
                      .where((l) => l.status == 'Dentro')
                      .length
                      .toString(),
                  Colors.green,
                ),
                _buildStatCard(
                  'Salida',
                  mockAccessLogs
                      .where((l) => l.status == 'Salida')
                      .length
                      .toString(),
                  Colors.orange,
                ),
                _buildStatCard(
                  'Denegado',
                  mockAccessLogs
                      .where((l) => l.status == 'Denegado')
                      .length
                      .toString(),
                  Colors.red,
                ),
              ],
            ),
          ),

          // Lista
          Expanded(
            child:
                _filteredLogs.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay registros con estos filtros',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredLogs.length,
                      itemBuilder: (context, index) {
                        final log = _filteredLogs[index];
                        return _AccessLogCard(log: log);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ),
    );
  }
}

class _AccessLogCard extends StatelessWidget {
  final AccessLog log;

  const _AccessLogCard({required this.log});

  Color _statusColor(String status) {
    switch (status) {
      case 'Dentro':
        return Colors.green;
      case 'Salida':
        return Colors.orange;
      case 'Denegado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Dentro':
        return Icons.login;
      case 'Salida':
        return Icons.logout;
      case 'Denegado':
        return Icons.block;
      default:
        return Icons.help_outline;
    }
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _statusColor(log.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _statusIcon(log.status),
                color: _statusColor(log.status),
                size: 22,
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
                          log.visitorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(log.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          log.status,
                          style: TextStyle(
                            fontSize: 11,
                            color: _statusColor(log.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.apartment, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Depto ${log.department}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.badge_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          log.documentId,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Entrada: ${_formatTime(log.entryTime)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      if (log.exitTime != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          'Salida: ${_formatTime(log.exitTime!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        _formatDate(log.entryTime),
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  if (log.notes != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        log.notes!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
