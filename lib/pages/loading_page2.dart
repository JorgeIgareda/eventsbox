import 'package:eventsbox/globals/global_theme.dart';
import 'package:eventsbox/services/api.dart';
import 'package:flutter/material.dart';

class LoadingPage2 extends StatelessWidget {
  const LoadingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    _getMenu();
    return Material(
      color: const Color.fromARGB(255, 35, 43, 56),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Image(
            image: NetworkImage(
                'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/b1/18/ef/b118ef7b-4c11-fb4f-50ac-d628f172987b/febed30b-65c8-4357-a15f-c0e1ae512e68_Disen_U0303o_sin_ti_U0301tulo__U00282_U0029.png/643x0w.jpg'),
          ),
          CircularProgressIndicator(
              color: GlobalThemeData.lightColorScheme.onPrimary)
        ],
      ),
    );
  }

  /// Obtiene las opciones del menú lateral y del menú de navegación desde la API
  void _getMenu() async {
    await Api.getMenu();
    await Api.getAttendees();
    await Api.getChat();
  }
}
