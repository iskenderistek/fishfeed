import 'dart:io';

/// Basit bir somon yem hesaplama uygulaması.
/// Kullanıcıdan toplam biyokütle (kg) ve günlük yemleme oranı (%) alır
/// ve gerekli günlük yem miktarını hesaplar.
void main() {
  stdout.write('Toplam bal\u0131k biyok\u00fctlesi (kg): ');
  String? biomassInput = stdin.readLineSync();

  stdout.write('G\u00fcnl\u00fck yemleme oran\u0131 (%): ');
  String? feedRateInput = stdin.readLineSync();

  double? biomass = double.tryParse(biomassInput ?? '');
  double? feedRate = double.tryParse(feedRateInput ?? '');

  if (biomass == null || feedRate == null) {
    print('Ge\u00e7ersiz giri\u015f');
    exit(1);
  }

  double feed = biomass * feedRate / 100;
  print('G\u00fcnl\u00fck yem miktar\u0131: ${feed.toStringAsFixed(2)} kg');
}
