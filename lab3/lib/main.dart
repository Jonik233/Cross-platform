import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controllers for text input fields
  final TextEditingController _editPower = TextEditingController();
  final TextEditingController _editCurrentStd = TextEditingController();
  final TextEditingController _editTargetStd = TextEditingController();
  final TextEditingController _editCost = TextEditingController();

  String _result = "";

  // Function to parse the values from the input fields
  Map<String, double> getValues() {
    final Pc = double.tryParse(_editPower.text) ?? 0.0;
    final sigma1 = double.tryParse(_editCurrentStd.text) ?? 0.0;
    final sigma2 = double.tryParse(_editTargetStd.text) ?? 0.0;
    final electricityCost = double.tryParse(_editCost.text) ?? 0.0;

    return {
      "power": Pc,
      "current_std": sigma1,
      "target_std": sigma2,
      "cost": electricityCost,
    };
  }

  // Function for numerical integration (rectangle method)
  double integrate(double a, double b, double step, double Function(double) f) {
    double sum = 0.0;
    double x = a;
    while (x < b) {
      sum += f(x) * step;
      x += step;
    }
    return sum;
  }

  // Probability distribution function
  double probDistribution(double p, double Pc, double sigma) {
    return (1 / (sigma * sqrt(2 * pi))) * exp(-pow((p - Pc), 2) / (2 * pow(sigma, 2)));
  }

  // Button click listener
  void calculate() {
    final values = getValues();
    final power = values["power"] ?? 0.0;
    final currentStd = values["current_std"] ?? 0.0;
    final targetStd = values["target_std"] ?? 0.0;
    final cost = values["cost"] ?? 0.0;

    // Calculation for advanced forecast system
    final deltaW = integrate(4.75, 5.25, 0.01, (p) => probDistribution(p, power, targetStd));
    final W = power * 24 * deltaW;
    var P = W * cost;

    final W2 = power * 24 * (1 - deltaW);
    final S = W2 * cost;

    // Final result
    P -= S;

    setState(() {
      _result = "Результат розрахунків: ${P.toStringAsFixed(1)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Fields
            Text('H', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _editPower,
              decoration: InputDecoration(hintText: 'Enter Power'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text('C', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _editCurrentStd,
              decoration: InputDecoration(hintText: 'Enter Current Std'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text('S', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _editTargetStd,
              decoration: InputDecoration(hintText: 'Enter Target Std'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text('V', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _editCost,
              decoration: InputDecoration(hintText: 'Enter Cost'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32),

            // Calculate Button
            ElevatedButton(
              onPressed: calculate,
              child: Text('Calculate'),
            ),
            SizedBox(height: 32),

            // Result Text
            Text(
              _result,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}