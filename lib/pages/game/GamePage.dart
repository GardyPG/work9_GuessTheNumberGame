import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Game _game;
  final _controller = TextEditingController();
  String? _guessNumber;
  String? _feedback;
  bool newGame = false;
  bool guessnull = false;

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.righteous(fontSize: 20.0),
          ),
          content: Text(
            msg,
            style: GoogleFonts.fredokaOne(fontSize: 13.0),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _game = Game();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GUESS THE NUMBER', style: GoogleFonts.ubuntu()),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/02.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeader(),
                  _buildMainContent(),
                  _buildInputPanel(),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(
          'assets/images/klee.png',
          width: 180,
        ),
        Text(
          'GUESS THE NUMBER',
          style: GoogleFonts.rubikMonoOne(
              fontSize: 30, color: Colors.red.shade300),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return _guessNumber == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("I'm thinking of a number",
                  style: GoogleFonts.patrickHand(
                      fontSize: 20.0, color: Colors.indigo)),
              Text('between 1 and 100.',
                  style: GoogleFonts.patrickHand(
                      fontSize: 20.0, color: Colors.indigo)),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('Can you guess it? ❤',
                    style: GoogleFonts.permanentMarker(
                        fontSize: 30.0, color: Colors.pink.shade300)),
              ),
            ],
          )
        : Column(
            children: [
              if (guessnull == false)
                Text(_guessNumber!,
                    style: GoogleFonts.righteous(
                        fontSize: 70.0, color: Colors.teal)),
              if (guessnull != false)
                Text('ERROR!',
                    style: GoogleFonts.righteous(
                        fontSize: 70.0, color: Colors.teal)),
              Text(_feedback!,
                  style: GoogleFonts.righteous(
                      fontSize: 30.0, color: Colors.blueGrey)),
              if (newGame)
                TextButton(
                    onPressed: () {
                      setState(() {
                        _game = Game();
                        newGame = false;
                        _guessNumber = null;
                        _feedback = null;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade300,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2.0, 2.0),
                              color: Colors.red,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'NEW GAME',
                            style: GoogleFonts.righteous(
                                fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    )),
            ],
          );
  }

  Widget _buildInputPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal.shade100,
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(3.0, 3.0),
            color: Colors.teal,
            blurRadius: 5.0,
          )
        ],
        border: Border.all(width: 4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontFamily: 'Kanit',
                color: Colors.indigo,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              cursorColor: Colors.indigo,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintText: 'Enter a number',
                hintStyle: TextStyle(
                  fontFamily: 'Kanit',
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16.0,
                ),
              ),
            )),
            TextButton(
              onPressed: () {
                setState(() {
                  _guessNumber = _controller.text;
                  guessnull = false;
                  int? guess = int.tryParse(_guessNumber!);
                  if (guess != null) {
                    var result = _game.doGuess(guess);
                    var total = _game.totalGuesses;
                    if (result == 0) {
                      newGame = true;
                      _feedback = '✔ CORRECT!';
                      _showMaterialDialog('GOOD JOB!',
                          'The answer is $_guessNumber\n\nYou have made $total guesses.\n\n=> ${_game.numlist}, ');
                      _controller.clear();
                    } else if (result == 1) {
                      _feedback = '❌ TOO HIGH!';
                      _controller.clear();
                    } else {
                      _feedback = '❌ TOO LOW!';
                      _controller.clear();
                    }
                  } else {
                    guessnull = true;
                    _feedback = 'Please enter a number';
                    newGame = false;
                    _controller.clear();
                  }
                });
              },
              child: Text('  GUESS',
                  style: GoogleFonts.righteous(
                      fontSize: 20.0, color: Colors.deepPurple)),
            )
          ],
        ),
      ),
    );
  }
}
