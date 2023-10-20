import 'package:flutter/material.dart';

import 'package:vat_helper/localization.dart';
import 'package:intl/intl.dart';

class VATCalculator extends StatefulWidget {
  @override
  VATCalculatorState createState() => VATCalculatorState();
}



class VATCalculatorState extends State<VATCalculator> {
  final priceExVatController = TextEditingController();
  final vatAmountController = TextEditingController();
  final priceIncVatController = TextEditingController();


  double vatRate = 25.0; // Default VAT rate in %
  double priceExVat = 0.0;
  double vatAmount = 0.0;
  double priceIncVat = 0.0;

  List<double> vatRates = [25.0, 12.0, 6.0];


  @override
  void dispose() {
    priceExVatController.dispose();
    vatAmountController.dispose();
    priceIncVatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DropdownButton<String>(
            isExpanded: true,
            value: vatRate.toString(),
            items: vatRates.map<DropdownMenuItem<String>>((double value) {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  // Отступы слева и справа
                  child: Text(
                    loc.translate('chose_your_vat_rate') +
                        ' (${value.toStringAsFixed(0)} %)',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              );
            }).toList()
              ..add(DropdownMenuItem(
                child: Text(
                  loc.translate('enter_custom_VAT_rate_value'),
                  textAlign: TextAlign.left,
                  style:
                  TextStyle(color: Colors.blue), // Установка цвета текста
                ),
                value: '-1.0',
              )),
            onChanged: (value) async {
              if (value == '-1.0') {
                var customRate = await _showCustomVatRateDialog(context);
                if (customRate != null) {
                  setState(() {
                    vatRate = customRate;
                    if (!vatRates.contains(customRate)) {
                      vatRates.add(customRate);
                    }
                    calculateValuesFromVatRateAndPriceExVat();
                  });
                }
              } else {
                setState(() {
                  vatRate = double.tryParse(value ?? '25.0') ?? 25.0;
                  calculateValuesFromVatRateAndPriceExVat();
                });
              }
            },


          ),
          SizedBox(height: 8.0),
          Text(loc.translate('description_for_price_excluding_vat')),
          SizedBox(height: 4.0),
          TextField(
            controller: priceExVatController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: loc.translate('enter_price_excluding_vat'),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onChanged: (value) {
              setState(() {
                priceExVat = double.tryParse(value) ?? 0.0;
                calculateValuesFromVatRateAndPriceExVat();
              });
            },
          ),
          SizedBox(height: 8.0),
          Text(loc.translate('description_for_vat_amount')),
          SizedBox(height: 4.0),
          TextField(
            controller: vatAmountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: loc.translate('enter_vat_amount'),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onChanged: (value) {
              setState(() {
                vatAmount = double.tryParse(value) ?? 0.0;
                calculateValuesFromVatAmount();
              });
            },
          ),
          SizedBox(height: 8.0),
          Text(loc.translate('description_for_price_including_vat')),
          SizedBox(height: 4.0),
          TextField(
            controller: priceIncVatController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: loc.translate('enter_price_including_vat'),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onChanged: (value) {
              setState(() {
                priceIncVat = double.tryParse(value) ?? 0.0;
                calculateValuesFromPriceIncVat();
              });
            },
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  void calculateValuesFromVatRateAndPriceExVat() {
    vatAmount = priceExVat * vatRate / 100;
    priceIncVat = priceExVat + vatAmount;

    vatAmountController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(vatAmount);
    priceIncVatController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(priceIncVat);
  }

  void calculateValuesFromVatAmount() {
    if (vatRate != -1.0) {
      priceExVat = vatAmount / (vatRate / 100);
      priceIncVat = priceExVat + vatAmount;

      priceExVatController.text = priceExVat.toStringAsFixed(2);
      priceIncVatController.text = priceIncVat.toStringAsFixed(2);
    }
  }

  void calculateValuesFromPriceIncVat() {
    if (vatRate != -1.0) {
      priceExVat = priceIncVat / (1 + vatRate / 100);
      vatAmount = priceIncVat - priceExVat;

      priceExVatController.text = priceExVat.toStringAsFixed(2);
      vatAmountController.text = vatAmount.toStringAsFixed(2);
    }
  }
  
  Future<double?> _showCustomVatRateDialog(BuildContext context) async {
    var controller = TextEditingController();
    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Введите произвольный НДС'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'НДС',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ОК'),
              onPressed: () {
                var customRate = double.tryParse(controller.text);
                if (customRate != null && customRate >= 0) {
                  Navigator.of(context).pop(customRate);
                } else {
                  // показать ошибку, если ввод недействителен
                }
              },
            ),
          ],
        );
      },
    );
  }

}
