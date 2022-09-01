import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    "images/large_compressed.jpg",
                    fit: BoxFit.cover,
                  ),
                  title: const Text('Restaurant'),
                  titlePadding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children: [Text("data")],
            ),
          )),
    );
  }
}
