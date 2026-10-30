import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'data/api_client.dart';
import 'data/product.dart';
import 'data/product_repository.dart';
import 'screens/login_screen.dart';
import 'screens/products_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const ShopApp());

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiClient(http.Client());
    const storage = FlutterSecureStorage();
    
    return MaterialApp(
      title: 'Cartify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A), // Slate 900
          primary: const Color(0xFF0F172A),
          secondary: const Color(0xFF3B82F6), // Blue 500
          surface: Colors.white,
          background: const Color(0xFFF8FAFC), // Slate 50
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          iconTheme: IconThemeData(color: Color(0xFF0F172A)),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        ),
      ),
      home: SessionGate(api: api, storage: storage),
    );
  }
}

class SessionGate extends StatefulWidget {
  const SessionGate({super.key, required this.api, required this.storage});
  final ApiClient api;
  final FlutterSecureStorage storage;

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  String? _token;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final startTime = DateTime.now();
    final token = await widget.storage.read(key: 'accessToken');
    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    if (elapsed < 2000) {
      await Future.delayed(Duration(milliseconds: 2000 - elapsed));
    }

    if (!mounted) return;
    setState(() {
      _token = token;
      _loading = false;
    });
  }

  Future<void> _signIn(String token) async {
    await widget.storage.write(key: 'accessToken', value: token);
    if (mounted) setState(() => _token = token);
  }

  Future<void> _signOut() async {
    await widget.storage.delete(key: 'accessToken');
    if (mounted) setState(() => _token = null);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _loading
          ? const SplashScreen(key: ValueKey('splash'))
          : _token == null
              ? LoginScreen(
                  key: const ValueKey('login'),
                  api: widget.api,
                  onSignedIn: _signIn,
                )
              : ProductsScreen(
                  key: const ValueKey('products'),
                  repository: ProductRepository(widget.api),
                  onSignOut: _signOut,
                ),
    );
  }
}

Product productFromJson(Map<String, dynamic> json) => Product.fromJson(json);
