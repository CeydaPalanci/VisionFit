import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visio_fit/config/app_config.dart';
import 'package:visio_fit/pages/login/login_page.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // backend'de Username olarak kullanılıyor
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 100, 30, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color(0xFF5A7B9A),
                    Color(0xFFCFB6B6),
                    Color(0xFF9BBEAA),
                  ],
                ).createShader(bounds),
                child: Text("Sign Up",
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
              SizedBox(height: 50),
              // Email TextField
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Name",
                ),
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Surname",
                ),
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                ),
              ),

              SizedBox(height: 20),

              // Password TextField
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Password",
                ),
              ),

              SizedBox(height: 20),

              // Login Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF789DBC),
                    Color(0xFFFFE3E3),
                    Color(0xFFC9E9D2),
                  ]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final url = Uri.parse(AppConfig.registerEndpoint);

                      final response = await http.post(
                        url,
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({
                          'username': _emailController.text.trim(),
                          'password': _passwordController.text.trim(),
                          'name': _nameController.text.trim(),
                          'surname': _surnameController.text.trim(),
                        }),
                      );

                      if (response.statusCode == 200) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('userEmail', _emailController.text.trim());
                        await prefs.setString('userFirstName', _nameController.text.trim());
                        await prefs.setString('userLastName', _surnameController.text.trim());
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Kayıt başarılı')),
                        );
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Kayıt başarısız: ${response.body}')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bir hata oluştu: $e')),
                      );
                    }
                  },
                  child: Text('Kayıt Ol'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ),

              SizedBox(height: 20),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hesabınız var mı?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text('Giriş Yap'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
