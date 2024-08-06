import 'package:flutter/material.dart';

class OrdenarAsistentes extends StatefulWidget {
  const OrdenarAsistentes({super.key});

  @override
  State<OrdenarAsistentes> createState() => _OrdenarAsistentesState();
}

class _OrdenarAsistentesState extends State<OrdenarAsistentes> {
  final List<bool> _opcionSeleccionada = [true, false, false];
  int elegida = 0;

  @override
  Widget build(BuildContext context) {
    const List<String> opciones = ['Recientes', 'Nombre', 'Apellidos'];
    return Scaffold(
      appBar: AppBar(title: const Text('Ordenar y filtrar')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ordenar por',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: List<Widget>.generate(opciones.length, (index) {
                return Container(
                  margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            side: BorderSide(
                                color: _opcionSeleccionada[index]
                                    ? Colors.black
                                    : Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.all(10))
                        .copyWith(
                            overlayColor: const MaterialStatePropertyAll(Colors
                                .transparent)), // Elimina el cambio de color al mantener presionado el botón
                    onPressed: () {
                      setState(() {
                        for (int i = 0; i < _opcionSeleccionada.length; i++) {
                          _opcionSeleccionada[i] = i == index;
                        }
                        elegida = index;
                      });
                    },
                    child: Text(opciones[index],
                        style: const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                );
              }),
            ),
            const Divider(),
            const Expanded(child: SizedBox()),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                              foregroundColor: Colors.blue[900],
                              side: BorderSide(color: Colors.blue.shade900),
                              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)))
                          .copyWith(
                              overlayColor: const MaterialStatePropertyAll(
                                  Colors.transparent)),
                      child:
                          const Text('Borrar', style: TextStyle(fontSize: 16))),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, elegida);
                    },
                    style: TextButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)))
                        .copyWith(
                            overlayColor: const MaterialStatePropertyAll(
                                Colors.transparent)),
                    child:
                        const Text('Mostrar', style: TextStyle(fontSize: 16)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
