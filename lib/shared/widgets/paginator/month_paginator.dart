import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MonthPaginator extends StatefulWidget {
  final Function? onLeft;
  final Function? onRight;

  const MonthPaginator({Key? key, required this.onLeft, required this.onRight})
      : super(key: key);

  @override
  State<MonthPaginator> createState() => _MonthPaginatorState();
}

class _MonthPaginatorState extends State<MonthPaginator> {
  late DateTime _myDate;

  @override
  void initState() {
    super.initState();
    _myDate = DateTime.now()..copyWith(day: 15);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_circle_left_outlined),
            onPressed: () {
              setState(() {
                _myDate = _myDate.subtract(Duration(days: 30));
              });
              widget.onLeft!(_myDate);
            },
          ),
          Column(
            children: [
              Text(DateFormat('MMM').format(_myDate)),
              Text(
                DateFormat('yyyy').format(_myDate),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.arrow_circle_right_outlined),
            onPressed: _myDate.month >= DateTime.now().month &&
                    _myDate.year == DateTime.now().year
                ? null
                : () {
                    setState(() {
                      _myDate = _myDate.add(Duration(days: 30));
                    });
                    widget.onRight!(_myDate);
                  },
          ),
        ],
      ),
    );
  }
}
