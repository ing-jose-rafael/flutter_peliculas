import 'package:flutter/material.dart';
import 'package:peliculas/src/models/peliculas_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  //////////////////////////////////////////////////////////
  // final peliculas=[
  //   'Superman',
  //   'Superman 2',
  //   'Superman 3',
  //   'Spider-man',
  //   'Spider-man 2',
  //   'Iron Man',
  //   'Capitan America',
  // ];
  
  // final peliculasRecientes = [
  //   'Toy Story',
  //   'Spider Man 3',
  //   'Superman 2'
  // ];
  /////////////////////////////////////////////////////////////
  final peliProvider = new PeliculasProvider();

  String seleccion = '';


  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del appbar ej: un icon para limpiar el texto
    return [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: () {
          // todo lo que la persona escriba en el buscador se guarda en un string 
          query ='';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar. btn para regresar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, 
          progress: transitionAnimation, // tiempo que se anima el icon entre 0 y 1
        ), 
        onPressed: () {
          close(context, null);
        },
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // La instruccion que crea los resultados a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.indigoAccent,
        child: Text(seleccion),
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencia que aparecen cuando se escribe 
    // final listSugerida = ( query.isEmpty ) //operador ternario (condicion) ? true : false
    //                       ? peliculasRecientes
    //                       : peliculas.where(
    //                         // Retorna todas las peliculas que cumplen la condición
    //                         (p) => p.toLowerCase().startsWith(query.toLowerCase())
    //                         ).toList();
    // return ListView.builder(
    //   itemCount: listSugerida.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listSugerida[index]),
    //       onTap: (){
    //         seleccion = listSugerida[index];
    //         showResults(context); //para llamar el metodo buildResults
    //       },
    //     );
    //   },
      
    // );
    if ( query.isEmpty ) {
      return Container();
    }

    return FutureBuilder(
      future: peliProvider.getBuscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if ( snapshot.hasData ) {
          final peliculas = snapshot.data;
      
          return ListView(
            children: peliculas.map( (peli) {
              // lista de la peliculas a mostrar
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(peli.getPosterImgPelic()), 
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(peli.title),
                subtitle: Text(peli.originalTitle),
                onTap: (){
                  close(context, null); // cerrando la pag de la busqueda
                  peli.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: peli);
                },
              );
            }).toList(),
          );
        } else { 
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      
    );

  }
  
}