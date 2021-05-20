import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/peliculas_model.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';

class DetallePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  
    /* para recibir la pelicula como argumento 
    ** final: no me deja cambiar a lo que apunta 
    ** la variable pero si sus propiedades.
    ** ModalRoute.of(context).settings.arguments
    ** obteniendo los argumentos 
    **  */
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments; 
    return Scaffold(
      // parecido a una lista pero con animacion, reacionan cuando se mueve el scroll
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(pelicula),
          // elementos normales
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 5.0), // separacion
                _posterTitulo(pelicula,context),
                _descripcion(pelicula),
                _crearCasting(pelicula)
              ]
            ),
          )

        ],
      ),
    );
  }

  Widget _crearAppBar(Pelicula pelicula) {
    // retornando un appbar pero no el normal
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0, // ancho de expandido
      floating: false,
      pinned: true, // visible cuando se haga el scroll
      // recibe un {Widget flexibleSpace} que se adaptara en el espacio
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true, // centrar el titulo
        title: Text(
          pelicula.title,
          style:TextStyle(color: Colors.white, fontSize: 16.0) 
        ),
        // Imagen
        background: FadeInImage(
          image: NetworkImage(pelicula.getbackdropPathImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
          fadeInDuration: Duration(microseconds: 150),
        ),
      ),

    );
  }
 // metodo que permite crear el poster y informacion basica de la pelicula
  Widget _posterTitulo(Pelicula pelicula, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          // ClipRect para redeondar los bordes
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              // FadeInImage no por que en este punto ya los dts de la pelicula estan cargados
              child: Image(
                image: NetworkImage(pelicula.getPosterImgPelic()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(  // widget que se adapta a todo el espacio restante
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // alineando
              children: <Widget>[
                // overflow: TextOverflow.ellipsis permite recortar el titulo cuando es muy largo
                Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis),
                // colocando la estrella
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead)
                  ],
                )
              ],
            ),

          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical:20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliProvaider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvaider.getActor(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },

    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      
      child: PageView.builder(
        pageSnapping: false,
        // No necesito saber cuando llega al final, por eso no creo el controlador aparte
        controller: new PageController(
          viewportFraction: 0.3,
          initialPage: 1  
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) => _crearTarjetaActro(actores[i])
      ),
    );
  }

  Widget _crearTarjetaActro(Actor actor){
    return Container(
    // tendra la foto y debajo el nombre
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()), 
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0, // tamaño de la imagen
              width: 110.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
  }
}