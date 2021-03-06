import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/new/SelectChecklistType.dart';
import 'package:CleanHabits/widgets/new/SelectFromDate.dart';
import 'package:CleanHabits/widgets/new/SelectReminder.dart';
import 'package:CleanHabits/widgets/new/SelectRepeat.dart';
import 'package:CleanHabits/widgets/new/SelectTimeOfDay.dart';
import 'package:flutter/material.dart';

class EditHabit extends StatefulWidget {
  final HabitMasterService habitMaster = new HabitMasterService();
  //
  @override
  _EditHabitState createState() => _EditHabitState();
}

class _EditHabitState extends State<EditHabit> {
  String title;
  Repeats repeat;
  DateTime fromDate;
  ChecklistType type;
  List<TimeOfDay> reminder;
  String timeOfDay;
  bool loading;

  Habit srcHabit;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //
    title = null;
    repeat = Repeats();
    fromDate = DateTime.now();
    type = ChecklistType(
      isSimple: true,
      times: 1,
      timesType: null,
    );
    reminder = null;
    timeOfDay = "All Day";
    loading = true;
  }

  void _saveHabit() {
    setState(() {
      loading = true;
    });
    //
    widget.habitMaster
        .update(
          id: srcHabit.id,
          title: title,
          repeat: repeat,
          fromDate: fromDate,
          type: type,
          reminder: reminder,
          timeOfDay: timeOfDay,
        )
        .then((sts) => {
              setState(() {
                loading = false;
              }),
              Navigator.pushNamed(context, '/'),
            });
  }

  AppBar _getAppBar(context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Edit Habit',
        style: TextStyle(
          color: Theme.of(context).textTheme.headline6.color,
        ),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => this.title == null
              ? _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("please enter a title for the Habbit"),
                ))
              : _saveHabit(),
          child: Text(
            'Save',
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
      ],
      bottom: PreferredSize(
        child: Container(color: Colors.grey.withOpacity(0.5), height: 1.0),
        preferredSize: Size.fromHeight(4.0),
      ),
    );
  }

  Widget _nameTile(context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.5)),
          bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
        ),
      ),
      margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
      padding: EdgeInsets.all(5),
      child: ListTile(
        title: TextField(
          autofocus: false,
          controller: TextEditingController(text: title),
          onChanged: (val) => title = val,
          decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(
              left: 0,
              bottom: 11,
              top: 11,
              right: 15,
            ),
            hintText: 'Name',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (srcHabit == null) {
      Habit habit = ModalRoute.of(context).settings.arguments;
      widget.habitMaster.hmp.getData(habit.id).then((hm) => {
            setState(() {
              srcHabit = habit;
              title = hm.title;
              repeat = Repeats(
                none: hm.isNone,
                isWeekly: hm.isWeekly,
                hasSun: hm.hasSun,
                hasMon: hm.hasMon,
                hasTue: hm.hasTue,
                hasWed: hm.hasWed,
                hasThu: hm.hasThu,
                hasFri: hm.hasFri,
                hasSat: hm.hasSat,
                interval: hm.repDuation,
              );
              fromDate = hm.fromDate;
              type = ChecklistType(
                isSimple: hm.isYNType,
                times: hm.timesTarget,
                timesType: hm.timesTargetType,
              );
              reminder = hm.reminder;
              timeOfDay = hm.timeOfDay;
              loading = false;
            }),
          });
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: _getAppBar(context),
      body: Container(
        color: Colors.grey.withOpacity(0.05),
        child: loading
            ? Center(
                child: Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: CircularProgressIndicator(),
              ))
            : ListView(
                children: <Widget>[
                  _nameTile(context),
                  SelectRepeat(
                    value: repeat,
                    onChange: (val) => {
                      setState(() {
                        repeat = val;
                      })
                    },
                  ),
                  SelectFromDate(
                    value: fromDate,
                    onChange: (val) => setState(() {
                      fromDate = val;
                    }),
                  ),
                  SelectChecklistType(
                    value: type,
                    onChange: (val) => setState(() {
                      type = val;
                    }),
                  ),
                  SelectReminder(
                    value: reminder,
                    onChange: (val) => setState(() {
                      reminder = val;
                    }),
                  ),
                  SelectTimeOfDay(
                    value: timeOfDay == 'All Day' ? null : timeOfDay,
                    onChange: (val) => setState(() {
                      timeOfDay = val;
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
