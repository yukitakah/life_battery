import 'package:flutter/material.dart';
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
  // DateTime _birthday = DateTime.now(); // default date is today
  DateTime _birthday = DateTime.now().subtract(const Duration(
      days: 365 * 25)); // default date is 25 years ago from today
  final TextEditingController _lifeExpectancyController =
      TextEditingController();
  double _percentage = 0.0;

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
        _calculatePercentage();
      });
    }
  }

  _calculatePercentage() {
    double? lifeExpectancy = double.tryParse(_lifeExpectancyController.text);
    if (lifeExpectancy == null || lifeExpectancy <= 0) {
      _showError('Please enter a valid number for life expectancy.');
      return;
    }

    double currentYear = DateTime.now().year.toDouble();
    double age = currentYear - _birthday.year.toDouble();
    if (age > lifeExpectancy) {
      _showError('Your age is greater than your life expectancy.');
      return;
    }

    setState(() {
      _percentage = age / lifeExpectancy;
    });
  }

  _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: Theme.of(context).textTheme.bodyLarge),
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
              width: 200,
              child: TextField(
                controller: _lifeExpectancyController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onSubmitted: (_) => _calculatePercentage(),
                decoration: InputDecoration(
                  labelText: "Life expectancy",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
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
    );
  }
}
