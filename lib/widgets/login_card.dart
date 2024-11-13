import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schumacher/const/constant.dart';
import 'package:schumacher/widgets/custom_card_widget.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard>{

  final auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool _isPasswordVisible = false;
  bool isLogin = true;

  @override
  Widget build (BuildContext context)
  {
    return SizedBox(
      width: 300.0,
      height: 600.0,
      child: CustomCard(
        child: Column(     
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipOval(
              child: Image.asset(
                'images/minion.jpg',
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              )
            ),
            Text(
              isLogin ? 'LOGIN' : 'REGISTER',
              style: GoogleFonts.honk(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              style: GoogleFonts.notoSans(
                fontSize: 14.0,
                fontWeight: FontWeight.w300
              ),
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            TextField(
              style: GoogleFonts.notoSans(
                fontSize: 14.0,
                fontWeight: FontWeight.w300
              ),
              onChanged: (value) {
                password = value;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            if (!isLogin)
              TextField(
                style: GoogleFonts.notoSans(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300
                ),
                onChanged: (value) {
                  confirmPassword = value;
                },
                obscureText: !_isPasswordVisible,
                decoration: const InputDecoration(
                  hintText: 'Confirm your password',
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                backgroundColor: bluePrimaryColour,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              onPressed: () async {
                try {
                  if (isLogin)
                  {
                    await auth.signInWithEmailAndPassword(email: email, password: password);
                    if (context.mounted) {
                      Navigator.pushNamed(context, '/main');
                    }
                  } else {
                    if(password == confirmPassword)
                    {
                      await auth.createUserWithEmailAndPassword(email: email, password: password);
                      if (context.mounted) {
                        Navigator.pushNamed(context, '/main');
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Passwords do not match'),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if(context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                }
              },
              child: Text(
                isLogin ? 'Login'  : 'Create Account',
                style: const TextStyle(
                  color: Colors.white
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              }, 
              child: Text(isLogin ? 'Make an account' : 'Already have an account'),
            ),
          ],
        ),
      ),
    );
  }
}