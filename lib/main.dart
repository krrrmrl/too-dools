import 'package:flutter/material.dart';
import 'package:too_dools/pages/layout.dart';

// import 'package:too_dools/services/notif_service.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Too-dools',
      debugShowCheckedModeBanner: false,
      home: AppLayout(),
    );
  }
}
