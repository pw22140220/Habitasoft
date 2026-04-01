import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'profile_screen.dart';

// Pantalla para ver recordatorios de pagos pendientes
class PaymentRemindersScreen extends StatelessWidget {
  final String userName;

  const PaymentRemindersScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      bottomNavigationBar: _PaymentBottomNavBar(userName: userName),
      body: SafeArea(
        child: Column(
          children: [
            const _PaymentHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _PaymentCard(
                      title: 'Cuota de Mantenimiento Enero',
                      amount: '\$250.00',
                      dueDate: 'Vence: 15 de Enero',
                      status: 'Pendiente',
                      statusColor: const Color(0xFFFF9800),
                    ),
                    const SizedBox(height: 12),
                    _PaymentCard(
                      title: 'Cuota de Mantenimiento Diciembre',
                      amount: '\$250.00',
                      dueDate: 'Vencido: 15 de Diciembre',
                      status: 'Vencido',
                      statusColor: const Color(0xFFF44336),
                    ),
                    const SizedBox(height: 12),
                    _PaymentCard(
                      title: 'Fondo de Reserva',
                      amount: '\$100.00',
                      dueDate: 'Vence: 20 de Enero',
                      status: 'Pendiente',
                      statusColor: const Color(0xFFFF9800),
                    ),
                    const SizedBox(height: 12),
                    _PaymentCard(
                      title: 'Cuota de Mantenimiento Noviembre',
                      amount: '\$250.00',
                      dueDate: 'Pagado: 10 de Noviembre',
                      status: 'Pagado',
                      statusColor: const Color(0xFF4CAF50),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 60,
                            color: Color(0xFF9C27B0),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Pantalla en construcción',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Esta pantalla mostrará los recordatorios de pagos pendientes y el historial de cuotas del condominio.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF666666),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Lógica para pagar
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9C27B0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Pagar Ahora',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  // Lógica para ver detalles
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFF9C27B0),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Text(
                                  'Ver Detalles',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF9C27B0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== HEADER DE PAGOS ==================

class _PaymentHeader extends StatelessWidget {
  const _PaymentHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF9C27B0),
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
            'Recordatorios de Pago',
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

// ================== TARJETA DE PAGO ==================

class _PaymentCard extends StatelessWidget {
  final String title;
  final String amount;
  final String dueDate;
  final String status;
  final Color statusColor;

  const _PaymentCard({
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dueDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // Lógica para ver detalles
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Ver detalles',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9C27B0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para pagar
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Pagar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================== BOTTOM NAVIGATION BAR ==================

class _PaymentBottomNavBar extends StatelessWidget {
  final String userName;

  const _PaymentBottomNavBar({required this.userName});

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
        currentIndex: 0, // Índice para inicio
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardScreen(userName: userName),
                ),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(userName: userName),
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
