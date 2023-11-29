import 'dart:async';
import 'package:flutter/material.dart';

class StopWatch extends StatefulWidget{
  @override
  State createState() => StopWatchState();
}


class StopWatchState extends State<StopWatch>{
  late int seconds;
  late Timer timer;

  bool isTicking = true;

  void _startTimer(){
    timer = Timer.periodic(Duration(seconds: 1),_onTick);


    setState(() {
      seconds = 0;
      isTicking = true;
    });
  }

  void _stopTimer(){
    timer.cancel();
    setState(() {
      isTicking = false;
    });
  }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[
          Text("$seconds ${_secondsText()}",
          style: Theme.of(context).textTheme.headlineMedium,),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget> [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty
                      .all<Color>(Colors.green),
                  foregroundColor: MaterialStateProperty
                    .all<Color>(Colors.white),
                ),
                child: Text("Start"),
                onPressed: isTicking ? null : _startTimer,
              ),
              const SizedBox(width: 20,),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty
                      .all<Color>(Colors.red),
                  foregroundColor: MaterialStateProperty
                    .all<Color>(Colors.white),

                ),
                child: Text("Stop"),
                onPressed: isTicking ? _stopTimer : null,
              )
            ],
          )

        ] ,
      )
    );
  }
}