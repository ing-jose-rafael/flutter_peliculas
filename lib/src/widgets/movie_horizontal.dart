import 'package:flutter/material.dart';
import 'package:peliculas/src/models/peliculas_model.dart';

// statelessWidget por que la informacion a mostrar bien del padre

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  /**
   * para ejecutar una funsion que esta en widget padre creamos una referencia 
   * de funsion que deseamos ejecutar
  */

  final Function siguientePagina;
  /** Constructor */ 
  /// Necesita como argumento la lista de las peliculas y la referencia 
  /// de la funsión, que va ha ejecutar del componente padre 
  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3, //cantidad de tarjetas a mostrar
  );

  @override
  Widget build(BuildContext context) {

    // para obtener la información del tamaño de la pantalla 
    final _screenSize = MediaQuery.of(context).size;
    // para saber cuando llega al final del scroll
    _pageController.addListener((){
      if (_pageController.position.pixels >= _pageController.position.maxScrollExtent-200) {
        // print('llegando al funal');
        siguientePagina(); // ejecutando la funsion que se oaso como referencia

      }
    });

    return Container(
      height: _screenSize.height * 0.25, // las tarjetas ocuparan el 25% de la pantalla
      // PageView.builder carga dinamica
      child: PageView.builder( // para crear las vista horizontales
        pageSnapping: false,
        /////////////////// Metodo 1 //////////////////////////////////
        // controller: PageController(
        //   initialPage: 1,
        //   viewportFraction: 0.3, //cantidad de tarjetas a mostrar
        // ),
        /////////////////////////////////////////////////////////////
        /// Metodo 2
        controller: _pageController,
        // children: _tarjetas(context),
        ////////////////////// Opcion 1 ///////////////////////////
        //  itemBuilder: (BuildContext context, int index) {
        //    return _tarjeta(context, peliculas[index]);
        //  },
         ////////////////////// Opcion 2 //////////////////////////
         itemBuilder: (BuildContext context, int index) =>_tarjeta(context, peliculas[index]),
         /////////////////////////////////////////////////////////
         itemCount: peliculas.length, // nuemro de item a renderizar 
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula){
    // creando el uniqueId
    pelicula.uniqueId = '${pelicula.id}-tarjetaHorizontal';

    /// para no indenzar tantos widget creamos una varibles
    final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0), // separacion entre tarjetas pero solo a la derecha
        child: Column(
          children: <Widget>[
            Hero(
              tag: pelicula.uniqueId, // identificar debe ser unico
              child: ClipRRect( // para que a imagen se vea redondeada en las esquinas
                child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImgPelic()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: 160.0, // estableciendo el alto de la imagen
                ),
                borderRadius: BorderRadius.circular(20.0),
              ), 
            ),
            SizedBox(height: 5.0,), // separacion
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis, // corta el texto cuando es demasiado grande
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );

      return GestureDetector(
        child: tarjeta, // llama la variable que tiene la tarjeta asi no indexzamos mucho
        // detecta el click o tab sobre la tarjeta
        onTap: (){
          // print('Nombre de la pelicula: ${pelicula.title}');
          // pasando argumentos a ruta la pelicula
          Navigator.pushNamed(context, 'detalle', arguments: pelicula);
        }, 
      );
  }


  /* como se esta recibiendo una cantidad de peliculas y 
   * queremos generar x numeros de tarjetas */ 
  List<Widget> _tarjetas(BuildContext context) {
    // mapea las peliculas para retirnar una lista de Widget
    return peliculas.map(( pelicula ) {
      return Container(
        margin: EdgeInsets.only(right: 15.0), // separacion entre tarjetas pero solo a la derecha
        child: Column(
          children: <Widget>[
            ClipRRect( // para que a imagen se vea redondeada en las esquinas
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImgPelic()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0, // estableciendo el alto de la imagen
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            SizedBox(height: 5.0,), // separacion
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis, // corta el texto cuando es demasiado grande
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}