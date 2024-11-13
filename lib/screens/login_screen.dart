import 'package:flutter/material.dart';
import 'package:schumacher/widgets/login_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            const Expanded(
              flex: 3,
              child: SizedBox(),
            ),
            const Expanded(
              flex: 5,
              child: Center(
                child: Card(
                  child: LoginCard(),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(),
            ),
          ],
        )
      )
    );
  }
}