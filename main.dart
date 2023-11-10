import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _sliderValue = 1;
  StreamController<int> _streamController = StreamController<int>.broadcast();
  List<int> _history = [];

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  int calculateFactorial(int n) {
    if (n == 0 || n == 1) {
      return 1;
    } else {
      return n * calculateFactorial(n - 1);
    }
  }

  void _updateFactorial() {
    int factorial = calculateFactorial(_sliderValue.toInt());
    _streamController.sink.add(factorial);
    _history.add(factorial);
  }

  void _showHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lịch sử'),
          content: Column(
            children: _history.map((factorial) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(factorial.toString()),
                ),
              );
            }).toList(),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giai thừa'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoSlider(
              min: 1,
              max: 10,
              value: _sliderValue,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Tìm giai thừa'),
              onPressed: _updateFactorial,
            ),
            SizedBox(height: 10),
            StreamBuilder<int>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Giai thừa của $_sliderValue là ${snapshot.data}',
                    style: TextStyle(fontSize: 20),
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Lịch sử'),
              onPressed: _showHistory,
            ),
          ],
        ),
      ),
    );
  }
}
