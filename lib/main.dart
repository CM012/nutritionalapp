import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Nutrition App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              pair.asLowerCase,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Click here to generate a new word'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraOptionsPage()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '📷',
                  style: TextStyle(fontSize: 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Options'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NutritionCalculatorPage()),
                  );
                },
                child: Text('Choose from Gallery'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NutritionCalculatorPage()),
                  );
                },
                child: Text('Take Photo Now'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NutritionCalculatorPage extends StatefulWidget {
  @override
  _NutritionCalculatorPageState createState() => _NutritionCalculatorPageState();
}

class _NutritionCalculatorPageState extends State<NutritionCalculatorPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _carbController = TextEditingController(text: '100');
  final TextEditingController _proteinController = TextEditingController(text: '20');
  final TextEditingController _fatController = TextEditingController(text: '20');

  String _sex = 'male';
  String _activityLevel = 'sedentary';
  String _dietPlan = 'balance';
  String _result = '';

  double calculateBMR(double weight, double height, int age, String sex) {
    if (sex == "male") {
      return 66 + (6.3 * weight) + (12.9 * height) - (6.8 * age);
    } else {
      return 655 + (4.3 * weight) + (4.7 * height) - (4.7 * age);
    }
  }

  double calculateDailyCalories(double bmr, String activityLevel) {
    switch (activityLevel) {
      case "sedentary":
        return bmr * 1.2;
      case "lightly active":
        return bmr * 1.375;
      case "moderately active":
        return bmr * 1.55;
      case "very active":
        return bmr * 1.725;
      default:
        return bmr;
    }
  }

  void calculateNutrition() {
    final double? weight = double.tryParse(_weightController.text);
    final double? height = double.tryParse(_heightController.text);
    final int? age = int.tryParse(_ageController.text);

    if (weight == null || height == null || age == null) {
      setState(() {
        _result = 'Please enter valid values for weight, height, and age';
      });
      return;
    }

    final double weightInLb = weight * 2.20462;
    final double heightInInches = height * 39.3701;

    final double bmr = calculateBMR(weightInLb, heightInInches, age, _sex);
    final double calories = calculateDailyCalories(bmr, _activityLevel);

    double carbIntake, proteinIntake, fatIntake;

    switch (_dietPlan) {
      case "balance":
        carbIntake = calories * 0.65 / 4;
        proteinIntake = calories * 0.125 / 4;
        fatIntake = calories * 0.225 / 9;
        break;
      case "low fat":
        carbIntake = calories * 0.725 / 4;
        proteinIntake = calories * 0.125 / 4;
        fatIntake = calories * 0.15 / 9;
        break;
      case "low carb":
        carbIntake = calories * 0.55 / 4;
        proteinIntake = calories * 0.15 / 4;
        fatIntake = calories * 0.30 / 9;
        break;
      case "high protein":
        carbIntake = calories * 0.725 / 4;
        proteinIntake = calories * 0.15 / 4;
        fatIntake = calories * 0.125 / 9;
        break;
      default:
        carbIntake = proteinIntake = fatIntake = 0;
    }

    final double currentCarb = double.tryParse(_carbController.text) ?? 100;
    final double currentProtein = double.tryParse(_proteinController.text) ?? 20;
    final double currentFat = double.tryParse(_fatController.text) ?? 20;

    final double carbNeeded = carbIntake - currentCarb;
    final double proteinNeeded = proteinIntake - currentProtein;
    final double fatNeeded = fatIntake - currentFat;

    final List<List<double>> W = [
      [20, 20.1, 9],
      [1.45, 9.02, 2],
      [0, 0.38, 15]
    ];

    final List<double> y = [carbNeeded, proteinNeeded, fatNeeded];

    List<double> solution = [0, 0, 0]; // Placeholder for optimization logic

    setState(() {
      _result = '''
      Your daily calorie needs are: ${calories.toStringAsFixed(2)}
      Your protein intake should be ${proteinIntake.toStringAsFixed(2)} grams per day
      Your carbohydrates intake should be ${carbIntake.toStringAsFixed(2)} grams per day
      Your fat intake should be ${fatIntake.toStringAsFixed(2)} grams per day
      We need to print following amount: ${solution.map((e) => e.toStringAsFixed(2)).join(', ')}
      ''';
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(result: _result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Calculator'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight in KG'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height in M'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: _sex,
                items: ['male', 'female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _sex = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: _activityLevel,
                items: [
                  'sedentary',
                  'lightly active',
                  'moderately active',
                  'very active'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _activityLevel = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: _dietPlan,
                items: ['balance', 'low fat', 'low carb', 'high protein'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _dietPlan = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _carbController,
                decoration: InputDecoration(labelText: 'Current Carb Intake (g)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _proteinController,
                decoration: InputDecoration(labelText: 'Current Protein Intake (g)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _fatController,
                decoration: InputDecoration(labelText: 'Current Fat Intake (g)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateNutrition,
                child: Text('Calculate'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final String result;

  ResultPage({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                result,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrintMyFoodPage()),
                  );
                },
                child: Text('Print my food'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrintMyFoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Print My Food'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🖨️ Printing the food you need...',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}