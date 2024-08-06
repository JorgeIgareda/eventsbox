import 'package:eventsbox/functions/functions.dart';
import 'package:eventsbox/globals/global_theme.dart';
import 'package:eventsbox/services/api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PassCode extends StatefulWidget {
  final String email;
  const PassCode(this.email, {super.key});

  @override
  State<PassCode> createState() => _PassCodeState();
}

class _PassCodeState extends State<PassCode> {
  final TextEditingController _codeController = TextEditingController(text: '');

  late String token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: const Text('Eventsbox'),
          backgroundColor: const Color.fromARGB(255, 65, 64, 64)),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Image(
                  image: NetworkImage(
                      'https://is1-ssl.mzstatic.com/image/thumb/Purple112/v4/f3/af/2a/f3af2a39-efc2-724d-61f5-ed10bcf9999d/AppIcon-1x_U007emarketing-0-0-0-7-0-0-85-220.png/1200x600wa.png')),
              const SizedBox(height: 80),
              Text(
                'Pon tu código de acceso personal al evento ${widget.email}',
                style: const TextStyle(fontSize: 13),
              ),
              txtCodigo(),
              btnAcceder(),
              const Expanded(child: SizedBox()),
              const Text('¿No lo encuentras?'),
              const Text('Cambiar',
                  style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue))
            ],
          ),
        ),
      ),
    );
  }

  // Campo de texto para introducir el código de acceso al evento
  Widget txtCodigo() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), border: Border.all()),
        child: TextFormField(
            controller: _codeController,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: 'Código de acceso al evento',
                border: InputBorder.none)));
  }

  // Botón para acceder al evento tras meter el código de acceso
  Widget btnAcceder() {
    return ElevatedButton(
        onPressed: () async {
          token = await Api.login(widget.email, _codeController.text.trim());
          if (token == '') {
            Fluttertoast.showToast(msg: 'El email y el código no coinciden');
          } else {
            //Reemplaza la ruta del login por la de la página principal mostrando una pantalla de carga por 3 segundos
            if (mounted) {
              loadPage(context, '/home');
            }
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 65, 64, 64),
            foregroundColor: GlobalThemeData.lightColorScheme.onPrimary,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: const Text('Acceder'));
  }
}
