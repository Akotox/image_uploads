import 'package:flutter/material.dart';
import 'package:image_uploads/image_uploads.dart';
import 'package:image_uploads/providers/image_picker_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_) => ImageNotifier()),

   
  ], 
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GridView',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const Scaffold(
        backgroundColor: Colors.white,
        body:  Center(
          child: ImageUploads()
        ),
      ),
    );
  }
}
