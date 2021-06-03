import 'package:bloom/Animation/slide_left_rout.dart';
import 'package:flutter/material.dart';

import '../filter.dart';

// My Own Imports

class FilterRow extends StatefulWidget {
  final ValueChanged<int> onSortChanged;
  final ValueChanged<Map<String, dynamic>> onFilterChanged;

  const FilterRow({Key key, this.onSortChanged, this.onFilterChanged}) : super(key: key);

  @override
  _FilterRowState createState() => _FilterRowState();
}

class _FilterRowState extends State<FilterRow> {
  int selectedRadioSort;
  bool satVal = false;
  bool sunVal = false;

  @override
  void initState() {
    super.initState();
    selectedRadioSort = 1;
  }

  setSelectedRadioSort(int val) {
    setState(() {
      selectedRadioSort = val;
      Navigator.pop(context);
    });
    widget.onSortChanged(val);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: () {
              _sortModalBottomSheet(context);
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.sort,
                    size: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Sort',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 20.0,
            width: 1.0,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
          InkWell(
            // onTap: () {
            //   Navigator.push(context, SlideLeftRoute(page: Filter()));
            // },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.filter_list,
                    size: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Filter',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sortModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Container(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'SORT BY',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Divider(
                          height: 1.0,
                        ),
                        RadioListTile(
                          value: 2,
                          groupValue: selectedRadioSort,
                          title: Text("Price -- Low to High"),
                          onChanged: (val) {
                            setSelectedRadioSort(val);
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile(
                          value: 3,
                          groupValue: selectedRadioSort,
                          title: Text("Price -- High to Low"),
                          onChanged: (val) {
                            setSelectedRadioSort(val);
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile(
                          value: 4,
                          groupValue: selectedRadioSort,
                          title: Text("Newest First"),
                          onChanged: (val) {
                            setSelectedRadioSort(val);
                          },
                          activeColor: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
