import 'package:flutter/material.dart';



class ConnectionErrorScreen extends StatelessWidget {
  const ConnectionErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  SizedBox(
        child: Center(
          child: Text('Connection Error Screen'),
        ),
      ),
    );
  }
}
