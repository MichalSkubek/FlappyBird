import 'dart:async';
import 'dart:math';

import 'package:flappy_bird/barrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Bird height
  static double birdYPos = 0.0;
  // Barriers X
  static double barrierX1 = 1.5;
  double barrierX2 = barrierX1 + 1.5;
  // Barriers height
  double barrierTop1 = 200.0;
  double barrierBottom1 = 150.0;
  double barrierTop2 = 290.0;
  double barrierBottom2 = 110.0;

  double time = 0;
  double height = 0;
  double initialHeight = birdYPos;
  bool gameStarted = false;
  bool crashed = false;

  //Screen size
  double screenWidth;
  double screenHeight;

  String message = 'T A P   T O   P L A Y';

  // Score, bestScore
  int score = 0;
  int bestScore = 0;
  int currentBarrier = 1;

  //  Random numbers
  Random random = Random();

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYPos;
    });
  }

  void startGame() {
    // if bird crashed - reset bird position, score, update bestScore
    if (crashed) {
      crashed = false;
      if (score > bestScore) {
        bestScore = score;
      }
      // Reset parameters
      setState(() {
        message = 'T A P   T O   P L A Y';
        birdYPos = 0.0;
        barrierX1 = 1.5;
        barrierX2 = barrierX1 + 1.5;
        // Barriers height
        barrierTop1 = 200.0;
        barrierBottom1 = 150.0;
        barrierTop2 = 290.0;
        barrierBottom2 = 110.0;

        time = 0;
        height = 0;
        initialHeight = birdYPos;

        score = 0;
        currentBarrier = 1;
      });
    }
    else {
      gameStarted = true;
      message = ' ';
      screenWidth = MediaQuery
          .of(context)
          .size
          .width;
      screenHeight = MediaQuery
          .of(context)
          .size
          .height * 0.75;
      Timer.periodic(Duration(milliseconds: 60), (timer) {
        time += 0.04;
        height = -4.9 * time * time + 2.8 * time;
        setState(() {
          birdYPos = initialHeight - height;
        });

        // New barriers
        setState(() {
          if (barrierX1 < -1.6) {
            barrierX1 = 1.6 + random.nextDouble()/5;
            // Generate top barrier
            barrierTop1 = (0.3 + random.nextDouble()/2) * screenHeight;
            // Calculate height of bottom barrier
            barrierBottom1 = screenHeight - barrierTop1 - random.nextInt(50) - 120.0;
            if(barrierBottom1 < 50.0){
              barrierTop1 -= 50.0;
              barrierBottom1 += 50.0;
            }
          } else {
            barrierX1 -= 0.05;
          }
        });
        setState(() {
          if (barrierX2 < -1.6) {
            barrierX2 = 1.6  + random.nextDouble()/5;
            // Generate bottom barrier
            barrierBottom2 = (0.3 + random.nextDouble()/2) * screenHeight;
            // Calculate height of bottom barrier
            barrierTop2 = screenHeight - barrierBottom2 - random.nextInt(50) - 120.0;
            if(barrierTop2 < 50.0){
              barrierTop2 += 50.0;
              barrierBottom2 -= 50.0;
            }
          } else {
            barrierX2 -= 0.05;
          }
        });


        // collision detection
        if (birdYPos > 1) { // Bird hit ground
          timer.cancel();
          gameStarted = false;
          crashed = true;
        }
        // Check if any barrier is in range
        // birdWidth + barrierWidth
        else if (barrierX1.abs() < (60.0 + 100.0) / screenWidth) {
          // Check y level
          // Up barrier
          if (-1.05 + 2 * barrierTop1 / screenHeight > birdYPos) {
            timer.cancel();
            gameStarted = false;
            crashed = true;
          }
          else if (1.05 - 2 * barrierBottom1 / screenHeight < birdYPos) {
            timer.cancel();
            gameStarted = false;
            crashed = true;
          }
          else { // Add point to current score
            if (currentBarrier == 1) {
              score += 1;
              currentBarrier = 2;
            }
          }
        }
        else if (barrierX2.abs() < (60.0 + 100.0) / screenWidth) {
          // Check y level
          // Up barrier
          if (-1.05 + 2 * barrierTop2 / screenHeight > birdYPos) {
            timer.cancel();
            gameStarted = false;
            crashed = true;
          }
          else if (1.05 - 2 * barrierBottom2 / screenHeight < birdYPos) {
            timer.cancel();
            gameStarted = false;
            crashed = true;
          }
          else { // Add point to current score
            if (currentBarrier == 2) {
              score += 1;
              currentBarrier = 1;
            }
          }
        }
        if(crashed){
          setState(() {
            message = 'T A P   T O   R E S T A R T';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Stack(children: [
                  AnimatedContainer(
                    alignment: Alignment(0.0, birdYPos),
                    color: Colors.blue,
                    duration: Duration(milliseconds: 0),
                    child: MyBird(),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierX1, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: barrierBottom1,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierX1, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: barrierTop1,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierX2, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: barrierBottom2,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierX2, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: barrierTop2,
                    ),
                  ),
                  Container(
                    alignment: Alignment(0, -0.3),
                    /*child: gameStarted
                        ? Text("")
                        : Text(
                      "T A P   T O   P L A Y",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),*/
                    child: Text(
                      message,
                      style: TextStyle(fontSize:  25, color: Colors.white),
                    ),
                  ),
                ])),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("SCORE",
                            style: TextStyle(color: Colors.white, fontSize: 20)),
                        SizedBox(
                          height: 20,
                        ),
                        Text(score.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 35)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("BEST",
                            style: TextStyle(color: Colors.white, fontSize: 20)),
                        SizedBox(
                          height: 20,
                        ),
                        Text(bestScore.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 35)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
