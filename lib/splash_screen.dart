import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/weather_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    Timer(Duration(milliseconds: 3500), () {
      if (!mounted) {
        return;
      }
      setState(() => loading = false);
      // dispose();
    });
    _navigateToCryptoApp();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    //  _videoPlayerController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToCryptoApp() async {
    await Future.delayed(Duration(seconds: 3)); // Wait for 3 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WeatherScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? Lottie.network(
                'https://assets2.lottiefiles.com/packages/lf20_w2IcZbA7Zq.json',
                controller: _controller,
                width: 300,
                height: 300,
                onLoaded: (composition) {
                  // Configure the AnimationController with the duration of the
                  // Lottie file and start the animation.
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              )
            : Container(),
      ),
    );
  }
}
