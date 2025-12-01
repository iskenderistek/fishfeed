import 'package:flutter/material.dart';

void main() {
  runApp(const FeedCalcApp());
}

class FeedCalcApp extends StatelessWidget {
  const FeedCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yem Hesaplama',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const FeedCalcScreen(),
    );
  }
}

class FeedCalcScreen extends StatefulWidget {
  const FeedCalcScreen({super.key});

  @override
  State<FeedCalcScreen> createState() => _FeedCalcScreenState();
}

class _FeedCalcScreenState extends State<FeedCalcScreen> {
  final TextEditingController _biomassController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final List<String> _speciesOptions = const ['Somon', 'Levrek', 'Çipura'];

  String? _selectedSpecies = 'Somon';
  double? _dailyFeed;
  String? _feedWarning;
  String? _resultText;

  @override
  void dispose() {
    _biomassController.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

  double _getFeedRate(String species, double temperature) {
    if (temperature <= 8) {
      return 0.5;
    }
    if (temperature >= 18) {
      return 1.0;
    }

    switch (species) {
      case 'Levrek':
        return 1.5;
      case 'Çipura':
        return 1.3;
      default:
        return 1.2;
    }
  }

  void _calculateFeed() {
    final double? biomass = double.tryParse(_biomassController.text.replaceAll(',', '.'));
    final double? temp = double.tryParse(_temperatureController.text.replaceAll(',', '.'));
    final String? species = _selectedSpecies;

    if (biomass == null || temp == null || species == null) {
      setState(() {
        _dailyFeed = null;
        _feedWarning = 'Lütfen geçerli değerler girin.';
        _resultText = null;
      });
      return;
    }

    final String speciesLower = species.toLowerCase();
    final bool isSalmon = speciesLower.contains('somon') || speciesLower.contains('salmon');
    final bool badTemp = temp > 18 || temp < 4;

    final double feedRate = _getFeedRate(species, temp);

    final String baseResult =
        'Tür: $species\nBiyokitle: ${biomass.toStringAsFixed(2)} kg\nSıcaklık: ${temp.toStringAsFixed(1)} °C\nÖnerilen yem oranı: ${feedRate.toStringAsFixed(1)} %';

    if (isSalmon && badTemp) {
      setState(() {
        _dailyFeed = null;
        _feedWarning = 'Somon için bu su sıcaklığında yemleme önerilmez.';
        _resultText = baseResult;
      });
      return;
    }

    final double dailyFeed = biomass * feedRate / 100;

    setState(() {
      _dailyFeed = dailyFeed;
      _feedWarning = null;
      _resultText = baseResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yem Hesaplama'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _biomassController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Toplam biyokütle (kg)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _temperatureController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Su sıcaklığı (°C)',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: _selectedSpecies,
              items: _speciesOptions
                  .map(
                    (species) => DropdownMenuItem<String>(
                      value: species,
                      child: Text(species),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSpecies = value;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateFeed,
                child: const Text('Hesapla'),
              ),
            ),
            const SizedBox(height: 24),
            if (_feedWarning != null)
              Text(
                _feedWarning!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (_dailyFeed != null)
              Text('Günlük yem miktarı: ${_dailyFeed!.toStringAsFixed(2)} kg'),
            const SizedBox(height: 12),
            if (_resultText != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Text(
                  [
                    _resultText!,
                    if (_feedWarning != null)
                      'Günlük yem: $_feedWarning'
                    else if (_dailyFeed != null)
                      'Günlük yem: ${_dailyFeed!.toStringAsFixed(2)} kg'
                  ].join('\n'),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
