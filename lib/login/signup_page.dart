import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    backgroundColor: const Color.fromRGBO(34, 197, 94, 1),
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(
                        side: BorderSide(
                            color: Color.fromRGBO(34, 197, 94, 1), width: 1)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin_signup');
                  },
                  child: const Text("ADMIN"),
                ),
            ),
            
            const SizedBox(
              width: 16,
            ),

            SizedBox(
              height: 150,
              width: 150,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(36),
                    backgroundColor: const Color.fromRGBO(34, 197, 94, 1),
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(
                        side: BorderSide(
                            color: Color.fromRGBO(34, 197, 94, 1), width: 1)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/team_member_signup');
                  },
                  child: const Text("TEAM MEMBER", textAlign: TextAlign.center,),
                ),
            ),
            
          ],
        ),
      ),
    );
  }
}
