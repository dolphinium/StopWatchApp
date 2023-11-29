import 'dart:async';
import 'package:flutter/material.dart';

class StopWatch extends StatefulWidget{
  @override
  State createState() => StopWatchState();
}


class StopWatchState extends State<StopWatch>{
  late int seconds;
  late Timer timer;

  @override
  void initState(){
    super.initState();

    seconds = 0;
    timer = Timer.periodic(Duration(seconds: 1), _onTick);
  }
  void _onTick(Timer time){
    setState(() {
      ++seconds;
    });
  }

  String _secondsText() => seconds == 1 ? 'second':"seconds";

  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Stopwatch"),
      ),
      body: Center(
        child: Text(
          '$seconds ${_secondsText()}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}