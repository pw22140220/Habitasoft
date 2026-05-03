import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/mock_backend_store.dart';
import 'view/admin/admin_state.dart';
import 'view/auth/home_screen.dart';

class HabitasoftApp extends StatelessWidget {
  const HabitasoftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MockBackendStore()),
        ChangeNotifierProvider(create: (_) => AdminState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Habitasoft',
        theme: ThemeData(
          primaryColor: const Color(0xFF0A896E),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0A896E),
            primary: const Color(0xFF0A896E),
            secondary: const Color(0xFF00715D),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
