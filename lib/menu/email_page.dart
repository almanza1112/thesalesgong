import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailPage extends StatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _editEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Make the HTTP POST request to edit the email content
      final response = await http.post(
        Uri.parse('https://example.com/edit-email'),
        body: {
          'email': _emailController.text,
        },
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Email edited successfully
        // TODO: Handle the response data
      } else {
        // Error occurred while editing email
        // TODO: Handle the error
      }
    } catch (e) {
      // Error occurred while making the HTTP request
      // TODO: Handle the error
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _editEmail,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Edit Email'),
            ),
          ],
        ),
      ),
    );
  }
}
