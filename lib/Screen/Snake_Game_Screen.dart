import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SnakeGameScreenState createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  static const int gridSize = 20;
  static const int snakeSpeed = 200;

  late List<Offset> snake;
  late Offset food;
  late SnakeDirection direction;
  late bool isPlaying;
  late Timer timer;
  late int score;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    snake = [const Offset(5, 5)];
    food = generateRandomPosition();
    direction = SnakeDirection.right;
    isPlaying = false;
    score = 0;
    timer = Timer.periodic(const Duration(milliseconds: snakeSpeed), (Timer t) {
      if (isPlaying) {
        moveSnake();
      }
    });
  }

  Offset generateRandomPosition() {
    final Random random = Random();
    int x = random.nextInt(gridSize - 1).toDouble().toInt();
    int y = random.nextInt(gridSize - 1).toDouble().toInt();
    return Offset(x.toDouble(), y.toDouble());
  }

  void moveSnake() {
    setState(() {
      switch (direction) {
        case SnakeDirection.up:
          snake.insert(0, Offset(snake.first.dx, snake.first.dy - 1));
          break;
        case SnakeDirection.down:
          snake.insert(0, Offset(snake.first.dx, snake.first.dy + 1));
          break;
        case SnakeDirection.left:
          snake.insert(0, Offset(snake.first.dx - 1, snake.first.dy));
          break;
        case SnakeDirection.right:
          snake.insert(0, Offset(snake.first.dx + 1, snake.first.dy));
          break;
      }
      if (snake.first == food) {
        score++;
        food = generateRandomPosition();
      } else {
        snake.removeLast();
      }
      if (checkCollision()) {
        gameOver();
      }
    });
  }

  bool checkCollision() {
    if (snake.first.dx < 0 ||
        snake.first.dx >= gridSize ||
        snake.first.dy < 0 ||
        snake.first.dy >= gridSize ||
        snake.sublist(1).contains(snake.first)) {
      return true;
    }
    return false;
  }

  void gameOver() {
    setState(() {
      isPlaying = false;
      timer.cancel();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: Text('Your score: $score'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  initializeGame();
                },
                child: const Text('Play Again'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != SnakeDirection.up && details.delta.dy > 0) {
                  direction = SnakeDirection.down;
                } else if (direction != SnakeDirection.down &&
                    details.delta.dy < 0) {
                  direction = SnakeDirection.up;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != SnakeDirection.left && details.delta.dx > 0) {
                  direction = SnakeDirection.right;
                } else if (direction != SnakeDirection.right &&
                    details.delta.dx < 0) {
                  direction = SnakeDirection.left;
                }
              },
              child: Container(
                color: Colors.black,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    int x = index % gridSize;
                    int y = index ~/ gridSize;
                    Offset position = Offset(x.toDouble(), y.toDouble());

                    if (snake.contains(position)) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      );
                    } else if (food == position) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                  itemCount: gridSize * gridSize,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
                icon: isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Score'),
                        content: Text('Your score: $score'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.score),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum SnakeDirection { up, down, left, right }
