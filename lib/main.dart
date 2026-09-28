import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/nav_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NavController.instance.load();
  runApp(const AmumaApp());
}

class AmumaApp extends StatelessWidget {
  const AmumaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMUMA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const SplashScreen(),
    );
  }
}