import 'package:eventsbox/database/database_helper.dart';
import 'package:eventsbox/models/asistente.dart';
import 'package:eventsbox/models/galeria_imagenes.dart';
import 'package:eventsbox/models/patrocinador.dart';
import 'package:eventsbox/models/ponente.dart';
import 'package:eventsbox/pages/agenda/agenda_page.dart';
import 'package:eventsbox/pages/attendees/asistente_page.dart';
import 'package:eventsbox/pages/attendees/asistentes_page.dart';
import 'package:eventsbox/pages/attendees/ordenar_asistentes.dart';
import 'package:eventsbox/pages/chat/chat_page.dart';
import 'package:eventsbox/pages/chat/mensajes_page.dart';
import 'package:eventsbox/pages/gallery/galeria_imagenes_page.dart';
import 'package:eventsbox/pages/gallery/galerias_imagenes_page.dart';
import 'package:eventsbox/pages/home_page.dart';
import 'package:eventsbox/pages/gallery/imagen_page.dart';
import 'package:eventsbox/pages/login_page.dart';
import 'package:eventsbox/pages/sponsors/patrocinador_page.dart';
import 'package:eventsbox/pages/sponsors/patrocinadores_page.dart';
import 'package:eventsbox/pages/speakers/ponente_page.dart';
import 'package:eventsbox/pages/speakers/ponentes_page.dart';
import 'package:eventsbox/pages/gallery/subir_imagen_page.dart';
import 'package:eventsbox/providers/navigation_bar_provider.dart';
import 'package:eventsbox/routes/imagen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await DatabaseHelper.instance.init();
  runApp(ChangeNotifierProvider(
      create: (_) => NavigationBarProvider(), child: MainApp()));
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _routes = {
    '/': (context) => const LoginPage(),
    '/home': (context) => const HomePage(),
    '/speakers': (context) => const PonentesPage(),
    '/agenda': (context) => const AgendaPage(),
    '/sponsors': (context) => const PatrocinadoresPage(),
    '/images_gallery': (context) => const GaleriasImagenesPage(),
    '/gallery': (context) => const GaleriasImagenesPage(),
    '/explore': (context) => const AsistentesPage(),
    '/attendees': (context) => const AsistentesPage(),
    '/ordenar_asistentes': (context) => const OrdenarAsistentes(),
    '/messages': (context) => MensajesPage(key: detailChatKey)
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EventsBox',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue.shade900,
                foregroundColor: Colors.white)),
        routes: _routes,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/ponente':
              if (settings.arguments != null) {
                Ponente ponente = settings.arguments as Ponente;
                return MaterialPageRoute(
                    builder: (context) => PonentePage(ponente));
              }
            case '/patrocinador':
              if (settings.arguments != null) {
                Patrocinador patrocinador = settings.arguments as Patrocinador;
                return MaterialPageRoute(
                    builder: (context) => PatrocinadorPage(patrocinador));
              }
            case '/galeria_de_imagenes':
              if (settings.arguments != null) {
                GaleriaImagenes galeria = settings.arguments as GaleriaImagenes;
                return MaterialPageRoute(
                    builder: (context) => GaleriaImagenesPage(galeria));
              }
            case '/imagen':
              if (settings.arguments != null) {
                final args = settings.arguments as ImagenArguments;
                return MaterialPageRoute(
                    builder: ((context) =>
                        ImagenPage(args.imagen, args.asistente)));
              }
            case '/upload_image':
              if (settings.arguments != null) {
                GaleriaImagenes galeria = settings.arguments as GaleriaImagenes;
                return MaterialPageRoute(
                    builder: (context) => SubirImagenPage(galeria));
              }
            case '/asistente':
              if (settings.arguments != null) {
                Asistente asistente = settings.arguments as Asistente;
                return MaterialPageRoute(
                    builder: (context) => AsistentePage(asistente));
              }
            case '/chat':
              if (settings.arguments != null) {
                Asistente asistente = settings.arguments as Asistente;
                return MaterialPageRoute(
                    builder: (context) => ChatPage(asistente));
              }
          }
          // Si la ruta no existe carga la página de inicio
          return MaterialPageRoute(builder: (context) => const HomePage());
        });
  }
}
