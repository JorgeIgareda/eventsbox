import 'package:eventsbox/database/attendee_dao.dart';
import 'package:eventsbox/database/menu_dao.dart';
import 'package:eventsbox/functions/functions.dart';
import 'package:eventsbox/globals/global_theme.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/asistente.dart';
import 'package:eventsbox/models/item_menu.dart';
import 'package:flutter/material.dart';

class HamburgerMenu extends StatefulWidget {
  const HamburgerMenu({super.key});

  @override
  State<HamburgerMenu> createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<HamburgerMenu> {
  late Future<List<TextButton>> tiles;
  late Asistente _usuario;

  @override
  void initState() {
    super.initState();
    tiles = _prepareMenu();
  }

  Future<List<TextButton>> _prepareMenu() async {
    _usuario = await AttendeeDao().select(Globals.user);
    return _getMenu();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: tiles,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Drawer(
              shape: const BeveledRectangleBorder(),
              child: Container(
                  color: GlobalThemeData.lightColorScheme.onPrimary,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      /////////////////////////////////////////////////////////////////////////
                      // Cabecera del Drawer //////////////////////////////////////////////////
                      /////////////////////////////////////////////////////////////////////////
                      DrawerHeader(
                          decoration: BoxDecoration(
                              color:
                                  GlobalThemeData.lightThemeData.primaryColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Si el usuario tiene avatar muestra su avatar, si no muestra la inicial de su nombre
                              _usuario.image != ''
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(_usuario.image),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 21,
                                      child: CircleAvatar(
                                          backgroundColor: Colors.blue[900],
                                          child: Text(_usuario.name[0],
                                              style: const TextStyle(
                                                  color: Colors.white)))),
                              Text('${_usuario.name} ${_usuario.lastName}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: GlobalThemeData
                                          .lightColorScheme.onPrimary)),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/asistente',
                                    arguments: _usuario),
                                child: Text('Ver perfil',
                                    style: TextStyle(
                                        color: GlobalThemeData
                                            .lightColorScheme.onPrimary)),
                              )
                            ],
                          )),
                      /////////////////////////////////////////////////////////////////////////
                      // Opciones del menú recibidas desde la base de datos ///////////////////
                      /////////////////////////////////////////////////////////////////////////
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return snapshot.data![index];
                          }),
                      /////////////////////////////////////////////////////////////////////////
                      // Opciones de cambiar de evento, actualizar contenido y cerrar sesión //
                      /////////////////////////////////////////////////////////////////////////
                      const Divider(),
                      TextButton(
                          style: TextButton.styleFrom(
                              shape: const BeveledRectangleBorder(),
                              foregroundColor: Colors.grey[900],
                              padding: EdgeInsets.zero),
                          child: const ListTile(
                            title: Text('Actualizar contenido'),
                            leading: Icon(Icons.refresh),
                          ),
                          onPressed: () => reload(context)),
                      TextButton(
                        style: TextButton.styleFrom(
                            shape: const BeveledRectangleBorder(),
                            foregroundColor: Colors.grey[900],
                            padding: EdgeInsets.zero),
                        child: const ListTile(
                          title: Text('Cerrar sesión'),
                          leading: Icon(Icons.power_settings_new),
                        ),
                        onPressed: () => logOut(context),
                      ),
                      /////////////////////////////////////////////////////////////////////////
                      // Términos y condiciones ///////////////////////////////////////////////
                      /////////////////////////////////////////////////////////////////////////
                      const Divider(),
                      Container(
                          padding: const EdgeInsets.all(20),
                          child: const Text(
                              'Términos y condiciones - Política de privacidad',
                              textAlign: TextAlign.center))
                    ],
                  )));
        }));
  }

  /// Recibe desde la base de datos las opciones del menú previamente obtenidas desde la API, crea los botones y devuelve una lista con todos los botones
  Future<List<TextButton>> _getMenu() async {
    List<TextButton> buttons = <TextButton>[];

    List<ItemMenu> menu = await MenuDao().readAll();
    for (ItemMenu item in menu) {
      if ((item.location == 0 || item.location == 2) && item.social == 0) {
        buttons.add(TextButton(
            onPressed: () {
              {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/${item.content}');
              }
            },
            style: TextButton.styleFrom(
                shape: const BeveledRectangleBorder(),
                foregroundColor: Colors.grey[900],
                padding:
                    EdgeInsets.zero), // TODO falta modificar algunos iconos
            child: ListTile(
              title: Text(item.title),
              leading: Icon(Globals.iconMap[item.icon]),
              dense: true,
            )));
      }
    }
    return buttons;
  }
}
