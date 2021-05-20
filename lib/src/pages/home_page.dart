import 'package:flutter/material.dart';


import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';

import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {

  final peliculaProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    
    peliculaProvider.getPupolares(); // llama al metodo que traera las peliculas
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: false, // para que no centre el titulo
        title: Text('Películas en Cine'),
        backgroundColor: Colors.indigoAccent,
        // btn 
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () {
              showSearch(
                context: context, 
                delegate: DataSearch(), // instanciamos la clase DataSearch() que la creamos
                //query: 'hola', // texto que aparece
              ); 
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // creando espacio entre los elementos 
          children: <Widget>[
            _swiperTarjeta(),
            _footer(context)
          ],
        ),
      ),
    );
  }
  /* Widget que retorna las tarjetas  */
  Widget _swiperTarjeta() {
    
    return FutureBuilder(
      future: peliculaProvider.getEnCine(), // llama la funcion que retornara las peliculas
      
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
       
        // retornara el widget que creamos CardSwiper si tiene informacion snapshot.data
        if (snapshot.hasData) {
          return CardSwiper(
            peliculas: snapshot.data
          );
        } else { // caso contrario retorna un loading mientra carga la info
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            ),
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity, // toma todo el tamaño 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // alineando a la izquierda
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
          // configurando de una manera global los titulos del appi, Theme.of(context).textTheme.subhead
            child: Text('Populares', style: Theme.of(context).textTheme.subhead)
          ),
          SizedBox(height: 5.0), // seoarando del texto con la tarjetas
          ///////////// Metodo 1 /////////////// 
          // FutureBuilder(
          //   future: peliculaProvider.getPupolares(), // llama al metodo que traera las peliculas
          //   builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          //     // probando por consola. hace el forEach si existe data con el signo de ?
          //     // snapshot.data?.forEach((peli) =>  print(peli.title));

          //     if (snapshot.hasData) { // si tiene data llama al widget que contruira las tarjetas
          //       return MovieHorizontal(peliculas: snapshot.data,);
          //     } else {
          //         return Center(
          //         child: CircularProgressIndicator()
          //       );
          //     }
          //   },
          // ),
          /** ********* Metodo 2 **********
           * La diferencia entre FutureBuilder vs StreamBuilder es que 
           * FutureBuilder se ejecuta una sola vez, mientras StreamBuilder
           * se ejecuta cada ves que se emita un valor en el Stream 
           * */ 

          StreamBuilder(
            stream: peliculaProvider.popularesStream, // llama al metodo que traera las peliculas
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              // probando por consola. hace el forEach si existe data con el signo de ?
              // snapshot.data?.forEach((peli) =>  print(peli.title));

              if (snapshot.hasData) { // si tiene data llama al widget que contruira las tarjetas
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculaProvider.getPupolares,
                );
              } else {
                  return Center(
                  child: CircularProgressIndicator()
                );
              }
            },
          ),
        ],
      ),
    );
  }
}