import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab6 Calculation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculationPage(),
    );
  }
}

class CalculationPage extends StatefulWidget {
  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  // TextEditingControllers for eight input fields
  final TextEditingController namingController = TextEditingController();
  final TextEditingController coefNController = TextEditingController();
  final TextEditingController coefPController = TextEditingController();
  final TextEditingController strengthController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController nomPController = TextEditingController();
  final TextEditingController coefUController = TextEditingController();
  final TextEditingController coefRPController = TextEditingController();

  String resultText = "";

  // Calculation functions, equivalent to the Kotlin functions:

  // Calculate the current (mapping: naming = n, nomP = Pn, strength = Uh, coefP = cosPhi, coefN = etaH)
  double calculateCurrent(int n, double Pn, double Uh, double cosPhi, double etaH) {
    return (n * Pn) / (sqrt(3.0) * Uh * cosPhi * etaH);
  }

  // Calculate the group utilization coefficient (mapping: quantity = sumNPk, coefU = sumNP)
  double calculateGroupUtilizationCoefficient(double sumNPk, double sumNP) {
    return sumNPk / sumNP;
  }

  // Calculate the effective number of EP (mapping: quantity = sumNP, coefRP = sumNP2)
  double calculateEffectiveNumberEP(double sumNP, double sumNP2) {
    return (pow(sumNP, 2)) / sumNP2;
  }

  // Calculate the active power (mapping: coefN = Kp, coefP = Kb, nomP = Pn)
  double calculateActivePower(double Kp, double Kb, double Pn) {
    return Kp * Kb * Pn;
  }

  // Calculate the reactive power (mapping: coefP = Kb, nomP = Pn, strength = tgPhi)
  double calculateReactivePower(double Kb, double Pn, double tgPhi) {
    return Kb * Pn * tgPhi;
  }

  // Calculate the full power based on active and reactive power
  double calculateFullPower(double Pp, double Qp) {
    return sqrt(pow(Pp, 2) + pow(Qp, 2));
  }

  // Trigger calculation when the button is pressed.
  void calculate() {
    // Parse inputs (if parsing fails, default to 0)
    final double naming = double.tryParse(namingController.text) ?? 0;
    final double coefN = double.tryParse(coefNController.text) ?? 0;
    final double coefP = double.tryParse(coefPController.text) ?? 0;
    final double strength = double.tryParse(strengthController.text) ?? 0;
    final double quantity = double.tryParse(quantityController.text) ?? 0;
    final double nomP = double.tryParse(nomPController.text) ?? 0;
    final double coefU = double.tryParse(coefUController.text) ?? 0;
    final double coefRP = double.tryParse(coefRPController.text) ?? 0;

    // Map inputs to parameters (the mapping here is arbitrary—you can adjust as needed)
    int n = naming.toInt();
    double current = calculateCurrent(n, nomP, strength, coefP, coefN);
    double groupUtilization = calculateGroupUtilizationCoefficient(quantity, coefU);
    double effectiveEP = calculateEffectiveNumberEP(quantity, coefRP);
    double activePower = calculateActivePower(coefN, coefP, nomP);
    double reactivePower = calculateReactivePower(coefP, nomP, strength);
    double fullPower = calculateFullPower(activePower, reactivePower);

    // Update UI with formatted results
    setState(() {
      resultText =
      'Current: ${current.toStringAsFixed(2)}\n'
          'Group Utilization Coefficient: ${groupUtilization.toStringAsFixed(2)}\n'
          'Effective Number of EP: ${effectiveEP.toStringAsFixed(2)}\n'
          'Active Power: ${activePower.toStringAsFixed(2)}\n'
          'Reactive Power: ${reactivePower.toStringAsFixed(2)}\n'
          'Full Power: ${fullPower.toStringAsFixed(2)}';
    });
  }

  // Build an input field with a label and fixed size (150 x 50, similar to the Android XML)
  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: 150,
              height: 50,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: label,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lab6 Calculation'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Each input field corresponds to one of the XML EditText fields.
            buildInputField('Naming (@string/H)', namingController),
            buildInputField('Coef N (@string/C)', coefNController),
            buildInputField('Coef P (@string/S)', coefPController),
            buildInputField('Strength (@string/V)', strengthController),
            buildInputField('Quantity (@string/D)', quantityController),
            buildInputField('Nom P (@string/A)', nomPController),
            buildInputField('Coef U (@string/B)', coefUController),
            buildInputField('Coef RP (@string/L)', coefRPController),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: calculate,
                child: Text('Calculate (@string/btn1)'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              resultText,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}