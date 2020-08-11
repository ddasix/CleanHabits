import 'package:CleanHabits/widgets/basic/BaseSelectionTile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectFromDate extends StatelessWidget {
  final DateTime value;
  final ValueChanged<DateTime> onChange;
  SelectFromDate({this.value, this.onChange});

  void _showDialog(context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 365),
      ),
    ).then(this.onChange);
  }

  @override
  Widget build(BuildContext context) {
    return BaseSelectionTile(
      value: value == null ? null : DateFormat('dd-MMM, EEE').format(value),
      icon: Icon(Icons.calendar_today),
      title: 'From',
      emptyText: 'From Today',
      onTap: () => _showDialog(context),
      onClear: () => this.onChange(null),
    );
  }
}