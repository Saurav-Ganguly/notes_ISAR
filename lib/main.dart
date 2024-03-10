import 'package:flutter/material.dart';
import 'package:notes_isar/models/note_database.dart';
import 'package:notes_isar/pages/home_page.dart';
import 'package:notes_isar/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // initialize note isar db
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(
    MultiProvider(
      providers: [
        //Note Provider
        ChangeNotifierProvider(create: (context) => NoteDatabase()),
        //Theme Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
