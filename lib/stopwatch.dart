import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class StopWatch extends StatefulWidget {
  @override
  State createState() => StopWatchState();
}

class PlatformAlert {
  final String title;
  final String message;

  const PlatformAlert(
      {required this.title,
      required this.message});

  void show(BuildContext context) {
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS) {
      _buildCupertinoAlert(context);
    } else {
      _buildMaterialAlert(context);
    }
  }

  void _buildCupertinoAlert(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoButton(
                  child: Text("Close"),
                  onPressed: () => Navigator.of(context).pop())
            ],
          );
        });
  }

  void _buildMaterialAlert(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  child: Text("Close"),
                  onPressed: () => Navigator.of(context).pop())
            ],
          );
        });
  }
}

class StopWatchState extends State<StopWatch> {
  late int milliseconds;
  late Timer timer;
  final laps = <int>[];
  bool isTicking = true;

  void _lap() {
    setState(() {
      laps.add(milliseconds);
      milliseconds = 0;
    });
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 100), _onTick);
    setState(() {
      milliseconds = 0;
      isTicking = true;
      laps.clear();
    });
  }

  void _stopTimer() {
    timer.cancel();
    setState(() {
      isTicking = false;
    });
    final totalRuntime = laps.fold(milliseconds, (total, lap) => total + lap);
    final alert = PlatformAlert(title: "Run completed!",
        message:"Total Run Time is: ${_secondsText(totalRuntime)}");
    alert.show(context);
  }


  @override
  void initState() {
    super.initState();
    AppLifecycleListener(
        onPause: () => debugPrint("app is paused at ${DateTime.now()}"),
        onResume: () =>
            debugPrint("app is resuming to process from ${DateTime.now()}"));
    milliseconds = 0;
    timer = Timer.periodic(Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer time) {
    setState(() {
      milliseconds += 100;
    });
  }

  String _secondsText(int milliseconds) {
    final seconds = milliseconds / 1000;
    return '$seconds seconds';
  }

  Widget _buildLapDisplay() {
    return ListView(
      children: [
        for (int milliseconds in laps)
          ListTile(
            title: Text(_secondsText(milliseconds)),
          )
      ],
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Stopwatch"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildCounter(context)),
            Expanded(child: _buildLapDisplay())
          ],
        ));
  }

  Widget _buildCounter(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Lap ${laps.length + 1}",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white),
            ),
            Text(
              _secondsText(milliseconds),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text("Start"),
                  onPressed: isTicking ? null : _startTimer,
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.yellow)),
                  child: Text("Lap"),
                  onPressed: isTicking ? _lap : null,
                ),
                const SizedBox(width: 20),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: isTicking ? _stopTimer : null,
                  child: const Text("Stop"),
                )
              ],
            )
          ],
        ));
  }
}
