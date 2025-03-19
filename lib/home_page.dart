import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _temperatureController = TextEditingController();
  String _fromUnit = 'Celsius';
  String _toUnit = 'Fahrenheit';
  double _result = 0.0;
  String _formula = '';
  bool _hasConverted = false;

  final List<String> _units = ['Celsius', 'Fahrenheit', 'Kelvin', 'Reamur'];

  void _convertTemperature() {
    if (_temperatureController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masukkan nilai suhu')),
      );
      return;
    }

    final double temperature = double.parse(_temperatureController.text);
    double celsius = 0.0;
    String fromFormula = '';

    // Konversi ke Celsius sebagai satuan perantara
    switch (_fromUnit) {
      case 'Celsius':
        celsius = temperature;
        fromFormula = '$temperature°C';
        break;
      case 'Fahrenheit':
        celsius = (temperature - 32) * 5 / 9;
        fromFormula = '($temperature°F - 32) × 5/9 = ${celsius.toStringAsFixed(2)}°C';
        break;
      case 'Kelvin':
        celsius = temperature - 273.15;
        fromFormula = '$temperature K - 273.15 = ${celsius.toStringAsFixed(2)}°C';
        break;
      case 'Reamur':
        celsius = temperature * 5 / 4;
        fromFormula = '$temperature°R × 5/4 = ${celsius.toStringAsFixed(2)}°C';
        break;
    }

    // Konversi dari Celsius ke satuan target
    double result = 0.0;
    String toFormula = '';

    switch (_toUnit) {
      case 'Celsius':
        result = celsius;
        toFormula = _fromUnit == 'Celsius' ? '$temperature°C' : '${celsius.toStringAsFixed(2)}°C';
        break;
      case 'Fahrenheit':
        result = celsius * 9 / 5 + 32;
        toFormula = _fromUnit == 'Fahrenheit' ? '$temperature°F' : '(${celsius.toStringAsFixed(2)}°C × 9/5) + 32 = ${result.toStringAsFixed(2)}°F';
        break;
      case 'Kelvin':
        result = celsius + 273.15;
        toFormula = _fromUnit == 'Kelvin' ? '$temperature K' : '${celsius.toStringAsFixed(2)}°C + 273.15 = ${result.toStringAsFixed(2)} K';
        break;
      case 'Reamur':
        result = celsius * 4 / 5;
        toFormula = _fromUnit == 'Reamur' ? '$temperature°R' : '${celsius.toStringAsFixed(2)}°C × 4/5 = ${result.toStringAsFixed(2)}°R';
        break;
    }

    String displayFormula = '';
    if (_fromUnit == _toUnit) {
      displayFormula = '$temperature° ${_getUnitSymbol(_fromUnit)}';
    } else if (_fromUnit == 'Celsius' || _toUnit == 'Celsius') {
      displayFormula = toFormula;
    } else {
      displayFormula = '$fromFormula → $toFormula';
    }

    setState(() {
      _result = result;
      _formula = displayFormula;
      _hasConverted = true;
    });
  }

  String _getUnitSymbol(String unit) {
    switch (unit) {
      case 'Celsius':
        return 'C';
      case 'Fahrenheit':
        return 'F';
      case 'Kelvin':
        return 'K';
      case 'Reamur':
        return 'R';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input field
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Masukkan Nilai Suhu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _temperatureController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: 'Contoh: 32',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // From Unit selection
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dari',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _fromUnit,
                            items: _units.map((String unit) {
                              return DropdownMenuItem<String>(
                                value: unit,
                                child: Text(unit),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  _fromUnit = value;
                                  if (_hasConverted) {
                                    _convertTemperature();
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // To Unit selection
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ke',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _toUnit,
                            items: _units.map((String unit) {
                              return DropdownMenuItem<String>(
                                value: unit,
                                child: Text(unit),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  _toUnit = value;
                                  if (_hasConverted) {
                                    _convertTemperature();
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Convert button
              ElevatedButton(
                onPressed: _convertTemperature,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'KONVERSI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Result card
              if (_hasConverted)
                Card(
                  elevation: 2,
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'HASIL KONVERSI',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${_result.toStringAsFixed(2)}° ${_getUnitSymbol(_toUnit)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _formula,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }
}