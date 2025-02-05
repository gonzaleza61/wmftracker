import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

import '../providers/auth.dart';

import '../widgets/weight_listview.dart';
import '../widgets/weight_chart.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(alignment: Alignment.topCenter, children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Hello Name'),
          ),
          body: Column(
            children: [
              const Expanded(child: WeightListView()),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 5,
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.home,
                          ),
                        ),
                        const Text(
                          'Home',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.person,
                          ),
                        ),
                        const Text(
                          'Profile',
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.person_add),
                        ),
                        const Text('Add Friend'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.settings),
                        ),
                        const Text(
                          'Settings',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: SizedBox(
            height: 50,
            width: 50,
            child: FittedBox(
              child: FloatingActionButton(
                  child: const Icon(
                    Icons.add,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 250,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Add Your Weight',
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _controller.play();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Submit',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
        ),
        ConfettiWidget(
          confettiController: _controller,
          numberOfParticles: 20,
          shouldLoop: false,
          blastDirectionality: BlastDirectionality.explosive,
          blastDirection: pi / 2,
        ),
      ]),
    );
  }
}
