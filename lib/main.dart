import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// class StopwatchState {
//   Duration stopwatch;
//   String time;
//   // final Timer? timer;
//
//   StopwatchState({
//     required this.stopwatch,
//     this.time = ''
//     // this.timer
//   });
// }
//
// class StopwatchStateScope extends InheritedWidget {
//   final StopwatchState data;
//   StopwatchStateScope(this.data, {Key? key, required Widget child}) : super(key: key, child: child);
//   static StopwatchState of(BuildContext context){
//     return context.dependOnInheritedWidgetOfExactType<StopwatchStateScope>()!.data;
//   }
//
//   @override
//   bool updateShouldNotify(StopwatchStateScope old){
//     return true;
//   }
// }
//
// class StopwatchStateWidget extends StatefulWidget{
//   final Widget child;
//
//   StopwatchStateWidget({
//     required this.child
//   });
//
//   static _StopwatchStateWidget of(BuildContext context){
//     return context.findAncestorStateOfType<_StopwatchStateWidget>()!;
//   }
//
//   @override
//   _StopwatchStateWidget createState() => _StopwatchStateWidget();
// }
//
// class _StopwatchStateWidget extends State<StopwatchStateWidget>{
//   StopwatchState _data = StopwatchState(stopwatch: Duration());
//   late String time;
//
//   void initState(){
//     super.initState();
//     time = showTime;
//   }
//
//   void incrementTime(){
//     setState(() {
//       int mil = _data.stopwatch.inMilliseconds + 10;
//       _data.stopwatch = Duration(milliseconds: mil);
//       _data.time = time;
//       time = showTime;
//     });
//   }
//
//   String get showTime{
//     String sec = _data.stopwatch.inSeconds.remainder(60).toString().padLeft(2, '0');
//     String min = _data.stopwatch.inMinutes.remainder(60).toString().padLeft(2, '0');
//     String hour = _data.stopwatch.inHours.remainder(60).toString().padLeft(2, '0');
//     return '$hour:$min:$sec';
//   }
//
//
//   @override
//   Widget build(BuildContext context){
//     return StopwatchStateScope(
//       _data,
//       child: widget.child,
//     );
//   }
//
// }

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
          subtitle2: TextStyle(fontSize: 20, color: Color(0xFFA0C1B8))
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
  Duration splitTime = Duration();
  Timer? timer;
  late AnimationController _playPauseController;
  late AnimationController _rotateController;
  bool isRunning = false;

  List<int> lapCount = <int>[];
  List<String> lapTime = <String>[];
  List<String> lapSplitTime = <String>[];

  @override
  void initState(){
    super.initState();
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
      int mil1 = stopwatch.inMilliseconds + 10;
      int mil2 = splitTime.inMilliseconds + 10;
      stopwatch = Duration(milliseconds: mil1);
      splitTime = Duration(milliseconds: mil2);
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
    });
  }

  String showTime(int n){
    if(n == 1){
      String sec = stopwatch.inSeconds.remainder(60).toString().padLeft(2, '0');
      String min = stopwatch.inMinutes.remainder(60).toString().padLeft(2, '0');
      // String hour = stopwatch.inHours.remainder(60).toString().padLeft(2, '0');

      return '$min:$sec.';
    }
    else {
      String sec = splitTime.inSeconds.remainder(60).toString().padLeft(2, '0');
      String min = splitTime.inMinutes.remainder(60).toString().padLeft(2, '0');
      // String hour = stopwatch.inHours.remainder(60).toString().padLeft(2, '0');

      return '$min:$sec.';
    }
  }

  String showMil(int n){
    if(n == 1){
      String mil = stopwatch.inMilliseconds.remainder(1000).toString().padLeft(2, '0').substring(0, 2);
      return mil;
    }
    else {
      String mil = splitTime.inMilliseconds.remainder(1000).toString().padLeft(2, '0').substring(0, 2);
      return mil;
    }

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
    splitTime = Duration();
    isRunning = false;
    stopStopwatch();
    lapCount = <int>[];
    lapTime = <String>[];
    lapSplitTime = <String>[];
  }

  void addLap(){
    if(isRunning){

      lapCount.add(lapCount.length + 1);
      lapTime.add(showTime(1) + showMil(1));
      lapSplitTime.add(showTime(2) + showMil(2));

      print(lapCount.length.toString());
      print(lapTime.last);
      stopwatch = Duration();
    }
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        //Section: Stopwatch lap
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Text('Lap', style: Theme.of(context).textTheme.subtitle2),
            Text('Time', style: Theme.of(context).textTheme.subtitle2),
            Text('Split Time', style: Theme.of(context).textTheme.subtitle2)
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
              // color: Color(0xFF719FB0),
              borderRadius: BorderRadius.circular(20)
          ),
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 0),
              itemCount: lapCount.length,
              // reverse: true,
              itemBuilder: (context, index){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('${lapCount[index]}', style: Theme.of(context).textTheme.subtitle2),
                    Text('${lapTime[index]}', style: Theme.of(context).textTheme.subtitle2),
                    Text('${lapSplitTime[index]}', style: Theme.of(context).textTheme.subtitle2),
                  ],
                );
                // return Text('${lapCount[index]} ==== ${lapTime[index]}', style: Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.center,);
              }
          ),
        ),

        //Section: Stopwatch time
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(showTime(1), style: Theme.of(context).textTheme.headline1,),
            SizedBox(
              width: 70,
              child: Text(showMil(1), style: Theme.of(context).textTheme.headline1,textAlign: TextAlign.end,),
            )
          ],
        ),
        SizedBox(height: 20,),

        //Section: Stopawtch buttons
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
            SizedBox(width: 20,),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFF719FB0),
                  shape: BoxShape.circle
              ),
              child: IconButton(
                iconSize: 60,
                onPressed: addLap,
                icon: Icon(Icons.flag, color: Colors.white),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class StopwatchLap extends StatefulWidget{
  @override
  _StopwatchLap createState() => _StopwatchLap();
}

class _StopwatchLap extends State<StopwatchLap>{
  @override
  Widget build(BuildContext context){
    return Container(

    );
  }
}