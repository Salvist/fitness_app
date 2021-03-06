import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          subtitle2: TextStyle(fontSize: 20, color: Color(0xFFA0C1B8))
        ),
        primarySwatch: Colors.blue,
      ),
      home: FitnessAppMainPage(),
    );
  }
}

class FitnessAppMainPage extends StatelessWidget{
//   @override
//   _FitnessAppState createState() => _FitnessAppState();
// }
//
// class _FitnessAppState extends State<FitnessAppMainPage>{
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
  bool loadSW = false;

  List<String> lapTime = <String>[];
  List<String> lapSplitTime = <String>[];

  @override
  void initState(){
    super.initState();
    animateIcons();
    loadStopwatch();
  }

  void loadStopwatch() async {
    final prefs = await SharedPreferences.getInstance();
    setState((){
      isRunning = (prefs.getBool('isRunning') ?? false);
      lapTime = (prefs.getStringList('lapTime') ?? <String>[]);
      lapSplitTime = (prefs.getStringList('lapSplitTime') ?? <String>[]);
      loadSW = (prefs.getBool('loadSW') ?? false);
    });

    if(loadSW){

      if(isRunning){
        //set stopwatch time first before calling startStopwatch()
        //bl stands for before leave, meaning before the app was closed.
        //al stands for after leave, meaning the app is opened again after closed.
        String blTime = (prefs.getString('blTime') ?? 'null');
        DateFormat df = DateFormat('HH:mm:ss');

        DateTime alTimeDT = df.parse(getCurrentTime());
        Duration alDur = Duration(hours: alTimeDT.hour, minutes: alTimeDT.minute, seconds: alTimeDT.second);

        DateTime blTimeDT = df.parse(blTime);
        Duration blDur = Duration(hours: blTimeDT.hour, minutes: blTimeDT.minute, seconds: blTimeDT.second);

        String startLapTime = (prefs.getString('startLapTime') ?? 'null');
        String lastLapMilliseconds = (prefs.getString('lastLapMilliseconds') ?? '000');
        DateFormat df2 = DateFormat('H:mm:ss');
        DateTime startLapDT =  df2.parse(startLapTime);

        Duration leftover = Duration(hours: startLapDT.hour, minutes: startLapDT.minute, seconds: startLapDT.second, milliseconds: int.parse(lastLapMilliseconds));

        //Using the time when the app is closed and the time when it is reopened,
        //the different is the offline time (or how long the app was closed) and then added with the leftover time.
        //leftover time is when the stopwatch was started until the app is closed.
        stopwatch = alDur - blDur + leftover;

        //setting up splitTime duration
        //If the lapSplitTime list is not empty, it will take the last split time and convert it Duration object.
        if(lapSplitTime.isNotEmpty){
          DateFormat df3 = DateFormat('mm:ss');
          DateTime lastSplitDT = df3.parse(lapSplitTime.last);
          String lastSplitMilliseconds = (prefs.getString('lastSplitMilliseconds') ?? '000');
          Duration tempSplitDur = Duration(minutes: lastSplitDT.minute, seconds: lastSplitDT.second, milliseconds: int.parse(lastSplitMilliseconds));
          splitTime = tempSplitDur;
        }

        startStopwatch();
      }
      else {
        String lastLapTime = (prefs.getString('lastLapTime') ?? 'null');
        String lastLapMilliseconds = (prefs.getString('lastLapMilliseconds') ?? '000');

        String lastSplitTime = (prefs.getString('lastSplitTime') ?? 'null');
        String lastSplitMilliseconds = (prefs.getString('lastSplitMilliseconds') ?? '000');

        DateFormat df = DateFormat('H:mm:ss');

        DateTime lastLapDT = df.parse(lastLapTime);
        stopwatch = Duration(hours: lastLapDT.hour, minutes: lastLapDT.minute, seconds: lastLapDT.second, milliseconds: int.parse(lastLapMilliseconds));

        DateTime lastSplitDT = df.parse(lastSplitTime);
        splitTime = Duration(hours: lastSplitDT.hour, minutes: lastSplitDT.minute, seconds: lastSplitDT.second, milliseconds: int.parse(lastSplitMilliseconds));
      }
    }
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
  void startStopwatch() async {
    _playPauseController.forward();

    final prefs = await SharedPreferences.getInstance();

    if((prefs.getString('startLapTime') ?? '') == '') prefs.setString('startLapTime', stopwatch.toString());
    if((prefs.getString('startSplitTime') ?? '') == '') prefs.setString('startSplitTime', splitTime.toString());
    loadSW = true;
    prefs.setBool('loadSW', loadSW);

    timer = Timer.periodic(Duration(milliseconds: 10), (_) => incrementTime());
  }

  void stopStopwatch() async {
    _playPauseController.reverse();
    setState(() {
      timer?.cancel();
    });

    if(loadSW){
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('lastLapTime', stopwatch.toString());
      prefs.setString('lastSplitTime', splitTime.toString());
      prefs.setString('lastLapMilliseconds', stopwatch.inMilliseconds.remainder(1000).toString());
      prefs.setString('lastSplitMilliseconds', splitTime.inMilliseconds.remainder(1000).toString());
    }
  }

  void _isRunning() async {
    setState(() {
      isRunning = !isRunning;
      isRunning ? startStopwatch() : stopStopwatch();
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isRunning', isRunning);
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
      String mil = stopwatch.inMilliseconds.remainder(1000).toString().padLeft(3, '0').substring(0, 2);
      return mil;
    }
    else {
      String mil = splitTime.inMilliseconds.remainder(1000).toString().padLeft(3, '0').substring(0, 2);
      return mil;
    }
  }

  void _rotateIcon() async {
    if (_rotateController.isCompleted){
      _rotateController.reset();
      _rotateController.forward();
    }
    else {
      _rotateController.forward();
    }

    final prefs = await SharedPreferences.getInstance();

    prefs.remove('loadSW');

    //Lap Time
    prefs.remove('startLapTime');
    prefs.remove('lastLapTime');
    prefs.remove('lastLapMilliseconds');
    prefs.remove('lapTime'); //this is a List<String>

    //Split Time
    prefs.remove('startSplitTime');
    prefs.remove('lastSplitTime');
    prefs.remove('lapSplitTime'); // this is a List<String>
    prefs.remove('lastSplitMilliseconds');


    prefs.remove('blTime');
    prefs.remove('alTime');

    stopwatch = Duration();
    splitTime = Duration();
    isRunning = false;
    loadSW = false;
    stopStopwatch();
    lapTime = <String>[];
    lapSplitTime = <String>[];
  }

  void addLap() async {
    if(isRunning){
      lapTime.add(showTime(1) + showMil(1));

      splitTime += stopwatch;
      lapSplitTime.add(showTime(2) + showMil(2));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('lapTime', lapTime);
      await prefs.setStringList('lapSplitTime', lapSplitTime);

      stopwatch = Duration();
    }
  }

  String getCurrentTime(){
    DateTime now = DateTime.now();
    String time = DateFormat('HH:mm:ss').format(now);
    return time;
  }

  Future<bool> saveStopwatchState() async {
    print('saving stopwatch state');

    final prefs = await SharedPreferences.getInstance();
    if(isRunning){
      //bl stands for before leave, meaning before the app is closed.
      prefs.setString('blTime', getCurrentTime());
      prefs.setString('startLapTime', stopwatch.toString());
      prefs.setString('lastSplitMilliseconds', splitTime.inMilliseconds.remainder(1000).toString());
      print(stopwatch.toString());
    }

    return true;
  }



  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: saveStopwatchState,
      child: Column(
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
                itemCount: lapTime.length,
                // reverse: true,
                itemBuilder: (context, index){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('${index + 1}', style: Theme.of(context).textTheme.subtitle2),
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
      ),
    );
  }
}