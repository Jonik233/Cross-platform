import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Short Circuit Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ShortCircuitCalculator(),
    );
  }
}

class ShortCircuitCalculator extends StatefulWidget {
  @override
  _ShortCircuitCalculatorState createState() => _ShortCircuitCalculatorState();
}

class _ShortCircuitCalculatorState extends State<ShortCircuitCalculator> {
  final TextEditingController _uController = TextEditingController();
  final TextEditingController _zController = TextEditingController();
  final TextEditingController _rController = TextEditingController();
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _tController = TextEditingController();
  final TextEditingController _kfController = TextEditingController();
  final TextEditingController _kThermalController = TextEditingController();
  final TextEditingController _kDynController = TextEditingController();

  String _result = "";

  double _parseInput(String value) {
    return double.tryParse(value) ?? 0.0;
  }

  double calculateThreePhaseCurrent(double U, double Z) {
    return Z != 0 ? U / Z : 0;
  }

  double calculateSinglePhaseCurrent(double U, double R, double X) {
    double Z = sqrt(R * R + X * X);
    return Z != 0 ? U / Z : 0;
  }

  bool checkThermalStability(double I, double k, double t) {
    return I * I * t <= k;
  }

  bool checkDynamicStability(double Ipeak, double kdyn) {
    return Ipeak <= kdyn;
  }

  double calculatePeakCurrent(double I, double kf) {
    return I * kf;
  }

  void calculate() {
    double U = _parseInput(_uController.text);
    double Z = _parseInput(_zController.text);
    double R = _parseInput(_rController.text);
    double X = _parseInput(_xController.text);
    double T = _parseInput(_tController.text);
    double KF = _parseInput(_kfController.text);
    double KThermal = _parseInput(_kThermalController.text);
    double KDyn = _parseInput(_kDynController.text);

    double threePhaseCurrent = calculateThreePhaseCurrent(U, Z);
    double singlePhaseCurrent = calculateSinglePhaseCurrent(U, R, X);
    bool isThermalStable = checkThermalStability(threePhaseCurrent, KThermal, T);
    double peakCurrent = calculatePeakCurrent(threePhaseCurrent, KF);
    bool isDynamicStable = checkDynamicStability(peakCurrent, KDyn);

    setState(() {
      _result = """
        Three-Phase Current: ${threePhaseCurrent.toStringAsFixed(1)} A
        Single-Phase Current: ${singlePhaseCurrent.toStringAsFixed(1)} A
        Thermal Stability: ${isThermalStable ? "Yes" : "No"}
        Dynamic Stability: ${isDynamicStable ? "Yes" : "No"}
      """;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Short Circuit Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputField(_uController, "Enter U"),
            _buildInputField(_zController, "Enter Z"),
            _buildInputField(_rController, "Enter R"),
            _buildInputField(_xController, "Enter X"),
            _buildInputField(_tController, "Enter t"),
            _buildInputField(_kfController, "Enter kf"),
            _buildInputField(_kThermalController, "Enter kThermal"),
            _buildInputField(_kDynController, "Enter kDyn"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculate,
              child: Text("Calculate"),
            ),
            SizedBox(height: 16),
            Text(_result, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: hint,
        ),
      ),
    );
  }
}