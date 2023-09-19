import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentations/screens/login_page.dart';
import 'package:http/http.dart' as http;

List<String> titles = <String>[
  'Usuarios',
  'Producción',
];

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<dynamic> users = [];
  String editedEstado = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> editUser(Map<String, dynamic> userData) async {
    Map<String, dynamic> editedData = {...userData};
    editedEstado = userData['estado'];

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: const Text(
              'Editar Usuario',
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  onChanged: (value) {
                    editedData['nombre'] = value;
                  },
                  controller: TextEditingController(text: userData['nombre']),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Correo'),
                  onChanged: (value) {
                    editedData['correo'] = value;
                  },
                  controller: TextEditingController(text: userData['correo']),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: editedEstado.isNotEmpty
                        ? editedEstado
                        : userData['estado'],
                    items: <String>['Activo', 'Inactivo']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        editedEstado = newValue!;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.put(
                  Uri.parse(
                      'https://api-libros-pfwj.onrender.com/api/users/${userData['_id']}'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'nombre': editedData['nombre'],
                    'correo': editedData['correo'],
                    'estado': editedEstado,
                  }),
                );

                if (response.statusCode == 200) {
                  fetchUsers();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  // Manejar errores de actualización
                  throw Exception('Error al actualizar el usuario');
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchUsers() async {
    final response = await http
        .get(Uri.parse('https://api-libros-pfwj.onrender.com/api/users'));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar la lista de usuarios');
    }
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(
      Uri.parse('https://api-libros-pfwj.onrender.com/api/users/$userId'),
    );
    if (response.statusCode == 204) {
      fetchUsers();
    } else {
      throw Exception('Error al eliminar el usuario');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    const int tabsCount = 2;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: DefaultTabController(
        initialIndex: 1,
        length: tabsCount,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Countech'),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(child: Text('Cerrar Sesión')),
                        content: Text('¿Estás seguro de cerrar sesión?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: Text('Aceptar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
            automaticallyImplyLeading: false,
            notificationPredicate: (ScrollNotification notification) {
              return notification.depth == 1;
            },
            scrolledUnderElevation: 4.0,
            shadowColor: Theme.of(context).shadowColor,
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: const Icon(Icons.account_circle_sharp),
                  text: titles[0],
                ),
                Tab(
                  icon: const Icon(Icons.bar_chart_outlined),
                  text: titles[1],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user['nombre']),
                    subtitle: Text(user['correo']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            editUser(user);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                      child: const Text('Eliminar Usuario')),
                                  content: const Text(
                                      '¿Seguro que deseas eliminar este usuario?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteUser(user['_id']);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListView.builder(
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    tileColor: index.isOdd ? oddItemColor : evenItemColor,
                    title: Text('${titles[1]} $index'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
