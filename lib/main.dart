import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/domain/connectivity/bloc/connectivity_bloc.dart';
import 'package:gallery/domain/new/bloc/new_bloc.dart';
import 'package:gallery/domain/popular/bloc/popular_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'domain/entity/post.dart';
import 'presentation/home_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(ImageAdapter());

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
          fontFamily: 'Roboto',
          inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 189, 189, 189), width: 0.5),
                borderRadius: BorderRadius.circular(15.0),
              ),
              suffixIconColor: Colors.pink),
          primarySwatch: Colors.pink,
          primaryColor: Colors.pink,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white, foregroundColor: Colors.amber),
          tabBarTheme: TabBarTheme(
              labelStyle: const TextStyle(fontSize: 20),
              unselectedLabelStyle: const TextStyle(fontSize: 20),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400])),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) => PopularBloc(),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => NewBloc(),
          ),
          BlocProvider(
            create: (context) => ConnectivityBloc()..add(CheckConnection()),
            lazy: false,
          ),
        ],
        child: const SafeArea(child: Home()),
      ),
    );
  }
}
