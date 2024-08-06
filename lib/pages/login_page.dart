import 'package:eventsbox/functions/functions.dart';
import 'package:eventsbox/globals/global_theme.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/pages/pass_code_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController =
      TextEditingController(text: '');

  @override
  void initState() {
    _isLogin();

    super.initState();
  }

  // Comprueba si ya se ha iniciado sesión anteriormente y de ser así almacena las preferencias en variables globales e inicia sesión directamente
  _isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Globals.token = prefs.getString('token') ?? '';
    Globals.lastAttendeeUpdate = prefs.getString('lastAttendeeUpdate') ?? '';
    if (mounted) {
      if (Globals.token != '') {
        Globals.user = prefs.getInt('user') ?? 0;
        Globals.lastAttendeeUpdate =
            prefs.getString('lastAttendeeUpdate') ?? '';
        Globals.lastChatReceived = prefs.getInt('lastChatReceived') ?? 0;
        loadPage(context, '/home');
      }
    }
  }

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
              const Text(
                'Introduce el correo electrónico con el que quieres acceder al evento',
                style: TextStyle(fontSize: 13),
              ),
              txtEmail(),
              btnSiguiente(),
              const Expanded(child: SizedBox()),
              const Text('¿No puedes acceder con tu email?'),
              const Text('Escríbenos a ayuda@meetmaps.com',
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

  // Campo de texto para introducir el email
  Widget txtEmail() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), border: Border.all()),
        child: TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
                hintText: 'Email', border: InputBorder.none)));
  }

  // Botón para pasar a la pantalla de introducir el código del evento
  Widget btnSiguiente() {
    return ElevatedButton(
        onPressed: () {
          //Reemplaza la ruta del login por la de la página principal mostrando una pantalla de carga por 3 segundos
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PassCode(_emailController.text.trim())));
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 65, 64, 64),
            foregroundColor: GlobalThemeData.lightColorScheme.onPrimary,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: const Text('Siguiente'));
  }
}
