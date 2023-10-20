// main.dart
import 'package:flutter/material.dart';
import 'package:vat_helper/rut_calculator.dart';
import 'package:vat_helper/about.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vat_helper/localization.dart';
import 'package:vat_helper/vat_calculator_state.dart';

void main() {
  runApp(const EconoMaster());
}

class EconoMaster extends StatelessWidget {
  const EconoMaster({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('sv', ''),

      ],
      theme: ThemeData(
        primaryColor: Colors.blue, // Основной цвет для AppBar
        hintColor: Colors.blueAccent, // Дополнительный цвет для акцентов
      ),
      home: LayoutBuilder(
        builder: (context, constraints) {
          return const EconoMasterHome();
        },
      ),
    );
  }
}

class EconoMasterHome extends StatefulWidget {
  const EconoMasterHome({Key? key}) : super(key: key);

  @override
  _EconoMasterHomeState createState() => _EconoMasterHomeState();
}

class _EconoMasterHomeState extends State<EconoMasterHome> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EconoMaster'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calculate), text: 'VAT Calculator'),
              Tab(icon: Icon(Icons.account_balance_wallet), text: 'RUT Calculator'),
              Tab(icon: Icon(Icons.info), text: 'About')
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                VATCalculator(),
                RUTCalculator(),
                About(),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Transform.rotate(
                angle: -0.1,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '(Beta)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
