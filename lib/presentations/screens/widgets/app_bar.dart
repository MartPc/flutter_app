import 'package:flutter/material.dart';
import 'package:flutter_app/presentations/screens/login_page.dart';

class AppBarRegister extends StatefulWidget implements PreferredSizeWidget {
  final title;
  const AppBarRegister({super.key, required this.title});

  @override
  State<AppBarRegister> createState() => _AppBarRegisterState();

   @override
  Size get preferredSize => const Size.fromHeight(50.0);
}

class _AppBarRegisterState extends State<AppBarRegister> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_sharp),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              tooltip: 'Volver',
            );
          },
        ),
      ),
    );
  }
}