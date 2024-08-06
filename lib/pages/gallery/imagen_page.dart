import 'package:eventsbox/functions/functions.dart';
import 'package:eventsbox/models/asistente.dart';
import 'package:eventsbox/models/imagen.dart';
import 'package:flutter/material.dart';

class ImagenPage extends StatefulWidget {
  final Imagen imagen;
  final Asistente usuario;
  const ImagenPage(this.imagen, this.usuario, {super.key});

  @override
  State<ImagenPage> createState() => _ImagenPageState();
}

class _ImagenPageState extends State<ImagenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => downloadFile(widget.imagen.image),
              icon: const Icon(Icons.download))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(children: [
                widget.usuario.image.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(widget.usuario.image),
                        radius: 30)
                    : CircleAvatar(
                        backgroundColor: Colors.blue[900],
                        radius: 30,
                        child: Text(widget.usuario.name[0],
                            style: const TextStyle(color: Colors.white))),
                const SizedBox(width: 20),
                Text('${widget.usuario.name} ${widget.usuario.lastName}',
                    style: const TextStyle(fontSize: 16))
              ]),
            ),
            Image.network(widget.imagen.image),
            ListTile(
              onTap: () => setState(() =>
                  widget.imagen.myLike = widget.imagen.myLike == 0 ? 1 : 0),
              leading: widget.imagen.myLike == 0
                  ? const Icon(Icons.favorite_border)
                  : const Icon(Icons.favorite, color: Colors.red),
              title: Text('${widget.imagen.likes} me gusta'),
              horizontalTitleGap: 5,
            ),
            widget.imagen.description.isNotEmpty
                ? ListTile(
                    title: Text(widget.imagen.description),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
