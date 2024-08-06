import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/asistente.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class AsistentePage extends StatelessWidget {
  final Asistente asistente;
  const AsistentePage(this.asistente, {super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> infoAsistente = <String, String>{};
    if (asistente.company.isNotEmpty) {
      infoAsistente['Empresa'] = asistente.company;
    }
    if (asistente.position.isNotEmpty) {
      infoAsistente['Cargo'] = asistente.position;
    }
    if (asistente.country.isNotEmpty) {
      infoAsistente['País'] = asistente.country;
    }
    if (asistente.city.isNotEmpty) {
      infoAsistente['Población'] = asistente.city;
    }
    if (asistente.contactMail.isNotEmpty) {
      infoAsistente['Mail de contacto'] = asistente.contactMail;
    }
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 150,
                  color: Colors.blue[900],
                ),
                Positioned(
                    top: 80,
                    child: Container(
                        color: Colors.white,
                        height: 200,
                        width: MediaQuery.of(context).size.width)),
                //////////////////////////////////////////////////////////////////////////////////
                ////////////////////////////////// - AVATAR - ////////////////////////////////////
                //////////////////////////////////////////////////////////////////////////////////
                Positioned(
                  left: 20,
                  top: 30,
                  child: badges.Badge(
                    badgeStyle: const badges.BadgeStyle(
                        elevation: 0,
                        badgeColor: Colors.grey,
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    badgeContent: const SizedBox(height: 8, width: 8),
                    position:
                        badges.BadgePosition.bottomEnd(bottom: 5, end: 12),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.white,
                      child: asistente.image.isNotEmpty
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(asistente.image))
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blueAccent,
                              child: Text(
                                asistente.name[0],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 35),
                              ),
                            ),
                    ),
                  ),
                ),
                //////////////////////////////////////////////////////////////////////////////////
                ////////////////////////////////// - ICONOS - ////////////////////////////////////
                //////////////////////////////////////////////////////////////////////////////////
                asistente.id != Globals.user
                    ? Positioned(
                        top: 55,
                        right: 20,
                        child: Row(
                          children: [
                            _icono(context, Icons.message, Colors.blue.shade900, '/chat'),
                            const SizedBox(width: 10),
                            _icono(context, Icons.edit_document, Colors.grey.shade700, '/'),
                            const SizedBox(width: 10),
                            _icono(context, Icons.star_border, Colors.blue.shade900, '/'),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            //////////////////////////////////////////////////////////////////////////////////
            //////////////////////////// - NOMBRE DEL ASISTENTE - ////////////////////////////
            //////////////////////////////////////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                '${asistente.name} ${asistente.lastName}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.handshake),
                  label: const Text('REUNIÓN'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white)),
            ),
            const SizedBox(height: 10),
            //////////////////////////////////////////////////////////////////////////////////
            ///////////////////////// - INFORMACIÓN DEL ASISTENTE - //////////////////////////
            //////////////////////////////////////////////////////////////////////////////////
            Stack(children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade900),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _infoAsistente(infoAsistente),
              ),
              Positioned(
                  top: -12,
                  left: 40,
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Text('Información',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.blue[900])))
                    ],
                  ))
            ]),
          ],
        ),
      ),
    );
  }

  Widget _infoAsistente(Map<String, String> informacion) {
    var entries = informacion.entries.toList();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(entries.length, (index) {
          var entry = entries[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(entry.value),
                index < entries.length - 1
                    ? const Divider()
                    : const SizedBox(
                        height: 10)
              ],
            ),
          );
        }));
  }

  Widget _icono(BuildContext context, IconData icon, Color color, String route) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(1, 3))
          ]),
      child: IconButton(
        icon: Icon(icon, color: color, size: 30),
        onPressed: () {
          Navigator.pushNamed(context, route, arguments: asistente);
        },
      ),
    );
  }
}
