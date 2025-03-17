import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FuelCalculatorScreen(),
    );
  }
}

class FuelCalculatorScreen extends StatefulWidget {
  @override
  _FuelCalculatorScreenState createState() => _FuelCalculatorScreenState();
}

class _FuelCalculatorScreenState extends State<FuelCalculatorScreen> {
  final TextEditingController _moistureController = TextEditingController();
  final TextEditingController _ashController = TextEditingController();
  String _result = '';

  void _calculate() {
    double? moisture = double.tryParse(_moistureController.text);
    double? ash = double.tryParse(_ashController.text);

    if (moisture == null || ash == null) {
      setState(() {
        _result = 'Please enter valid numbers';
      });
      return;
    }

    double dryMass = 100 - moisture;
    double combustibleMass = dryMass - ash;
    double reliability = sqrt(pow(dryMass, 2) + pow(combustibleMass, 2));

    setState(() {
      _result = 'Dry Mass: ${dryMass.toStringAsFixed(2)}%\n'
          'Combustible Mass: ${combustibleMass.toStringAsFixed(2)}%\n'
          'Reliability: ${reliability.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fuel Calculator')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _moistureController,
              decoration: InputDecoration(labelText: 'Moisture Content (%)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _ashController,
              decoration: InputDecoration(labelText: 'Ash Content (%)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}