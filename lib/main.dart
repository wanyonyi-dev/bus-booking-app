import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/search_bus_screen.dart';
import 'screens/unified_booking_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/support_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the platform-specific options
  );

  // Run the app
  runApp(const BusBookingApp());
}

class BusBookingApp extends StatelessWidget {
  const BusBookingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/search_bus': (context) => const SearchBusScreen(),
        '/bookings': (context) => const UnifiedBookingScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/support': (context) => const SupportScreen(),
      },
    );
  }
}
