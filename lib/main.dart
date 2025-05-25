import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Tester',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ApiTestPage(),
    );
  }
}

class ApiTestPage extends StatefulWidget {
  @override
  _ApiTestPageState createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  TextEditingController _urlController = TextEditingController();
  String _response = '';
  bool _loading = false;

  Future<void> _callApi() async {
    setState(() {
      _loading = true;
      _response = '';
    });

    try {
      final url = Uri.parse(_urlController.text.trim());
      final result = await http.get(url);

      setState(() {
        _response = result.body;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Tester"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: "Enter API URL",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _callApi,
              child: _loading ? CircularProgressIndicator() : Text("Call API"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  _response,
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
