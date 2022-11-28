
import 'dart:async';

import 'package:flutter/cupertino.dart';

class ClockTimeElapsed extends StatefulWidget {
  ClockTimeElapsed({Key? key, required this.dateTime, this.textStyle}) : super(key: key);
  DateTime dateTime;
  TextStyle? textStyle;

  @override
  _ClockTimeElapsedState createState() => _ClockTimeElapsedState();
}
class _ClockTimeElapsedState extends State<ClockTimeElapsed> {
  Duration difference = const Duration();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        calculateDifference();
      });
    });
  }

  calculateDifference() async {
    difference = widget.dateTime.difference(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Text(difference.toString(), style: widget.textStyle,);
  }
}