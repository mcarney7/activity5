//Shellicia Bethune
//MiKayla Carney
// CSC 4360-002: MAD
// Activity 5


import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PetHomePage(),
    );
  }
}

class PetHomePage extends StatefulWidget {
  @override
  _PetHomePageState createState() => _PetHomePageState();
}

class _PetHomePageState extends State<PetHomePage> {
  String petName = 'Your Pet';
  int happinessLevel = 50;
  int hungerLevel = 50;
  Color petColor = Colors.yellow;
  String petMood = 'Neutral';
  TextEditingController _nameController = TextEditingController();
  Timer? _hungerTimer;
  Timer? _happinessTimer; // Timer for happiness
  bool gameOver = false; // To track game state

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _startHappinessTimer(); // Start happiness timer
    _updatePetMoodAndColor();
  }

  // Function to start the hunger timer that runs every 30 seconds
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 10).clamp(0, 100);
      });
      _checkLossCondition(); // Check for loss condition every time hunger increases
    });
  }

  // Function to start the happiness timer that runs every 30 seconds
  void _startHappinessTimer() {
    _happinessTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        happinessLevel = (happinessLevel - 10).clamp(0, 100);
        _updatePetMoodAndColor(); // Update mood and color
      });
      _checkLossCondition(); // Check for loss condition
    });
  }

  // Function to update pet's color and mood based on happiness level
  void _updatePetMoodAndColor() {
    setState(() {
      if (happinessLevel > 70) {
        petColor = Colors.green;
        petMood = 'Happy';
      } else if (happinessLevel >= 30) {
        petColor = Colors.yellow;
        petMood = 'Neutral';
      } else {
        petColor = Colors.red;
        petMood = 'Unhappy';
      }
    });
  }

  // Function to set the pet's name
  void _setPetName() {
    setState(() {
      petName = _nameController.text;
    });
  }

  // Function to increase happiness when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updatePetMoodAndColor();
    });
    _checkWinCondition(); // Check win condition when playing with the pet
  }

  // Function to decrease hunger when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
    });
  }

  // Function to check win condition
  void _checkWinCondition() {
    if (happinessLevel > 80 && !gameOver) {
      Timer(Duration(minutes: 3), () {
        if (happinessLevel > 80) {
          setState(() {
            gameOver = true;
            _hungerTimer?.cancel();
            _happinessTimer?.cancel();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('You Win!'),
                  content: Text('Congratulations, you kept your pet happy for 3 minutes!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          });
        }
      });
    }
  }

  // Function to check loss condition
  void _checkLossCondition() {
    if (hungerLevel >= 100 && happinessLevel <= 10 && !gameOver) {
      setState(() {
        gameOver = true;
        _hungerTimer?.cancel();
        _happinessTimer?.cancel();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Game Over'),
              content: Text('Your pet is too hungry and unhappy. You lose.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _happinessTimer?.cancel(); // Cancel happiness timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter Pet Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _setPetName,
              child: Text('Set Pet Name'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            SizedBox(height: 16.0),
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: petColor, // Pet color
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://png.pngtree.com/png-vector/20230114/ourmid/pngtree-angry-cute-dog-sticker-png-image_6562186.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              petMood,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: Text('Play with Your Pet'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
