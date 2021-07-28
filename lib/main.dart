import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 60, color: Color(0xFFA0C1B8)),
          subtitle1: TextStyle(color: Color(0xFFA0C1B8)),
        ),
        primarySwatch: Colors.blue,
      ),
      home: FitnessAppMainPage(),
    );
  }
}

class FitnessAppMainPage extends StatefulWidget{
  @override
  _FitnessAppState createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessAppMainPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF351F39),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StopwatchTitle(),
                StopwatchTime(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StopwatchTitle extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Text('Stopwatch', style: Theme.of(context).textTheme.headline1,),
        Text('Echofi Takehome Project', style: Theme.of(context).textTheme.subtitle1,)
      ],
    );
  }
}

class StopwatchTime extends StatefulWidget{
  @override
  _StopwatchState createState() => _StopwatchState();
}

class _StopwatchState extends State<StopwatchTime> with TickerProviderStateMixin{
  Duration stopwatch = Duration();
  Timer? timer;
  late AnimationController _playPauseController;
  late AnimationController _rotateController;
  bool isRunning = false;

  @override
  void initState(){
    super.initState();

    // startTimer();
    animateIcons();
  }

  @override
  void dispose(){
    _playPauseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  void animateIcons(){
    _playPauseController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _rotateController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
  }

  /*
  Increment time will take the current variable stopwatch duration in milliseconds and increment it by 10.
  Then we set the the current stopwatch duration with the new duration
   */
  void incrementTime(){
    setState(() {
      int mil = stopwatch.inMilliseconds + 10;
      stopwatch = Duration(milliseconds: mil);
    });
  }

  /*
  Start timer will start the icon button animation and then start the timer
  How it works is every 10 milliseconds duration has passed, a callback is triggered which is the incrementTime
   */
  void startStopwatch() {
    _playPauseController.forward();
    timer = Timer.periodic(Duration(milliseconds: 10), (_) => incrementTime());
  }

  void stopStopwatch(){
    _playPauseController.reverse();
    setState(() {
      timer?.cancel();
    });
  }

  void _isRunning(){
    setState(() {
      isRunning = !isRunning;
      isRunning ? startStopwatch() : stopStopwatch();
      // isRunning ? _playPauseController.forward() : _playPauseController.reverse();
    });
  }

  String showTime(){
    // String mil = stopwatch.inMilliseconds.remainder(1000).toString().padLeft(2, '0').substring(0, 2);
    String sec = stopwatch.inSeconds.remainder(60).toString().padLeft(2, '0');
    String min = stopwatch.inMinutes.remainder(60).toString().padLeft(2, '0');
    String hour = stopwatch.inHours.remainder(60).toString().padLeft(2, '0');

    return '$hour:$min:$sec.';
  }

  String showMil(){
    String mil = stopwatch.inMilliseconds.remainder(1000).toString().padLeft(2, '0').substring(0, 2);
    return mil;
  }

  void _rotateIcon(){
    if (_rotateController.isCompleted){
      _rotateController.reset();
      _rotateController.forward();
    }
    else {
      _rotateController.forward();
    }

    stopwatch = Duration();
    isRunning = false;
    stopStopwatch();
    // _rotateController.repeat();
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(showTime(), style: Theme.of(context).textTheme.headline1,),
            SizedBox(
              width: 70,
              child: Text(showMil(), style: Theme.of(context).textTheme.headline1,textAlign: TextAlign.end,),
            )
          ],
        ),
        // Text(showTime(), style: Theme.of(context).textTheme.headline1,),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: !isRunning ? BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle
              ) : BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle
              ),
              child: IconButton(
                  iconSize: 60,
                  onPressed: _isRunning,
                  color: Colors.white,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _playPauseController,
                  )
              ),
            ),
            SizedBox(width: 20,),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFF719FB0),
                  shape: BoxShape.circle
              ),
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_rotateController),
                child: IconButton(
                    iconSize: 60,
                    onPressed: _rotateIcon,
                    icon: Icon(Icons.refresh, color: Colors.white,),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}