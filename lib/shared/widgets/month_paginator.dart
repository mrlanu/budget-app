import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPaginator extends StatefulWidget {
  final Color? color;
  final double? fontSize;
  final Function? onLeft;
  final Function? onRight;

  const MonthPaginator(
      {Key? key,
      this.color,
      this.fontSize,
      required this.onLeft,
      required this.onRight})
      : super(key: key);

  @override
  State<MonthPaginator> createState() => _MonthPaginatorState();
}

class _MonthPaginatorState extends State<MonthPaginator> {
  late DateTime _myDate;

  @override
  void initState() {
    super.initState();
    _myDate = DateTime.now().copyWith(day: 15);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined, color: widget.color),
          onPressed: () {
            setState(() {
              _myDate = _myDate.subtract(Duration(days: 30));
            });
            widget.onLeft!(_myDate);
          },
        ),
        Column(
          children: [
            Text(DateFormat('MMM').format(_myDate),
                style:
                    TextStyle(color: widget.color, fontSize: widget.fontSize)),
            Text(
              DateFormat('yyyy').format(_myDate),
              style: TextStyle(
                  fontSize:
                      widget.fontSize == null ? 12 : widget.fontSize! * 0.7,
                  color: widget.color),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.arrow_circle_right_outlined, color: widget.color),
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
    );
  }
}
