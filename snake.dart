import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class SnakePage extends StatefulWidget {
  const SnakePage({Key? key}) : super(key: key);

  @override
  State<SnakePage> createState() => _SnakePageState();
}

enum Direction { right, left, down, up }

class _SnakePageState extends State<SnakePage> {
  List<int> snakePosition = [45, 65, 85, 105, 125];
  int numberOfSquares = 760;
  static var randomNumber = Random();
  int food = randomNumber.nextInt(700);

  void generateNewFood() {
    food = randomNumber.nextInt(700);
  }

  void startGame() {
    snakePosition = [45, 65, 85, 105, 125];
    const snakeSpeed = Duration(milliseconds:100);

    Timer.periodic(snakeSpeed, (Timer timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        showGameOverScreen();
      }
    });
  }

  var direction = Direction.down;
  bool changingDirection = false;

  void updateSnake() {
    if (!changingDirection) {
      setState(() {
        int newHeadPosition = _getNextHeadPosition();

        if (snakePosition.contains(newHeadPosition)) {
          showGameOverScreen();
          return;
        }

        snakePosition.add(newHeadPosition);
        if (newHeadPosition == food) {
          generateNewFood();
        } else {
          snakePosition.removeAt(0);
        }
      });
    }
  }

  int _getNextHeadPosition() {
    int newHeadPosition = snakePosition.last;

    switch (direction) {
      case Direction.down:
        newHeadPosition = (newHeadPosition + 20) % numberOfSquares;
        break;
      case Direction.up:
        newHeadPosition = (newHeadPosition - 20 + numberOfSquares) % numberOfSquares;
        break;
      case Direction.left:
        if (newHeadPosition % 20 == 0) {
          newHeadPosition += 19;
        } else {
          newHeadPosition -= 1;
        }
        break;
      case Direction.right:
        if ((newHeadPosition + 1) % 20 == 0) {
          newHeadPosition -= 19;
        } else {
          newHeadPosition += 1;
        }
        break;
    }

    return newHeadPosition;
  }

  bool gameOver() {
    int newHeadPosition = snakePosition.last;
    for (int i = 0; i < snakePosition.length - 1; i++) {
      if (snakePosition[i] == newHeadPosition) {
        return true;
      }
    }
    return false;
  }

  void showGameOverScreen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.withOpacity(.9),
          title: Text("Game Over"),
          content: Text(
            "Votre score est: ${snakePosition.length}",
            style: TextStyle(
              color: Colors.black.withOpacity(.9),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: Container(
                width: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    width: 3,
                    color: Colors.black.withOpacity(.9),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Recommencer",
                    style: TextStyle(
                      color: Colors.black.withOpacity(.9),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != Direction.up && details.delta.dy > 0) {
                  setState(() {
                    direction = Direction.down;
                    changingDirection = true;
                  });
                } else if (direction != Direction.down && details.delta.dy < 0) {
                  setState(() {
                    direction = Direction.up;
                    changingDirection = true;
                  });
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != Direction.left && details.delta.dx > 0) {
                  setState(() {
                    direction = Direction.right;
                    changingDirection = true;
                  });
                } else if (direction != Direction.right && details.delta.dx < 0) {
                  setState(() {
                    direction = Direction.left;
                    changingDirection = true;
                  });
                }
              },
              onVerticalDragEnd: (details) {
                changingDirection = false;
              },
              onHorizontalDragEnd: (details) {
                changingDirection = false;
              },
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 20,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (snakePosition.contains(index)) {
                    return Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  if (index == food) {
                    return Container(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.green,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          color: Colors.grey[900],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: startGame,

                  
                  child: Text(
                    "Démarrer",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.9),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  "@ g a b i n v i a n n e y",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
