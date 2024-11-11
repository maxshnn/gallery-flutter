import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gallery/const.dart';

class ErrorList extends StatefulWidget {
  final ScrollController controller;
  final String error;
  const ErrorList({
    Key? key,
    required this.controller,
    required this.error,
  }) : super(key: key);

  @override
  State<ErrorList> createState() => _ErrorListState();
}

class _ErrorListState extends State<ErrorList> {
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 3;

  int currentSeconds = 0;

  String get timerText => ((timerMaxSeconds - currentSeconds) % 60).toString();

  startTimeout() {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds - 1) timer.cancel();
      });
    });
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svg/error.svg'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Oh shucks!', style: ThemeApp.textViewName),
              ),
              Text(
                'Slow or no internet connection.\nPlease check your internet settings',
                style: ThemeApp.textViewDescription,
                textAlign: TextAlign.center,
              ),
              Text(
                widget.error,
                style: ThemeApp.textViewDate,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'after $timerText second you will be shown \nthe photos that you viewed',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
