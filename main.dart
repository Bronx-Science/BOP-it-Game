import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

FontWeight bigFontWeight = FontWeight.w900;
FontWeight medFontWeight = FontWeight.w600;
FontWeight smallFontWeight = FontWeight.w400;

Color color1 = Color.fromARGB(255, 239, 239, 239);
Color color2 = Color.fromARGB(255, 161, 161, 161);
Color color3 = Color.fromARGB(255, 110, 110, 110);
Color color4 = Color.fromARGB(255, 69, 59, 56);
Color textColor = Colors.white;

bool isStarted = false;
int timeLeft = 3;
late String action;
double scale = 1.0;
double rotation = 0;
bool isPaused = false;
List<int> scores = [];
List<int> orderedScores = [];

// Randomly generates which action is to be preformed by the user
void makeAction() {
  int random = Random().nextInt(4);
  switch (random) {
    case 0:
      action = 'BOP-it';
      textColor = Colors.red;
      break;
    case 1:
      action = 'TWIST-it';
      textColor = Colors.yellow;
      break;
    case 2:
      action = 'PULL-it';
      textColor = Colors.blue;
      break;
    case 3:
      action = 'PINCH-it';
      textColor = Colors.green;
      break;
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double titleFontSize = MediaQuery.of(context).size.width * 1.6 <
            MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width * 0.18
        : MediaQuery.of(context).size.height * 0.15;
    double mediumFontSize = MediaQuery.of(context).size.width * 1.6 <
            MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width * 0.08
        : MediaQuery.of(context).size.height * 0.05;

    return Scaffold(
        backgroundColor: color4,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: !isStarted,
                  child: Text('BOP-it!',
                      style: TextStyle(
                          fontSize: titleFontSize,
                          color: color1,
                          fontWeight: bigFontWeight)),
                ),
                Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04)),
                Visibility(
                    visible: !isStarted,
                    child: OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return states.contains(MaterialState.pressed) ||
                                      states.contains(MaterialState.hovered)
                                  ? color2
                                  : color3;
                            },
                          ),
                        ),
                        child: Text('START',
                            style: TextStyle(
                                fontSize: mediumFontSize,
                                color: color1,
                                fontWeight: medFontWeight)),
                        onPressed: () {
                          setState(() {
                            isStarted = true;
                            Timer.periodic(Duration(milliseconds: 500),
                                (timer) {
                              setState(() {
                                timeLeft--;
                                if (timeLeft < 0) {
                                  timeLeft = 3;
                                  makeAction();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GamePage()),
                                      (route) => false);
                                }
                              });
                            });
                          });
                        })),
                Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.02)),
                Visibility(
                    visible: !isStarted,
                    child: OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return states.contains(MaterialState.pressed) ||
                                      states.contains(MaterialState.hovered)
                                  ? color2
                                  : color3;
                            },
                          ),
                        ),
                        child: Text('VIEW SCORES',
                            style: TextStyle(
                                fontSize: mediumFontSize,
                                color: color1,
                                fontWeight: medFontWeight)),
                        onPressed: () {
                          print(orderedScores);
                          print(scores);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScorePage()));
                        })),
                Visibility(
                    visible: isStarted,
                    child: Center(
                        child: Text(timeLeft.toString(),
                            style: TextStyle(
                                fontSize: 50,
                                color: color1,
                                fontWeight: bigFontWeight))))
              ]),
        ));
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int timeLeft = 9;
  late Timer gameTimer;
  Image backgroundImage =
      Image(image: AssetImage('images/BOP-it Images/bopit_regular.png'));
  Image bopitImage =
      Image(image: AssetImage('images/BOP-it Images/bopit_regular.png'));
  Image boppedImage =
      Image(image: AssetImage('images/BOP-it Images/bopit_bopped.png'));
  Image pulledImage =
      Image(image: AssetImage('images/BOP-it Images/bopit_pulled.png'));
  Image pinchedImage =
      Image(image: AssetImage('images/BOP-it Images/bopit_pinched.png'));
  Image twistedImage =
      Image(image: AssetImage('images/BOP-it Images/bopit_twisted.png'));

  void initState() {
    super.initState();
    scores.add(0);
    gameTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        if (!isPaused) {
          timeLeft--;
          if (timeLeft < 1) {
            timer.cancel();
            orderedScores.add(scores[scores.length - 1]);
            orderedScores.sort();
            youDied();
          }
        }
      });
    });
  }

  void youDied() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: color4,
              content: Text('YOU DIED',
                  style: TextStyle(
                      color: color1,
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                      fontWeight: medFontWeight)),
              actions: <Widget>[
                TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return states.contains(MaterialState.pressed) ||
                                  states.contains(MaterialState.hovered)
                              ? color3
                              : color4;
                        },
                      ),
                    ),
                    onPressed: () {
                      isStarted = false;
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ScorePage()));
                    },
                    child: Text('VIEW SCORES',
                        style: TextStyle(
                            color: color2,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: smallFontWeight))),
                TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return states.contains(MaterialState.pressed) ||
                                  states.contains(MaterialState.hovered)
                              ? color3
                              : color4;
                        },
                      ),
                    ),
                    onPressed: () {
                      orderedScores.sort();
                      isStarted = false;
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                      makeAction();
                    },
                    child: Text('QUIT',
                        style: TextStyle(
                            color: color2,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: smallFontWeight)))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    double bigFontSize = MediaQuery.of(context).size.width * 1.6 <
            MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width * 0.1
        : MediaQuery.of(context).size.height * 0.08;
    double mediumFontSize = MediaQuery.of(context).size.width * 1.6 <
            MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width * 0.08
        : MediaQuery.of(context).size.height * 0.05;
    double smallFontSize = MediaQuery.of(context).size.width * 1.6 <
            MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width * 0.05
        : MediaQuery.of(context).size.height * 0.02;
    double detectorSize =
        MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.width * 0.2
            : MediaQuery.of(context).size.height * 0.2;

    return Scaffold(
        backgroundColor: color3,
        appBar: AppBar(
          backgroundColor: color3,
          shadowColor: Colors.transparent,
        ),
        body: Center(
            child: Column(children: [
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color4, borderRadius: BorderRadius.circular(10.0)),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(action,
                      style: TextStyle(
                          color: textColor,
                          fontSize: bigFontSize,
                          fontWeight: bigFontWeight)),
                  IconButton(
                      onPressed: () {
                        isPaused = true;
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  backgroundColor: color4,
                                  content: Text(
                                    'PAUSED',
                                    style: TextStyle(
                                        color: color1,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        fontWeight: medFontWeight),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              return states.contains(
                                                          MaterialState
                                                              .pressed) ||
                                                      states.contains(
                                                          MaterialState.hovered)
                                                  ? color3
                                                  : color4;
                                            },
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          isPaused = false;
                                        },
                                        child: Text('CONTINUE',
                                            style: TextStyle(
                                                color: color2,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                fontWeight: smallFontWeight))),
                                    TextButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              return states.contains(
                                                          MaterialState
                                                              .pressed) ||
                                                      states.contains(
                                                          MaterialState.hovered)
                                                  ? color3
                                                  : color4;
                                            },
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          isStarted = false;
                                          isPaused = false;
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()));
                                          makeAction();
                                        },
                                        child: Text(
                                          'QUIT',
                                          style: TextStyle(
                                              color: color2,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              fontWeight: smallFontWeight),
                                        ))
                                  ]);
                            });
                      },
                      icon: Icon(Icons.pause, color: color1))
                ],
              )),
          Padding(padding: EdgeInsets.all(10)),
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color4, borderRadius: BorderRadius.circular(10.0)),
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('   TIME LEFT:    ',
                          style: TextStyle(
                              color: color2,
                              fontSize: smallFontSize,
                              fontWeight: medFontWeight)),
                      Text(timeLeft.toString(),
                          style: TextStyle(
                              color: color1,
                              fontSize: mediumFontSize,
                              fontWeight: bigFontWeight))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('SCORE:    ',
                          style: TextStyle(
                              color: color2,
                              fontSize: smallFontSize,
                              fontWeight: medFontWeight)),
                      Text(scores[scores.length - 1].toString(),
                          style: TextStyle(
                              color: color1,
                              fontSize: mediumFontSize,
                              fontWeight: bigFontWeight))
                    ],
                  ),
                ],
              )),
          Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Center(child: backgroundImage),
                      Center(child: bopitImage),
                      Positioned(
                        left:
                            (MediaQuery.of(context).size.width - detectorSize) *
                                0.5,
                        bottom: MediaQuery.of(context).size.height * 0.24,
                        child: Container(
                          //color: Colors.red,
                          width: detectorSize,
                          height: detectorSize,
                          child: GestureDetector(onTap: () {
                            setState(() {
                              if (action == 'BOP-it') {
                                scores[scores.length - 1] =
                                    scores[scores.length - 1] + 1;
                                bopitImage = boppedImage;
                                timeLeft = 9;
                                makeAction();
                                Timer(Duration(milliseconds: 200), () {
                                  bopitImage = backgroundImage;
                                });
                              } else {
                                timeLeft = 1;
                              }
                            });
                          }),
                        ),
                      ),
                      Positioned(
                        left:
                            (MediaQuery.of(context).size.width - detectorSize) *
                                0.5,
                        bottom: MediaQuery.of(context).size.height * 0.4,
                        child: Container(
                          //color: Colors.white,
                          width: detectorSize,
                          height: detectorSize,
                          child: GestureDetector(
                            onVerticalDragEnd: (details) {
                              setState(() {
                                final delta = details.primaryVelocity;
                                if (delta != null && delta.abs() >= -0.01) {
                                  if (action == 'PULL-it') {
                                    scores[scores.length - 1] =
                                        scores[scores.length - 1] + 1;
                                    bopitImage = pulledImage;
                                    timeLeft = 9;
                                    makeAction();
                                    Timer(Duration(milliseconds: 200), () {
                                      bopitImage = backgroundImage;
                                    });
                                  } else {
                                    orderedScores
                                        .add(scores[scores.length - 1]);
                                    orderedScores.sort();
                                    timeLeft = 1;
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.45,
                        right: MediaQuery.of(context).size.width * 0.15,
                        child: Container(
                          //color: Colors.green,
                          width: detectorSize,
                          height: detectorSize,
                          child: GestureDetector(
                            onScaleUpdate: (ScaleUpdateDetails details) {
                              setState(() {
                                scale = details.scale;
                                if (action == 'PINCH-it') {
                                  bopitImage = pinchedImage;
                                  scores[scores.length - 1] =
                                      scores[scores.length - 1] + 1;
                                  timeLeft = 9;
                                  makeAction();
                                  Timer(Duration(milliseconds: 200), () {
                                    bopitImage = backgroundImage;
                                  });
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.45,
                        left: MediaQuery.of(context).size.width * 0.15,
                        child: Container(
                          //color: Colors.yellow,
                          width: detectorSize,
                          height: detectorSize,
                          child: GestureDetector(
                            onScaleUpdate: (ScaleUpdateDetails details) {
                              setState(() {
                                rotation = details.rotation;
                                if (action == 'TWIST-it') {
                                  if (rotation != 0) {
                                    scores[scores.length - 1] =
                                        scores[scores.length - 1] + 1;
                                    bopitImage = twistedImage;
                                    timeLeft = 9;
                                    makeAction();
                                    rotation = 0;
                                    Timer(Duration(milliseconds: 200), () {
                                      bopitImage = backgroundImage;
                                    });
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  )))
        ])));
  }
}

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    double bigFontSize = MediaQuery.of(context).size.width * 1.6 <
            MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width * 0.1
        : MediaQuery.of(context).size.height * 0.08;
    double mediumFontSize = MediaQuery.of(context).size.width * 1.6 <
            MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width * 0.08
        : MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
        backgroundColor: color4,
        appBar: AppBar(
            backgroundColor: color4,
            title: Text('TOP SCORES',
                style: TextStyle(
                    color: color1,
                    fontSize: bigFontSize,
                    fontWeight: bigFontWeight))),
        body: ListView.builder(
            itemCount: orderedScores.length,
            itemBuilder: (context, index) => Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                color: index == 0
                    ? Color.fromARGB(255, 236, 197, 0)
                    : index == 1
                        ? Color.fromARGB(255, 180, 169, 169)
                        : index == 2
                            ? const Color.fromARGB(255, 167, 113, 31)
                            : color3,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    index == 0
                        ? Text('1st',
                            style: TextStyle(
                                color: color1,
                                fontSize: mediumFontSize,
                                fontWeight: bigFontWeight))
                        : index == 1
                            ? Text('2nd',
                                style: TextStyle(
                                    color: color1,
                                    fontSize: mediumFontSize,
                                    fontWeight: bigFontWeight))
                            : index == 2
                                ? Text('3rd',
                                    style: TextStyle(
                                        color: color1,
                                        fontSize: mediumFontSize,
                                        fontWeight: bigFontWeight))
                                : Text('${(index + 1).toString()}th',
                                    style: TextStyle(
                                        color: color1,
                                        fontSize: mediumFontSize,
                                        fontWeight: bigFontWeight)),
                    Text(
                        orderedScores[orderedScores.length - index - 1]
                            .toString(),
                        style: TextStyle(
                            color: color1,
                            fontSize: mediumFontSize,
                            fontWeight: bigFontWeight))
                  ],
                )))));
  }
}
