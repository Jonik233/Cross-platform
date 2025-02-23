import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _hController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  final TextEditingController _sController = TextEditingController();

  double result = 0.0;

  final double coalLowerHeatingValue = 20.47;
  final double coalAshContent = 25.20;
  final double gCoal = 1.5;
  final double gMazut = 0.0;
  final double mazutLowerHeatingValue = 40.40;
  final double mazutAshContent = 0.15;
  final double efficiencyDustRemoval = 0.985;
  final double aVinCoal = 0.80;
  final double aVinMazut = 1.00;

  void calculateGasEmissions() {
    setState(() {
      result = 0.0;
    });
  }

  void calculateCoalEmissions() {
    double coalMass = double.tryParse(_hController.text) ?? 0.0;
    double emissionFactor = (1e6 * aVinCoal * coalAshContent * (1 - efficiencyDustRemoval)) /
        (coalLowerHeatingValue * (100 - gCoal));
    setState(() {
      result = 1e-6 * emissionFactor * coalLowerHeatingValue * coalMass;
    });
  }

  void calculateMazutEmissions() {
    double mazutMass = double.tryParse(_cController.text) ?? 0.0;
    double emissionFactor = (1e6 * aVinMazut * mazutAshContent * (1 - efficiencyDustRemoval)) /
        (mazutLowerHeatingValue * (100 - gMazut));
    setState(() {
      result = 1e-6 * emissionFactor * mazutLowerHeatingValue * mazutMass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emission Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Components", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            TextField(controller: _hController, decoration: const InputDecoration(labelText: "H")),
            TextField(controller: _cController, decoration: const InputDecoration(labelText: "C")),
            TextField(controller: _sController, decoration: const InputDecoration(labelText: "S")),
            const SizedBox(height: 20),
            const Text("Fuel Selection", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: calculateGasEmissions, child: const Text("Gas")),
                ElevatedButton(onPressed: calculateCoalEmissions, child: const Text("Coal")),
                ElevatedButton(onPressed: calculateMazutEmissions, child: const Text("Oil")),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Text("Result: ${result.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}