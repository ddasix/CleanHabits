import 'package:CleanHabits/data/domain/HabitMaster.dart';
import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllHabits extends StatefulWidget {
  @override
  _AllHabitsState createState() => _AllHabitsState();
}

class _AllHabitsState extends State<AllHabits> {
  final hmp = ProviderFactory.habitMasterProvider;
  List<HabitMaster> data = List<HabitMaster>();
  var loading = true;

  var _format = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() {
    hmp.list().then(
          (sData) => setState(() {
            data = sData;
            loading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;
    var accentColor = _theme.accentColor;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: accentColor),
        elevation: 0.0,
        title: Text(
          'All Habits',
          style: TextStyle(
            color: _darkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: _theme.scaffoldBackgroundColor,
      ),
      body: loading
          ? Container()
          : ListView.separated(
              itemCount: data.length,
              separatorBuilder: (context, index) =>
                  _darkMode ? Divider(color: accentColor) : Divider(),
              itemBuilder: (context, index) => ListTile(
                trailing: Icon(
                  Icons.chevron_right,
                  size: 40.0,
                  color: accentColor,
                ),
                title: Text(data[index].title),
                subtitle: Row(
                  children: [
                    Text(
                      data[index].isYNType
                          ? 'Simple Type'
                          : 'Target ${data[index].timesTarget} ${data[index].timesTargetType}',
                    ),
                    Spacer(),
                    Text(_format.format(data[index].fromDate))
                  ],
                ),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/habit/progress',
                  arguments: data[index].toDomain(),
                ),
              ),
            ),
    );
  }
}
