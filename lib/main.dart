import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:notable/arch/simple_bloc_delegate.dart';
import 'package:notable/screen/home_screen.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(NotableApp());
}

class NotableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notable',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(title: 'Notable'),
    );
  }
}
