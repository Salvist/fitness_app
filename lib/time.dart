class Time{
  // int hour = 0;
  late int min;
  late int sec;
  late int mil;

  Time(String t){
    //time format: mm:ss.milsec
    //e,g, 12:34.56 --> 12 mins, 34 secs, 56 milsecs
    min = int.parse(t.substring(0, 2));
    sec = int.parse(t.substring(3, 5));
    mil = int.parse(t.substring(6, 8));
  }

  void decrease(Time t2){
    if(mil - t2.mil < 0) {
      sec--;
      mil = 100 + (mil - t2.mil);
    }
    else mil = mil - t2.mil;




  }
}