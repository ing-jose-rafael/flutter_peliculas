import 'package:flutter/material.dart';
import 'package:peliculas/src/pages/home_page.dart';
import 'package:peliculas/src/pages/peliDetalle_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: '/',
      // definiendo mapa de rutas
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => DetallePage(), // esta ruta necesita la pelicula como argumento

      },
    );
  }
}