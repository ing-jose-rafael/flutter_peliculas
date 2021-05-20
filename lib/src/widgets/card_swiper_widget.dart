import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

import 'package:peliculas/src/models/peliculas_model.dart';

class CardSwiper extends StatelessWidget {
  /* tiene que recibir como argumento la peliculas de tarjetas vamos a rendirizar */
  final List<Pelicula> peliculas; // por que no va ha cambiar
  // @required obliga a que el parametro sea requerido
  const CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    // para obtener la información del tamaño de la pantalla del dispositivo
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      // width: double.infinity, // todo el ancho posible
      // height: _screenSize.height * 0.5, // 50% del alto
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          // creando id uniqueId
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';

          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
              // para recortar los bordes
              borderRadius: BorderRadius.circular(20.0),
              // child:Image.network("http://via.placeholder.com/350x150",fit: BoxFit.fill,),
              child: GestureDetector(
                  child: FadeInImage(
                      image: NetworkImage(peliculas[index].getPosterImgPelic()), // obtnie la imagen de la pelicula
                      placeholder: AssetImage('assets/img/no-image.jpg'), // en caso que la pelicula no tenga img
                      fit: BoxFit.fill),
                  // al hacer click en la tarjeta
                  onTap: () => Navigator.pushNamed(context, 'detalle', arguments: peliculas[index])),
            ),
          );
        },
        itemCount: peliculas.length,
        itemWidth: _screenSize.width * 0.7, // 70% del ancho
        itemHeight: _screenSize.height * 0.5, // 50% del alto
        layout: SwiperLayout.STACK,
        // pagination: new SwiperPagination(), // puntos en la parte de abajo
        // control: new SwiperControl(), // direccionales
      ),
    );
  }
}
