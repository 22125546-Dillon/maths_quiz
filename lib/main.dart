import 'package:flutter/material.dart';
import 'dart:math';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maths Quiz',
      
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home page.jpeg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ArithmeticDrillPage()),
                  );
                },
                child: const Text('Begin', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArithmeticDrillPage extends StatefulWidget {
  const ArithmeticDrillPage({Key? key}) : super(key: key);
  @override
  _ArithmeticDrillPageState createState() => _ArithmeticDrillPageState();
}

class _ArithmeticDrillPageState extends State<ArithmeticDrillPage> {
  final Random _random = Random();
  final TextEditingController _controller = TextEditingController();
  int _score = 0;
  int _currentProblemIndex = 0;
  List<String> _problems = [];

  @override
  void initState() {
    super.initState();
    _generateProblems();
  }

  void _generateProblems() {
    _problems.clear();
    for (int i = 0; i < 10; i++) {
      int num1 = _random.nextInt(50);
      int num2 = _random.nextInt(50);
      String operator;
      if (_random.nextInt(4) == 0) {
        operator = '÷';
        num2 = _random.nextInt(12) + 1;
        num1 = num2 * (_random.nextInt(12) + 1);
      } else if (_random.nextInt(3) == 0) {
        operator = '×';
        num1 = _random.nextInt(12) + 1;
        num2 = _random.nextInt(12) + 1;
      } else {
        operator = _random.nextInt(2) == 0 ? '+' : '-';
      }
      _problems.add('$num1 $operator $num2');
    }
  }
  Future<void> _checkAnswer(String answer) async {
    if (answer.isEmpty) {
      _showMessageDialog('Please enter a valid answer.');
      return;
    }

    final problem = _problems[_currentProblemIndex];
    final parts = problem.split(' ');
    final int num1 = int.parse(parts[0]);
    final int num2 = int.parse(parts[2]);
    final String operator = parts[1];
    int? correctAnswer;
    if (operator == '+') {
      correctAnswer = num1 + num2;
    } else if (operator == '-') {
      correctAnswer = num1 - num2;
    } else if (operator == '×') {
      correctAnswer = num1 * num2;
    } else if (operator == '÷') {
      correctAnswer = num1 ~/ num2;
    }

    RegExp regex = RegExp(r'^[0-9\.\+\-\×\/]*$');
    if (!regex.hasMatch(answer)) {
      _showMessageDialog('Please enter a valid numerical answer. Only numbers, the "-" sign, and the "." decimal point are allowed.');
      return;
    }

    if (int.tryParse(answer) != null && int.tryParse(answer)! == correctAnswer) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Correct!', style: TextStyle(fontSize: 24)),
            content: Text('Your answer $answer is correct.', style: const TextStyle(fontSize: 20)),
            actions: <Widget>[
              TextButton(
                child: const Text('Next', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _nextProblem(); 
                },
              ),
            ],
          );
        },
      );
      
      setState(() {
        _score++;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Incorrect!', style: TextStyle(fontSize: 24)),
            content: Text('The correct answer is: $correctAnswer', style: const TextStyle(fontSize: 20)),
            actions: <Widget>[
              TextButton(
                child: const Text('Next', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _nextProblem();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _nextProblem() {
    if (_currentProblemIndex == 9) {
      String scoreMessage = 'Your Score: $_score / 10';
      if (_score >= 8) {
        scoreMessage += '\n Congratulations!';
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(scoreMessage, style: const TextStyle(fontSize: 24)),
            actions: <Widget>[
              TextButton(
                child: const Text('Restart', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  setState(() {
                    _currentProblemIndex = 0;
                    _score = 0;
                    _generateProblems();
                  });
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ArithmeticDrillPage()),
                  );
                },
              ),
              TextButton(
                child: const Text('Exit', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _currentProblemIndex++;
      });
    }
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Quiz?', style: TextStyle(fontSize: 24)),
          content: const Text('Are you sure you want to leave the quiz? Progress will be lost.', style: TextStyle(fontSize: 20)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No', style: TextStyle(fontSize: 20)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text('Yes', style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Answer', style: TextStyle(fontSize: 24)),
          content: Text(message, style: const TextStyle(fontSize: 20)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  
  void _showSkipDialog() {  
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog( //shows title,content and action, 
          title: const Text('Skip Question', style: TextStyle(fontSize: 24)),
          content: const Text('No mark will be awarded for skipping this question. Do you want to proceed?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                _nextProblem(); 
              },
              child: const Text('OK', style: TextStyle(fontSize: 20)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancel', style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        _confirmExit();
        return false; 
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Maths Quiz', style: TextStyle(color: Colors.black)),
          backgroundColor: const Color.fromARGB(255, 160, 109, 90),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background2.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 121.0),
                  child: SizedBox(
                    width: 250, 
                    child: LinearProgressIndicator(
                      minHeight: 10.0,
                      value: (_currentProblemIndex + 1) / 10,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Problem ${_currentProblemIndex + 1}:',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 1),
                Text(
                  _problems[_currentProblemIndex],
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 200, 
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    maxLines: 1, 
                    decoration: const InputDecoration(
                      hintText: 'Enter your answer',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        _checkAnswer(_controller.text);
                        _controller.clear();
                      },
                      child: const Text('Submit', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        _showSkipDialog(); 
                      },
                      child: const Text('Skip', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
                if (_score >= 8) // if the score is greater or = to 8 then display congrads on score dialogue
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
