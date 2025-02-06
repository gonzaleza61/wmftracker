import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/weight_listview.dart';

import '../providers/auth.dart';
import '../providers/user_weight_info.dart';
import '../providers/weight_info.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/Dashboard';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _userWeight = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset(
                  'lib/assets/WMFlogoExtended.PNG',
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    color: Colors.black,
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.person_add),
                  ),
                  IconButton(
                    color: Colors.black,
                    onPressed: () =>
                        Provider.of<Auth>(context, listen: false).logout(),
                    icon: const Icon(Icons.logout),
                  ),
                ],
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: WeightListView(),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            child: const Icon(Icons.add),
            onPressed: () {
              Provider.of<UserWeightInfo>(context, listen: false).addWeight(
                  WeightInfo(
                      fbID: null, weightNum: 270, weightDate: DateTime.now()));
            }),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Overview',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.graph_circle),
              label: 'Chart',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Settings',
            ),
          ],
        ));
  }
}
