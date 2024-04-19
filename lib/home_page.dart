import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile - Task 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Flutter App',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 20.0),
            MyButton(),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  Future<void> _fetchUniversities(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(
          'http://universities.hipolabs.com/search?country=United+States'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Display data in a list view
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Universities in the United States",
                style: Theme.of(context).textTheme.headline6,
              ),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        data[index]['name'],
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      subtitle: Text(
                        data[index]['country'],
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to load universities');
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to fetch universities: $error"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _fetchUniversities(context);
      },
      child: Text('Fetch Universities'),
    );
  }
}