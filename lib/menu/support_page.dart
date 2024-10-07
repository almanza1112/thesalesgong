import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Support'),
          elevation: 0,
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(30, 58, 138, 1),
                  Color.fromRGBO(79, 70, 229, 1)
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(30, 58, 138, 1),
                Color.fromRGBO(79, 70, 229, 1)
              ],
            ),
          ),
          child: SafeArea(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                      'Email us at hello@thesalesgong.com or send us a message below.',
                      style: TextStyle(color: Colors.white)),
                  const Spacer(),
                  TextFormField(
                    controller: _messageController,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Message',
                      labelStyle: const TextStyle(color: Colors.white),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a message';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: const Color.fromRGBO(34, 197, 94, 1),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    onPressed: _sendMessage,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("SEND MESSAGE"),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          )),
        ));
  }

  void _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Get the current user's email and timestamp
      final userEmail = FirebaseAuth.instance.currentUser!.email;
      DateTime now = DateTime.now();

      String formattedDate = "${now.month}/${now.day}/${now.year}";
      String formattedTime = _formatTime(now);

      // Define your HTML content for the email
      String emailContent = """
    <h2>Support Request</h2>
    <p><strong>From:</strong> $userEmail</p>
    <p><strong>Date:</strong> $formattedDate</p>
    <p><strong>Time:</strong> $formattedTime</p>    
    <p><strong>Message:</strong></p>
    <p>${_messageController.text}</p>
    <hr>
    <p>Thank you for reaching out to support!</p>
    """;

      FirebaseFirestore.instance
          .collection("mail")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'to': 'hello@thesalesgong.com',
        'message': {
          'subject': 'Support Request',
          'html': emailContent, // Use the improved HTML content
        },
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Message sent successfully'),
        ));
        _messageController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to send message'),
        ));
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

// Function to format the time with AM/PM
  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String amPm = hour >= 12 ? 'PM' : 'AM';

    // Convert hour to 12-hour format
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour; // Adjust for midnight and noon

    // Add leading zero to minutes if necessary
    String minuteStr = minute < 10 ? '0$minute' : minute.toString();

    return "$hour:$minuteStr $amPm";
  }
}
