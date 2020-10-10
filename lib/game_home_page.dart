import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_game/game/game_shapes/game_shapes.dart';
import 'package:video_game/game/my_gride.dart';

class GameHomePage extends StatefulWidget {
  @override
  _GameHomePageState createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  Random random = Random();
  List<int> allpieces = [];
  List<int> shapes = [];

  Color pieceColor = Colors.red;
  int hittingFlore = 150;
  int count = 0;
  bool gameStart = false;
  String gamemode = "progress";
  int rotationCount = 0;
  int score = 0;
  bool lShape = false;
  bool tShape = false;
  bool zShape = false;
  bool lineShape = false;

  void startGame() {
    gameStart = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      if (gameover()) {
        setState(() {
          gamemode = "game over";
          showdialog();
        });
        timer.cancel();
      }

      for (int i = 0; i < shapes.length; i++) {
        shapes[i] += 10;
      }
      setState(() {});

      checkLineComplete();

      if (hitFlor()) {
        pickRandomPieces();
        rotationCount = 0;

        intializeShape();
      }
    });
  }

  bool gameover() {
    allpieces.sort();
    List<int> tempshapes = [];
    tempshapes.addAll(shapes);
    tempshapes.sort();

    for (int i = 0; i < 10; i++) {
      if (tempshapes.contains(i)) {
        if (allpieces.contains(tempshapes.last)) {
          return true;
        }
      }
    }
    return false;
  }

  bool hitFlor() {
    List<int> tempshapes = [];
    tempshapes.addAll(shapes);
    tempshapes.sort();
    if (tempshapes.last + 10 >= hittingFlore) {
      saveprevicePiecess();

      return true;
    } else {
      for (int i = 0; i < tempshapes.length; i++) {
        if (allpieces.contains(tempshapes[i] + 10)) {
          saveprevicePiecess();

          return true;
        }
      }
    }
    return false;
  }

  void saveprevicePiecess() {
    for (int i = 0; i < shapes.length; i++) {
      setState(() {
        allpieces.add(shapes[i]);
      });
    }
    shapes.clear();
  }

  void pickRandomPieces() {
    setState(() {
      var temp = pieceShapes[random.nextInt(5)];

      shapes.addAll(temp);
      pieceColor = pieceColors[random.nextInt(5)];
    });
  }

  bool edgetouchingcheck(bool isleft) {
    bool tempCheek = false;
    if (isleft) {
      for (int i = 0; i < shapes.length; i++) {
        if (allpieces.contains(shapes[i] - 1)) {
          tempCheek = true;
        }
      }
      return tempCheek;
    } else {
      for (int i = 0; i < shapes.length; i++) {
        if (allpieces.contains(shapes[i] + 1)) {
          tempCheek = true;
        }
      }
      return tempCheek;
    }
  }

  void moveleft() {
    for (int i = 0; i < shapes.length; i++) {
      if (shapes[i] % 10 == 0 || edgetouchingcheck(true)) {
        break;
      } else {
        setState(() {
          shapes[i] = shapes[i] - 1;
        });
      }
    }
  }

  void moveRight() {
    var temp = shapes;
    temp.sort();
    for (int i = 0; i < temp.length; i++) {
      if (temp.last.toString().endsWith("9") || edgetouchingcheck(false)) {
        break;
      } else {
        setState(() {
          shapes[i] = shapes[i] + 1;
        });
      }
    }
  }

  bool checkingRemmingsquares(int startingSquare) {
    if (allpieces.contains(startingSquare + 1)) {
      if (allpieces.contains(startingSquare + 2)) {
        if (allpieces.contains(startingSquare + 3)) {
          if (allpieces.contains(startingSquare + 4)) {
            if (allpieces.contains(startingSquare + 5)) {
              if (allpieces.contains(startingSquare + 6)) {
                if (allpieces.contains(startingSquare + 7)) {
                  if (allpieces.contains(startingSquare + 8)) {
                    return true;
                  }
                }
              }
            }
          }
        }
      }
    }
    return false;
  }

  void checkLineComplete() {
    allpieces.sort();

    for (int i = 0; i < allpieces.length; i++) {
      if (allpieces[i] % 10 == 0) {
        if (allpieces.contains(allpieces[i] + 9)) {
          if (checkingRemmingsquares(allpieces[i])) {
            removelinepiece(allpieces[i]);
          }
        }
      }
    }
  }

  void pullthepiecess(int pieces) {
    for (int i = 0; i < allpieces.length; i++) {
      if (pieces > allpieces[i]) {
        allpieces[i] += 10;
      }
    }
    score += 5;
  }

  void removelinepiece(int pieces) {
    for (int k = 0; k < 10; k++) {
      allpieces.remove(pieces + k);
    }

    pullthepiecess(pieces);
  }

  bool checks;

  bool isSquare() {
    return shapes[0] + 10 == shapes[2] && shapes[1] + 10 == shapes[3];
  }

  bool isLine() {
    return shapes[0] + 10 == shapes[1] &&
        shapes[1] + 10 == shapes[2] &&
        shapes[2] + 10 == shapes[3];
  }

  bool isZ() {
    return shapes[1] == shapes[0] + 10 && shapes[3] == shapes[2] + 10;
  }

  bool isL() {
    return shapes[0] + 10 == shapes[1] && shapes[2] + 1 == shapes[3];
  }

  bool isT() {
    return shapes[0] == shapes[1] - 1 &&
        shapes[1] == shapes[2] - 1 &&
        shapes[3] == shapes[1] + 10;
  }

  void rotateLine() {
    if (rotationCount == 0) {
      shapes[0] = shapes[0] - 1;
      shapes[1] = shapes[0] + 1;
      shapes[2] = shapes[0] + 2;
      shapes[3] = shapes[0] + 3;
      rotationCount = 1;
    } else {
      shapes[0] = shapes[0] + 1;
      shapes[1] = shapes[0] + 10;
      shapes[2] = shapes[1] + 10;
      shapes[3] = shapes[2] + 10;
      rotationCount = 0;
    }
  }

  void rotateL() {
    if (rotationCount == 0) {
      int temp = shapes[2];
      shapes[3] = temp - 1;

      rotationCount = 1;
    } else if (rotationCount == 1) {
      int temp = shapes[0];

      shapes[3] = temp - 1;

      rotationCount = 2;
    } else if (rotationCount == 2) {
      int temp = shapes[0];
      shapes[3] = temp + 1;
      rotationCount = 3;
    } else if (rotationCount == 3) {
      int temp = shapes[2];
      shapes[3] = temp + 1;
      rotationCount = 0;
    }
  }

  void rotateZ() {
    if (rotationCount == 0) {
      shapes[0] = shapes[0] + 1;
      shapes[3] = shapes[0] + 1;
      rotationCount = 1;
    } else if (rotationCount == 1) {
      shapes[0] = shapes[0] - 1;
      shapes[3] = shapes[2] + 10;
      rotationCount = 0;
    }
  }

  void rotateT() {
    if (rotationCount == 0) {
      shapes[0] = shapes[0] + 10;
      shapes[1] = shapes[1] + 10;
      shapes[2] = shapes[2] + 10;
      shapes[3] = shapes[3] - 10;
      print("1st");
      rotationCount = 1;
    } else if (rotationCount == 1) {
      shapes[0] = shapes[1] + 10;
      print("2st");
      rotationCount = 2;
    } else if (rotationCount == 2) {
      shapes[2] = shapes[1] - 1;
      print("3st");
      rotationCount = 3;
    } else if (rotationCount == 3) {
      shapes[0] = shapes[2] - 10;
      shapes[1] = shapes[0] + 1;
      shapes[2] = shapes[1] + 1;
      shapes[3] = shapes[3] + 10;
      rotationCount = 0;
      print("4st");
    }
  }

  void intializeShape() {
    if (isLine()) {
      lineShape = true;
      lShape = false;
      tShape = false;
      zShape = false;
    } else if (isL()) {
      lShape = true;

      tShape = false;
      zShape = false;
      lineShape = false;
    } else if (isZ()) {
      zShape = true;
      lShape = false;
      tShape = false;

      lineShape = false;
    } else if (isT()) {
      tShape = true;
      lShape = false;

      zShape = false;
      lineShape = false;
    }
  }

  void rotatepiecess() {
    if (tShape) {
      rotateT();
    } else if (lineShape) {
      rotateLine();
    } else if (zShape) {
      rotateZ();
    } else if (lShape) {
      rotateL();
    } else {
      intializeShape();
    }
  }

  void restart() {
    allpieces.clear();
    shapes.clear();
    pickRandomPieces();
    startGame();
    score = 0;
  }

  showdialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "GAME OVER",
                textAlign: TextAlign.center,
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              content: Text(
                "your score is " + score.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      restart();
                    },
                    child: Text("Restart")),
                FlatButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: Text("exit app")),
              ],
            ));
  }

  @override
  void initState() {
    pickRandomPieces();
    intializeShape();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: Column(
          children: [
            Expanded(
                flex: 6,
                child: Container(
                  color: Colors.black,
                  child: MyGride(
                    pieceColor: pieceColor,
                    previoeShapes: allpieces,
                    shaps: shapes,
                  ),
                )),
            Expanded(
                child: Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                      onPressed: !gameStart ? startGame : null,
                      child: Text(
                        !gameStart ? "PLAY" : score.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            letterSpacing: 3),
                      )),
                  IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: moveleft),
                  IconButton(
                      icon: Icon(Icons.rotate_90_degrees_ccw_rounded,
                          color: Colors.white),
                      onPressed: rotatepiecess),
                  IconButton(
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: moveRight),
                ],
              ),
            ))
          ],
        )),
      ),
    );
  }
}
