// main.dart
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'menu.dart'; // Importamos la clase HomePage desde el archivo home_page.dart

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _identificacionController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String identificacion = _identificacionController.text;
    String password = _passwordController.text;

    var url = Uri.parse(
        'https://backend-sistema-referidos.onrender.com/api/usuario/login');

    try {
      // Realizar la solicitud POST a la API
      var response = await http.post(
        url,
        body: {
          'identificacion': identificacion,
          'password': password,
        },
      );

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        jsonDecode(response.body);

        // Aquí puedes manejar la respuesta de la API según lo necesites
        // Por ejemplo, guardar token de sesión, etc.

        // Navegar a la siguiente pantalla si el inicio de sesión fue exitoso
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Menu()),
        );
      } else {
        // Manejar caso de error (por ejemplo, mostrar un mensaje de error)
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error de inicio de sesión'),
              content:
                  const Text('Credenciales inválidas. Inténtalo de nuevo.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _identificacionController,
              decoration: const InputDecoration(
                labelText: 'Identificacion',
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
