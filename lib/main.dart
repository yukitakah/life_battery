import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeBattery',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 25.0, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 20.0, color: Colors.black),
        ),
      ),
      home: const MyHomePage(title: 'LifeBattery🔋 v1.0.0'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _birthday = DateTime.now().subtract(const Duration(
      days: 365 * 25)); // default date is 25 years ago from today
  int _lifeExpectancy = 70; // initialize with a sensible default
  int _validExpectancy = 70; // initialize with a sensible default
  double _percentage = 0.0;
  bool _hasError = false;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthday) {
      setState(() {
        _birthday = picked;
      });
      _calculatePercentage(_validExpectancy);
    }
  }

  void _calculatePercentage(int lifeExpectancy) {
    double ageInDays = DateTime.now().difference(_birthday).inDays.toDouble();
    double ageInYears = ageInDays /
        365.25; // consider a year as 365.25 days on average to account for leap years

    if (ageInYears > lifeExpectancy) {
      _showError('Your age is greater than your life expectancy.');
      setState(() {
        _hasError = true;
      });
    } else {
      setState(() {
        _hasError = false;
        _validExpectancy =
            _lifeExpectancy; // set validExpectancy to the value selected in the picker
        _percentage = ageInYears / lifeExpectancy;
      });
    }
  }

  void _showError(String message) {
    if (_hasError) {
      _scaffoldMessengerKey.currentState?.clearSnackBars();
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),  // the duration
        ),
      );
    } else {
      // a delay equal to the SnackBar's duration
      Future.delayed(const Duration(seconds: 2), () {
        _scaffoldMessengerKey.currentState?.clearSnackBars();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(widget.title, style: Theme.of(context).textTheme.bodyLarge),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Birthday: ${DateFormat('MMMM dd, yyyy').format(_birthday)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text('Select birthday'),
              ),
              const SizedBox(height: 10),
              Text(
                'I will live up to',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150.0,
                child: CupertinoPicker(
                  itemExtent: 30.0,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _lifeExpectancy =
                          index + 1; // assuming the lowest expectancy to be 1
                    });
                    _calculatePercentage(_lifeExpectancy);
                  },
                  children: List<Widget>.generate(
                      150,
                      (index) => Text(
                          '${index + 1}')), // assuming the highest expectancy to be 150
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Remaining life percentage:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: 1 - _percentage,
                minHeight: 20,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(height: 10),
              Text(
                '${(100 - _percentage * 100).toStringAsFixed(2)}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
