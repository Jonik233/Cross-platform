import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _hController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  final TextEditingController _sController = TextEditingController();
  final TextEditingController _nController = TextEditingController();
  final TextEditingController _oController = TextEditingController();
  final TextEditingController _wController = TextEditingController();
  final TextEditingController _aController = TextEditingController();

  String result = "";

  // Function to parse input values
  Map<String, double> getValues() {
    double parseValue(String value) => double.tryParse(value) ?? 0.0;

    return {
      "H": parseValue(_hController.text),
      "C": parseValue(_cController.text),
      "S": parseValue(_sController.text),
      "N": parseValue(_nController.text),
      "O": parseValue(_oController.text),
      "W": parseValue(_wController.text),
      "A": parseValue(_aController.text),
    };
  }

  // Dry Mass Calculation
  void calculateDryMass() {
    final values = getValues();
    double K_dry = 100 / (100 - values["W"]!);
    setState(() {
      result = """
      Результат розрахунків:
      H: ${(values["H"]! * K_dry).toStringAsFixed(2)}
      C: ${(values["C"]! * K_dry).toStringAsFixed(2)}
      S: ${(values["S"]! * K_dry).toStringAsFixed(2)}
      N: ${(values["N"]! * K_dry).toStringAsFixed(2)}
      O: ${(values["O"]! * K_dry).toStringAsFixed(2)}
      A: ${(values["A"]! * K_dry).toStringAsFixed(2)}
      """;
    });
  }

  // Flammable Mass Calculation
  void calculateFlammableMass() {
    final values = getValues();
    double K_fl = 100 / (100 - values["W"]! - values["A"]!);
    setState(() {
      result = """
      Результат розрахунків:
      H: ${(values["H"]! * K_fl).toStringAsFixed(2)}
      C: ${(values["C"]! * K_fl).toStringAsFixed(2)}
      S: ${(values["S"]! * K_fl).toStringAsFixed(2)}
      N: ${(values["N"]! * K_fl).toStringAsFixed(2)}
      O: ${(values["O"]! * K_fl).toStringAsFixed(2)}
      """;
    });
  }

  // Lower Heat of Combustion - Flammable Mass
  void calculateQFlammable() {
    final values = getValues();
    double Q_work = 339 * values["C"]! + 1030 * values["H"]! - 108.8 * (values["O"]! - values["S"]!) - 25 * values["W"]!;
    double Q_fl = (Q_work + 0.025 * values["W"]!) * (100 / (100 - values["W"]! - values["A"]!));
    setState(() {
      result = "Результат розрахунків:\nQ_fl: ${Q_fl.toStringAsFixed(2)}";
    });
  }

  // Lower Heat of Combustion - Dry Mass
  void calculateQDry() {
    final values = getValues();
    double Q_work = 339 * values["C"]! + 1030 * values["H"]! - 108.8 * (values["O"]! - values["S"]!) - 25 * values["W"]!;
    double Q_dry = (Q_work + 0.025 * values["W"]!) * (100 / (100 - values["W"]!));
    setState(() {
      result = "Результат розрахунків:\nQ_dry: ${Q_dry.toStringAsFixed(2)}";
    });
  }

  // Lower Heat of Combustion - Working Mass
  void calculateQWork() {
    final values = getValues();
    double Q_work = 339 * values["C"]! + 1030 * values["H"]! - 108.8 * (values["O"]! - values["S"]!) - 25 * values["W"]!;
    setState(() {
      result = "Результат розрахунків:\nQ_work: ${Q_work.toStringAsFixed(2)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Калькулятор")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Fields
            Row(
              children: [
                Expanded(child: buildTextField("H", _hController)),
                Expanded(child: buildTextField("C", _cController)),
                Expanded(child: buildTextField("S", _sController)),
              ],
            ),
            Row(
              children: [
                Expanded(child: buildTextField("N", _nController)),
                Expanded(child: buildTextField("O", _oController)),
                Expanded(child: buildTextField("W", _wController)),
              ],
            ),
            buildTextField("A", _aController),

            SizedBox(height: 20),

            // Buttons
            Wrap(
              spacing: 10,
              children: [
                buildButton("Dry", calculateDryMass),
                buildButton("Flammable", calculateFlammableMass),
                buildButton("Q_fl", calculateQFlammable),
                buildButton("Q_dry", calculateQDry),
                buildButton("Q_work", calculateQWork),
              ],
            ),

            SizedBox(height: 20),

            // Result Display
            Text(result, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Helper function to build TextField
  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  // Helper function to build buttons
  Widget buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(onPressed: onPressed, child: Text(text));
  }
}