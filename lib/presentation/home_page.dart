import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/connectivity/bloc/connectivity_bloc.dart';
import '../domain/new/bloc/new_bloc.dart';
import '../domain/popular/bloc/popular_bloc.dart';
import 'tabs/new_tab.dart';
import 'tabs/popular_tab.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivitySucces) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          context.read<PopularBloc>().add(CleanPopularCacheData());
          context.read<NewBloc>().add(CleanNewCacheData());

          context.read<PopularBloc>().add(const GetPopularPost());
          context.read<NewBloc>().add(const GetNewPost());
        } else if (state is ConnectivityError) {
          context.read<PopularBloc>().add(GetPopularCacheData());
          context.read<NewBloc>().add(GetNewCacheData());
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(days: 365),
              backgroundColor: Colors.pink[100],
              content: Center(
                child: Text(
                    'Oh no, the Internet has left us, I don’t know why we offended him so much ...',
                    style: TextStyle(color: Colors.grey[700])),
              )));
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            title: TextField(
                onTapOutside: (event) => FocusNode().unfocus(),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  // Add a clear button to the search bar
                  suffixIcon: Icon(
                    Icons.search,
                  ),
                  // Add a search icon or button to the search bar
                )),
            bottom: const TabBar(
                padding: EdgeInsets.symmetric(horizontal: 8),
                tabs: [
                  Tab(text: 'New'),
                  Tab(text: 'Popular'),
                ]),
          ),
          body: const TabBarView(
            children: [
              NewTab(),
              PopularTab(),
            ],
          ),
        ),
      ),
    );
  }
}
