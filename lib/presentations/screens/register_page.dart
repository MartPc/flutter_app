import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentations/screens/main_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    //Textfields Controllers

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String rol = "Administrador";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isVisible = true;

  final String url = 'https://api-libros-pfwj.onrender.com/api/users';

  void signUp() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    final body = jsonEncode(
        {
        'nombre': name,
        'correo': email, 
        'contrasena': password,
        'rol' : rol
        });

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: body);

    response.statusCode == 201
        ? Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainPage()))
        : showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  title: Center(
                    child: const Text(
                      'ERROR',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  content: const Text(
                    'Error de registro',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cerrar',
                          style: TextStyle(
                            fontSize: 20
                          ),
                          ))
                  ],
                ),
              );
            });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 75),
                //Logo
                Icon(
                  Icons.adb,
                  size: 100,
                ),
                SizedBox(height: 75),

                //Text Welcome
                Text(
                  'Countech',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Bievenido, inicia sesión',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 50),

                //Email textfield
                
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un correo';
                            }
                            return null;
                            },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color.fromARGB(255, 58, 130, 245)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: 'Correo electrónico',
                              fillColor: Colors.grey[200],
                              filled: true,
                              prefixIcon: Icon(Icons.email_outlined)),
                        ),
                      ),
                
                SizedBox(height: 10),

                //Password textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa una contraseña';
                            }
                            return null;
                            },
                    obscureText: _isVisible,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 58, 130, 245)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Contraseña',
                      fillColor: Colors.grey[200],
                      filled: true,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          icon: _isVisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                //Sign in button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ElevatedButton(
                    onPressed: (){
                  if (_formKey.currentState!.validate()) {
                  signUp();
                }
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'Ingresar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
                ),
                ),
                SizedBox(height: 25),

                //Not a member? Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Sin registrar?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' Registrar ahora',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ))
    );
  }
}