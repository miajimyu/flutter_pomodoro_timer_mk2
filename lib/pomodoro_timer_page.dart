import 'dart:async';

import 'package:flutter/material.dart';

import 'widgets/button.dart';
import 'widgets/indicator.dart';

const Duration workTime = Duration(minutes: 25);
const Duration shortBreakTime = Duration(minutes: 5);
const Duration longBreakTime = Duration(minutes: 15);

const int longBreakAfter = 3;
const int targetInterval = 6;

enum Status {
  work,
  shortBreak,
  longBreak,
}

class Pomodoro {
  Pomodoro({
    this.time,
    this.status,
    this.count,
  });

  Duration time;
  Status status;
  int count;

  void setParam({Duration time, Status status}) {
    this.time = time;
    this.status = status;
  }
}

class PomodoroTimerPage extends StatefulWidget {
  @override
  _PomodoroTimerPageState createState() => _PomodoroTimerPageState();
}

class _PomodoroTimerPageState extends State<PomodoroTimerPage> {
  Stopwatch _sw;
  Timer _timer;
  Duration _timeLeft = const Duration();

  final Pomodoro _pomodoro = Pomodoro(
    time: workTime,
    status: Status.work,
    count: 0,
  );

  @override
  void initState() {
    _pomodoro.time = workTime;
    _sw = Stopwatch();
    _timer = Timer.periodic(const Duration(milliseconds: 50), _callback);
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void _callback(Timer timer) {
    if (_sw.elapsed > _pomodoro.time) {
      setState(() {
        _changeNextStatus();
      });
      return;
    }

    final Duration _newTimeLeft = _pomodoro.time - _sw.elapsed;
    if (_newTimeLeft.inSeconds != _timeLeft.inSeconds) {
      setState(() {
        _timeLeft = _newTimeLeft;
      });
    }
  }

  void _changeNextStatus() {
    _sw.stop();
    _sw.reset();
    if (_pomodoro.status == Status.work) {
      _pomodoro.count++;
      if (_pomodoro.count % longBreakAfter == 0) {
        _pomodoro.setParam(time: longBreakTime, status: Status.longBreak);
      } else {
        _pomodoro.setParam(time: shortBreakTime, status: Status.shortBreak);
      }
    } else {
      _pomodoro.setParam(time: workTime, status: Status.work);
    }
  }

  void _workButtonPressed() {
    _sw.stop();
    _sw.reset();
    _pomodoro.setParam(time: workTime, status: Status.work);
  }

  void _breakButtonPressed() {
    _sw.stop();
    _sw.reset();
    if (_pomodoro.count != 0 && _pomodoro.count % longBreakAfter == 0) {
      _pomodoro.setParam(time: longBreakTime, status: Status.longBreak);
    } else {
      _pomodoro.setParam(time: shortBreakTime, status: Status.shortBreak);
    }
  }

  void _buttonPressed() {
    setState(() {
      if (_sw.isRunning) {
        _sw.stop();
      } else {
        _sw.start();
      }
    });
  }

  Widget displayTimeString() {
    final String minutes =
        (_timeLeft.inMinutes % 60).toString().padLeft(2, '0');
    final String seconds =
        (_timeLeft.inSeconds % 60).toString().padLeft(2, '0');
    return Text('$minutes:$seconds', style: const TextStyle(fontSize: 40.0));
  }

  Widget displayPomodoroStatus() {
    return Text(
      _pomodoro.status.toString().split('.')[1].toUpperCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                labelText: 'Task',
              ),
            ),
            displayPomodoroStatus(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                displayTimeString(),
                Text(
                  '${_pomodoro.count.toString()}/$targetInterval',
                  style: const TextStyle(fontSize: 30.0),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Indicator(
                  percent: _timeLeft.inSeconds / _pomodoro.time.inSeconds),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TimerButton(
                  icon: Icon(
                    Icons.work,
                    color: Colors.black,
                  ),
                  function: _sw.isRunning ? null : () => _workButtonPressed(),
                  string: 'Work',
                ),
                TimerButton(
                  icon: Icon(
                    Icons.free_breakfast,
                    color: Colors.black,
                  ),
                  function: _sw.isRunning ? null : () => _breakButtonPressed(),
                  string: 'Break',
                ),
                TimerButton(
                  icon: Icon(
                    _sw.isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                  ),
                  function: () => _buttonPressed(),
                  string: _sw.isRunning ? 'Stop' : 'Start',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
