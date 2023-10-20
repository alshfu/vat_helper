import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vat_helper/localization.dart';

class RUTCalculator extends StatefulWidget {
  @override
  _RUTCalculatorState createState() => _RUTCalculatorState();
}

class _RUTCalculatorState extends State<RUTCalculator> {
  final priceInkVatBeforeRutController = TextEditingController();
  final priceExVatBeforeRutController = TextEditingController();
  final rutAmountController = TextEditingController();
  final vatAmountController = TextEditingController();
  final priceAfterRutController = TextEditingController();

  double vatRate = 25.0; // Default VAT rate in %
  double priceInkVatBeforeRut = 0.0;
  double priceExVatBeforeRut = 0.0;
  double rutAmount = 0.0;
  double vatAmount = 0.0;
  double priceAfterRut = 0.0;
  double rutRate = 30.0; // Default RUT rate in %

  List<double> rutRates = [50.0, 30.0];


  @override
  void dispose() {
    priceInkVatBeforeRutController.dispose();
    priceExVatBeforeRutController.dispose();
    rutAmountController.dispose();
    vatAmountController.dispose();
    priceAfterRutController.dispose();
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
            value: rutRate.toString(),
            items: rutRates.map<DropdownMenuItem<String>>((double value) {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  // Отступы слева и справа
                  child: Text(
                    loc.translate('chose_your_rut_rate') +
                        ' (${value.toStringAsFixed(0)} %)',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              );
            }).toList(),
          onChanged: (value) async {
            setState(() {
              rutRate = double.tryParse(value!) ?? 0.0;
              calculateValuesFromRut();
            });
          }



          ),
          SizedBox(height: 8.0),
          TextField(
            controller: priceInkVatBeforeRutController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: loc.translate('enter_price_including_vat'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onChanged: (value) {
              setState(() {
                priceInkVatBeforeRut = double.tryParse(value) ?? 0.0;
                calculateValuesFromPriceInkVat();
              });
            },
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: priceExVatBeforeRutController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: loc.translate('enter_price_excluding_vat'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onChanged: (value) {
              setState(() {
                priceExVatBeforeRut = double.tryParse(value) ?? 0.0;
                calculateValuesFromPriceExVat();
              });
            },
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: vatAmountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: loc.translate('enter_vat_amount'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onChanged: (value) {
              setState(() {
                vatAmount = double.tryParse(value) ?? 0.0;
                calculateValuesFromVat();
              });
            },
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: rutAmountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: loc.translate('enter_rut_amount'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onChanged: (value) {
              setState(() {
                rutAmount = double.tryParse(value) ?? 0.0;
                calculateValuesFromRut();
              });
            },
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: priceAfterRutController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: loc.translate('enter_price_after_rut'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onChanged: (value) {
              setState(() {
                priceAfterRut = double.tryParse(value) ?? 0.0;
                calculateValuesFromPriceAfterRut();
              });
            },
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  void calculateValuesFromPriceInkVat() {
    priceExVatBeforeRut = priceInkVatBeforeRut / (1 + vatRate / 100);
    vatAmount = priceInkVatBeforeRut - priceExVatBeforeRut;
    rutAmount = priceExVatBeforeRut * rutRate / 100;
    priceAfterRut = priceInkVatBeforeRut - rutAmount;

    priceExVatBeforeRutController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(priceExVatBeforeRut);
    vatAmountController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(vatAmount);
    rutAmountController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(rutAmount);
    priceAfterRutController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(priceAfterRut);
  }

  void calculateValuesFromPriceExVat() {
    priceInkVatBeforeRut = priceExVatBeforeRut * (1 + vatRate / 100);
    vatAmount = priceInkVatBeforeRut - priceExVatBeforeRut;
    rutAmount = priceExVatBeforeRut * rutRate / 100;
    priceAfterRut = priceInkVatBeforeRut - rutAmount;

    priceInkVatBeforeRutController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(priceInkVatBeforeRut);
    vatAmountController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(vatAmount);
    rutAmountController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(rutAmount);
    priceAfterRutController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(priceAfterRut);
  }

  void calculateValuesFromVat() {
    if (vatRate != -1.0) {
      priceExVatBeforeRut = vatAmount / (vatRate / 100);
      priceInkVatBeforeRut = priceExVatBeforeRut + vatAmount;
      rutAmount = priceInkVatBeforeRut * rutRate / 100;
      priceAfterRut = priceInkVatBeforeRut - rutAmount;

      priceExVatBeforeRutController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(priceExVatBeforeRut);
      priceInkVatBeforeRutController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(priceInkVatBeforeRut);
      rutAmountController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(rutAmount);
      priceAfterRutController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(priceAfterRut);
    }
  }

  void calculateValuesFromRut() {
    if (rutRate != -1.0){
      priceInkVatBeforeRut = rutAmount / (rutRate / 100);
      priceExVatBeforeRut = priceInkVatBeforeRut / (1 + vatRate / 100);
      vatAmount = priceInkVatBeforeRut - priceExVatBeforeRut;
      priceAfterRut = priceInkVatBeforeRut - rutAmount;

      priceExVatBeforeRutController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(priceExVatBeforeRut);
      priceInkVatBeforeRutController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(priceInkVatBeforeRut);
      vatAmountController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(vatAmount);
      priceAfterRutController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(priceAfterRut);
    }
  }

  void calculateValuesFromPriceAfterRut() {
     if (rutRate != -1.0){
      priceInkVatBeforeRut = priceAfterRut / (1 - rutRate / 100);
      priceExVatBeforeRut = priceInkVatBeforeRut / (1 + vatRate / 100);
      vatAmount = priceInkVatBeforeRut - priceExVatBeforeRut;
      rutAmount = priceInkVatBeforeRut * rutRate / 100;


      priceExVatBeforeRutController.text = NumberFormat.simpleCurrency( locale: Localizations.localeOf(context).toString()).format(priceExVatBeforeRut);
      priceInkVatBeforeRutController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(priceInkVatBeforeRut);
      vatAmountController.text = NumberFormat.simpleCurrency( locale: Localizations.localeOf(context).toString()).format(vatAmount);
      rutAmountController.text = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(rutAmount);
    }
  }




}
