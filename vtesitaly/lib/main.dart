import 'package:flutter/material.dart';
import 'package:vtesitaly/views/components/menu_appbar.dart';
import 'package:vtesitaly/views/components/menu_enddrawer.dart';
import 'package:vtesitaly/views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(40, 95, 230, 1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<GlobalKey> _keys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];


  void _scrollToWidget (GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(
          seconds: 1
        ),
        curve: Curves.easeInOutSine
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MenuAppBar(callbacks: [
          () => _scrollToWidget(_keys[0]),
          () => _scrollToWidget(_keys[1]),
          () => _scrollToWidget(_keys[2]),
          () => _scrollToWidget(_keys[3]),
          () => _scrollToWidget(_keys[4]),
        ],
      ),
      endDrawer: MenuEndDrawer(callbacks: [
        () => _scrollToWidget(_keys[0]),
        () => _scrollToWidget(_keys[1]),
        () => _scrollToWidget(_keys[2]),
        () => _scrollToWidget(_keys[3]),
        () => _scrollToWidget(_keys[4]),
      ],),
      body: HomePage(keys: _keys)
    );
  }
}
