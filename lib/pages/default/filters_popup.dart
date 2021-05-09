import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpiboardapp/pages/change_notifier/GlobalNotifier.dart';
import 'package:kpiboardapp/pages/default/date_ext.dart';
import 'package:kpiboardapp/pages/default/posts.dart';
import 'package:provider/provider.dart';

class FiltersPopup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FiltersState();
}

class _FiltersState extends State<FiltersPopup> {
  DateTime startDate = null;
  DateTime endDate = null;
  var text = TextEditingController();
  var author = TextEditingController();
  bool isDated = false;

  Future<void> _startDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate)
      setState(() {
        startDate = picked;
      });
  }

  Future<void> _endDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate)
      setState(() {
        endDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<GlobalNotifier>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(controller: text),
          TextField(controller: author),
          RadioListTile(
            title: const Text('All the time'),
            value: false,
            groupValue: isDated,
            onChanged: (value) {
              setState(() {
                isDated = value;
              });
            },
          ),
          RadioListTile(
            title: const Text('Selected dates'),
            value: true,
            groupValue: isDated,
            onChanged: (value) {
              setState(() {
                isDated = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton(
                  textColor: isDated ? Colors.black : Colors.grey,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (isDated) {
                      _startDate(context);
                    }
                  },
                  child: Text(
                      "From ${startDate == null ? "..." : startDate.date()}")),
              FlatButton(
                  textColor: isDated ? Colors.black : Colors.grey,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (isDated) {
                      _endDate(context);
                    }
                  },
                  child:
                      Text("To ${endDate == null ? "..." : endDate.date()}")),

            ],
          ),
          FlatButton(
              color: Theme.of(context).accentColor,
              minWidth: double.maxFinite,
              onPressed: () {
                notifier.filters = {
                  "text": text.text,
                  "user": author.text,
                  "start_date": startDate?.toString(),
                  "end_date": endDate?.toString()
                };
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Posts()));
              },
              child: Text("Search"))
        ],
      ),
    );
  }
}
