// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/presentations/screens/login_page.dart';
// import 'package:http/http.dart' as http;

// List<String> titles = <String>[
//   'Usuarios',
//   'Producción',
// ];

// class MainPage extends StatefulWidget {
//   const MainPage({Key? key}) : super(key: key);

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   List<dynamic> users = [];
//   String editedEstado = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();
//   }

//   Future<void> editUser(Map<String, dynamic> userData) async {
//     Map<String, dynamic> editedData = {...userData};
//     editedEstado = userData['estado'];

//     await showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Center(
//             child: const Text(
//               'Editar Usuario',
//             ),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Nombre'),
//                   onChanged: (value) {
//                     editedData['nombre'] = value;
//                   },
//                   controller: TextEditingController(text: userData['nombre']),
//                 ),
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Correo'),
//                   onChanged: (value) {
//                     editedData['correo'] = value;
//                   },
//                   controller: TextEditingController(text: userData['correo']),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: DropdownButton<String>(
//                     value: editedEstado.isNotEmpty
//                         ? editedEstado
//                         : userData['estado'],
//                     items: <String>['Activo', 'Inactivo']
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (newValue) {
//                       setState(() {
//                         editedEstado = newValue!;
//                       });
//                     },
//                   ),
//                 )
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancelar'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 final response = await http.put(
//                   Uri.parse(
//                       'https://api-movilcountech.onrender.com/api/users/${userData['_id']}'),
//                   headers: <String, String>{
//                     'Content-Type': 'application/json; charset=UTF-8',
//                   },
//                   body: jsonEncode(<String, dynamic>{
//                     'nombre': editedData['nombre'],
//                     'correo': editedData['correo'],
//                     'estado': editedEstado,
//                   }),
//                 );

//                 if (response.statusCode == 200) {
//                   fetchUsers();
//                   // ignore: use_build_context_synchronously
//                   Navigator.of(context).pop();
//                 } else {
//                   // Manejar errores de actualización
//                   throw Exception('Error al actualizar el usuario');
//                 }
//               },
//               child: const Text('Guardar'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> fetchUsers() async {
//     final response = await http
//         .get(Uri.parse('https://api-movilcountech.onrender.com/api/users'));
//     if (response.statusCode == 200) {
//       setState(() {
//         users = json.decode(response.body);
//       });
//     } else {
//       throw Exception('Error al cargar la lista de usuarios');
//     }
//   }



//   Future<void> deleteUser(String userId) async {
//     final response = await http.delete(
//       Uri.parse('https://api-movilcountech.onrender.com/api/users/$userId'),
//     );
//     if (response.statusCode == 204) {
//       fetchUsers();
//     } else {
//       throw Exception('Error al eliminar el usuario');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ColorScheme colorScheme = Theme.of(context).colorScheme;
//     final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
//     final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
//     const int tabsCount = 2;

//     return WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: DefaultTabController(
//         initialIndex: 1,
//         length: tabsCount,
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Countech'),
//             centerTitle: true,
//             elevation: 0,
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.logout),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Center(child: Text('Cerrar Sesión')),
//                         content: Text('¿Estás seguro de cerrar sesión?'),
//                         actions: <Widget>[
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                               Navigator.of(context).pushReplacement(
//                                 MaterialPageRoute(
//                                   builder: (context) => LoginPage(),
//                                 ),
//                               );
//                             },
//                             child: Text('Aceptar'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: Text('Cancelar'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//             automaticallyImplyLeading: false,
//             notificationPredicate: (ScrollNotification notification) {
//               return notification.depth == 1;
//             },
//             scrolledUnderElevation: 4.0,
//             shadowColor: Theme.of(context).shadowColor,
//             bottom: TabBar(
//               tabs: <Widget>[
//                 Tab(
//                   icon: const Icon(Icons.account_circle_sharp),
//                   text: titles[0],
//                 ),
//                 Tab(
//                   icon: const Icon(Icons.bar_chart_outlined),
//                   text: titles[1],
//                 ),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: <Widget>[
//               ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   final user = users[index];
//                   return ListTile(
//                     title: Text(user['nombre']),
//                     subtitle: Text(user['correo']),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.edit),
//                           onPressed: () {
//                             editUser(user);
//                           },
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete),
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: Center(
//                                       child: const Text('Eliminar Usuario')),
//                                   content: const Text(
//                                       '¿Seguro que deseas eliminar este usuario?'),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                       },
//                                       child: const Text('Cancelar'),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         deleteUser(user['_id']);
//                                         Navigator.of(context).pop();
//                                       },
//                                       child: const Text('Eliminar'),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               ListView.builder(
//                 itemCount: orders.length,
//                 itemBuilder: (context, index) {
//                   final order = orders[index];
//                   return ExpansionTile(
//                     title: Text('Orden de Trabajo: ${order.ordenTrabajo}'),
//                     children: <Widget>[
//                       Column(
//                         children: order.processes.map((process) {
//                           return ExpansionTile(
//                             title: Text('Proceso: ${process.nombre}'),
//                             children: <Widget>[
//                               Column(
//                                 children: process.references.map((reference) {
//                                   return ExpansionTile(
//                                     title: Text('Referencia: ${reference.descripcion}'),
//                                     children: <Widget>[
//                                       Column(
//                                         children: reference.colors.map((color) {
//                                           return ListTile(
//                                             title: Text('Color: ${color.name}'),
//                                             subtitle: Column(
//                                               children: color.tallas.map((size) {
//                                                 return ListTile(
//                                                   title: Text('Talla: ${size.talla}'),
//                                                   subtitle: Text('Unidades: ${size.cantidad}'),
//                                                   trailing: ElevatedButton(
//                                                     onPressed: () {
//                                                       // Mostrar pantalla para agregar asignación
//                                                       // Aquí puedes crear una función para manejar esto.
//                                                     },
//                                                     child: Text('Agregar Asignación'),
//                                                   ),
//                                                 );
//                                               }).toList(),
//                                             ),
//                                           );
//                                         }).toList(),
//                                       ),
//                                     ],
//                                   );
//                                 }).toList(),
//                               ),
//                             ],
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentations/screens/login_page.dart';
import 'package:http/http.dart' as http;


List<String> titles = <String>[
  'Usuarios',
  'Pedidos', // Cambié "Producción" a "Pedidos"
];

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<dynamic> users = [];
  List<dynamic> orders = []; // Agregamos la lista de pedidos
  String editedEstado = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchOrders(); // Llamamos a fetchOrders para cargar la lista de pedidos
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
                      'https://api-movilcountech.onrender.com/api/users/${userData['_id']}'),
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
        .get(Uri.parse('https://api-movilcountech.onrender.com/api/users'));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar la lista de usuarios');
    }
  }

  Future<void> fetchOrders() async {
    final response = await http
        .get(Uri.parse('https://api-movilcountech.onrender.com/api/orders'));
    if (response.statusCode == 200) {
      setState(() {
        orders = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar la lista de pedidos');
    }
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(
      Uri.parse('https://api-movilcountech.onrender.com/api/users/$userId'),
    );
    if (response.statusCode == 204) {
      fetchUsers();
    } else {
      throw Exception('Error al eliminar el usuario');
    }
  }


  void _showAssignmentForm(int orderId, String procesoId, int referenceId, String colorName, String sizeTalla) {
  String selectedEmployee = 'Empleado 1'; // Debes tener una lista de empleados para seleccionar
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  int unitsAssigned = 0;

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: const Text('Agregar Asignación'),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButton<String>(
                hint: Text('Seleccionar Empleado'),
                value: selectedEmployee,
                onChanged: (newValue) {
                  setState(() {
                    selectedEmployee = newValue!;
                  });
                },
                // Debes cargar la lista de empleados
                items: <String>['Empleado 1', 'Empleado 2']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Unidades Asignadas'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  unitsAssigned = int.tryParse(value) ?? 0;
                },
              ),
              Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Fecha Inicial'),
                        readOnly: true,
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              startDate = selectedDate;
                            });
                          }
                        },
                        controller: TextEditingController(text: startDate.toString()),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Fecha Final'),
                        readOnly: true,
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: endDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              endDate = selectedDate;
                            });
                          }
                        },
                        controller: TextEditingController(text: endDate.toString()),
                      ),
                    ),
                  ],
                ),
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
              // Enviar la asignación al servidor
              final response = await http.post(
                Uri.parse('https://api-movilcountech.onrender.com/api/assignment'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, dynamic>{
                  'employee': selectedEmployee,
                  'order': orderId,
                  'reference': referenceId,
                  'color': colorName,
                  'size': sizeTalla,
                  'unitsAssigned': unitsAssigned,
                  'startDate': startDate.toIso8601String(),
                  'endDate': endDate.toIso8601String(),
                }),
              );

              if (response.statusCode == 201) {
                // Actualiza la vista o realiza otras acciones necesarias
                Navigator.of(context).pop();
              } else {
                // Maneja errores
                print('Error al crear la asignación');
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
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
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ExpansionTile(
                    title: Text('Orden de Trabajo: ${order['ordenTrabajo']}'),
                    children: <Widget>[
                      Column(
                        children: order['processes'].map<Widget>((process) {
                          return ExpansionTile(
                            title: Text('Proceso: ${process['nombre']}'),
                            children: <Widget>[
                              Column(
                                children: process['references'].map<Widget>((reference) {
                                  return ExpansionTile(
                                    title: Text('Referencia: ${reference['descripcion']}'),
                                    children: <Widget>[
                                      Column(
                                        children: reference['colors'].map<Widget>((color) {
                                          return ListTile(
                                            title: Text('Color: ${color['name']}'),
                                            subtitle: Column(
                                              children: color['tallas'].map<Widget>((size) {
                                                return ListTile(
                                                  title: Text('Talla: ${size['talla']}'),
                                                  subtitle: Text('Unidades: ${size['cantidad']}'),
                                                  trailing: ElevatedButton(
                                                    onPressed: () {
                                                       _showAssignmentForm(
                                                          order['ordenTrabajo'], // Orden de trabajo
                                                          process['name'],     // Nombre del proceso
                                                          reference['num'], // Descripción de la referencia
                                                          size['talla'],          // Talla
                                                          color['name'],          // Nombre del color
                                                        );
                                                    },
                                                    child: Text('Agregar Asignación'),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}
