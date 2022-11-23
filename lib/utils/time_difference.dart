
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quote/quote_viewmodel.dart';

class ClockTimeElapsed extends StatefulWidget {
  ClockTimeElapsed({Key? key, required this.dateTime, this.textStyle}) : super(key: key);
  DateTime dateTime;
  TextStyle? textStyle;

  @override
  _ClockTimeElapsedState createState() => _ClockTimeElapsedState();
}
class _ClockTimeElapsedState extends State<ClockTimeElapsed> {
  Duration difference = const Duration();

  @override
  void initState() {
    super.initState();
  }

  void calculateDifference(){
    difference = widget.dateTime.difference(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Text(difference.toString());
  }
}