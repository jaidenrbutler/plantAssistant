import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_id_project/pages/city_select_page.dart';
import 'package:provider/provider.dart';
import 'package:plant_id_project/pages/home_page.dart';
import 'package:plant_id_project/pages/plant_id_page.dart';
import 'package:plant_id_project/pages/library_page.dart';
import 'package:plant_id_project/pages/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import './services/theme_provider.dart';
import './pages/login_page.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  cameras = await availableCameras();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Plant Assistant',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: MainScreen(cameraDescription: cameras.first),
    );
  }
}

class MainScreen extends StatefulWidget {
  final CameraDescription cameraDescription;

  const MainScreen({required this.cameraDescription, super.key});

  @override
  State<MainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const HomePage(),
      PlantIdScreen(description: widget.cameraDescription),
      const LibraryScreen(),
      const SettingsPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Plant Assistant',
      home: user == null
          ? const LoginPage()
          : Scaffold(
              body: _screens[_selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.camera), label: 'PlantID'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark), label: 'Library'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: 'Settings'),
                ],
              ),
            ),
    );
  }
}
