import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;

class NamePage extends StatefulWidget {
  const NamePage({super.key});
  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();
  bool _isLoading = false;

  @override
  void initState() {
    _nameController.text = FirebaseAuth.instance.currentUser!.displayName!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Name'),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: const TextStyle(color: Colors.white),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: Colors.grey), // Color when not focused
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: Colors.white), // Color when focused
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }

                        if (value.trim() ==
                            FirebaseAuth.instance.currentUser!.displayName!) {
                          return 'Please enter a different name';
                        }
                        return null;
                      },
                    ),
                    const Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: const Color.fromRGBO(34, 197, 94, 1),
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder()),
                      onPressed: _updateName,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("UPDATE NAME"),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _updateName() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      var body = {
        "new_name": _nameController.text,
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "team_ID": await storage.read(key: globals.FSS_TEAM_ID),
        "email": FirebaseAuth.instance.currentUser!.email
      };
      http.Response response = await http.post(
          Uri.parse("${globals.END_POINT}/account/change_name"),
          body: body);

      if (response.statusCode == 201) {
        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(_nameController.text);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Name updated successfully'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else if (response.statusCode == 500) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('There is an unexpected error. Please try again.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
