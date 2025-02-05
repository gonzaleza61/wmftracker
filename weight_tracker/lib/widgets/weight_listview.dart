import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/user_weight_info.dart';
import '../providers/weight_info.dart';

class WeightListView extends StatefulWidget {
  const WeightListView({super.key});

  @override
  State<WeightListView> createState() => _WeightListViewState();
}

class _WeightListViewState extends State<WeightListView> {
  @override
  var _isInIt = true;

  @override
  void initState() {
    //of context doesnt work in initstart
    super.initState();
  }

//test
  @override
  void didChangeDependencies() {
    if (_isInIt) {
      Provider.of<UserWeightInfo>(context).fetchWeight();
    }
    _isInIt = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final weightData = Provider.of<UserWeightInfo>(context).preMadeList;
    List<WeightInfo> fetchedItems = [...weightData];
    return ListView.builder(
      reverse: true,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.grey[100],
          child: ListTile(
            leading: CircleAvatar(
                foregroundColor: Colors.white,
                backgroundColor: index - 1 < 0
                    ? Colors.black
                    : fetchedItems[index].weightNum ==
                            fetchedItems[index - 1].weightNum
                        ? Colors.grey
                        : fetchedItems[index].weightNum >
                                fetchedItems[index - 1].weightNum
                            ? Colors.red
                            : Colors.green,
                child: Text(fetchedItems[index].weightNum.toString())),
            title: const Text('Percent Change'),
            trailing: Text(
              DateFormat.yMMMd().format(fetchedItems[index].weightDate),
            ),
          ),
        );
      },
      itemCount: fetchedItems.length,
    );
  }
}
