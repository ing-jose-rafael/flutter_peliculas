
/**
 * Cuando llamamos una API la cual nos retorna un JSON... NO
 * podemos usarlo directamente como si estubieramos en JavaScript, 
 * porque no son compatibles. Al pasarlo por el Parseador del JSON 
 * a un MAPA de Dart, nos retorna dicho mapa, el cual podemos usar  
 * ya. pero no es conveniente porque  perdemos el tipado y no tenemos 
 * un fuerte tipado de datos. por eso creamos una clase que nos permita
 * tomar ese MAPA y crear instancias del modelo que previamente creamos.
 */
import 'package:http/http.dart' as http; // para hacer peticiones http

import 'dart:convert'; // para convertir el string de la respuesta a un mapa
import 'dart:async';

import 'package:peliculas/src/models/peliculas_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

class PeliculasProvider {

  //atributos privados
  String _apiKey   = '3a7c19801a6ce7228d1bfc5ad90b0e1c';
  String _url      = 'api.themoviedb.org';
  String _language = 'es-Es';

  // para controlar cada numero de pag en la peticion de ppopulares
  int _popularesPage = 0;

  // Bandera para controlar la petriciones HTTP
  bool _cargando = false;

  // CREANDO EL STREAM
  // corriente de dts que transmitira el listado de las peliculas
  List<Pelicula> _pupolares = new List();

  List<Actor> _actores = new List(); 

  // Se tiene que especificar que inf es la que debe fluir <List<Pelicula>> en el Stream
  final _pupolaresStremController = new StreamController<List<Pelicula>>.broadcast(); // final por que no cambiaara

  // dfiniendo dos get y set pa insertar info al Stream y otro para poder escuchar lo que se emita
  ///
  /// Function(List<Pelicula>): Acepta como argumento la lista de peliculas es para que solo acepte una lista de peliculas.
  /// get popularesSink es una funcion que en su cuerpo solo tiene una linea de codgio por eso usamos =>
  /// _pupolaresStremController.sink.add nos permite agregar las lista de a la fluente del Stream
  
  Function(List<Pelicula>) get popularesSink => _pupolaresStremController.sink.add; // Que tipo de info entra
  /// 
  /// Stream<List<Pelicula>>: es lo que va ha estar emitiendo
  /// get popularesStream es una funcion que en su cuerpo solo tiene una linea de codgio por eso usamos =>
  /// _pupolaresStremController.stream nos permite obtener las lista de a la fluente del Stream
  Stream<List<Pelicula>> get popularesStream => _pupolaresStremController.stream; // Que tipo de info entra

  // cerrando el stream
  void disposeStream(){
    _pupolaresStremController?.close();
  }



  /*
   * Para no estar repitiendo codigo simplificamos  
   */
  Future<List<Pelicula>> _procesarRespuesta({Uri url}) async{
    // instalamos el paquete http antes de usar http.get(url)
    final resp = await http.get(url);
    // transformando el string de resp a un map
    final decodedData = json.decode(resp.body); // mapeando la respuesta
    /***
     * Llamamos el contructor con nombre de la clase pelicula, que nos
     * permite hacer un barrido de cada uno de los resultados que tiene 
     * de decodeData pero en results (decodeData tiene toda la resp http 
     * mapeada) y creando una lista de peliculas
     **/
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    // print(peliculas.item[1].title);

    return peliculas.items;
  }

  // retorna una coleccion de peliculas mapeada
  Future<List<Pelicula>> getEnCine() async {
    // Uri. es un metodo de dart
    // Uri.http(authority, String unencodedPath, [Map<String, String> queryParameters])
    final url = Uri.http(_url, '3/movie/now_playing', {
      'api_key' : _apiKey,
      'language': _language
    });
    // instalamos el paquete http
    final resp = await http.get(url);
    // transformando el string de resp a un map
    final decodedData = json.decode(resp.body); // mapeando la respuesta
    /**
     * barriendo cada uno de los resultados que tiene decodeData
     * y creando una lista de peliculas
     */
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    // print(peliculas.item[1].title);

    return peliculas.items;
  }

  Future<List<Pelicula>> getPupolares() async{

    if ( _cargando ) { // para que espere y no haga muchas peticiones http
      return [];
    }
    _cargando = true;

    _popularesPage++;
    // print('haciendo peticion http');

    // Uri. es un metodo de dart
    // Uri.http(authority, String unencodedPath, [Map<String, String> queryParameters])
    final url = Uri.http(_url,'3/movie/popular',{ 
      'api_key' : _apiKey, 
      'language': _language,
      'page'    :_popularesPage.toString() // se convierte a string por que asi es que lo recibe
    });
    ////////////////////////////////////////////////////////
    // // instalamos el paquete http
    // final resp = await http.get(url);
    // // transformando el string de resp a un map
    // final decodedData = json.decode(resp.body); // mapeando la respuesta
    // /**
    //  * barriendo cada uno de los resultados que tiene decodeData
    //  * y creando una lista de peliculas
    //  */
    // final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    // return peliculas.items;
    ////////////////////////////////////////////////////////
    /// Metodo 2
    /// await por que regresa un future, en la resp tengo una lista de peliculas
    final resp = await _procesarRespuesta(url: url);
    
    // almacenamos el listado de peliculas que fluyen por Stream en _pupolares
    _pupolares.addAll(resp);
    popularesSink( _pupolares ); // añadiendo info al Stream 

    _cargando=false;
    return resp;
  }

  Future<List<Actor>> getActor(String idMovie) async{
    // Uri. es un metodo de dart
    // Uri.http(authority, String unencodedPath, [Map<String, String> queryParameters])
    final url = Uri.http(_url,'3/movie/$idMovie/credits',{ 
      'api_key' : _apiKey, 
      'language': _language,
      });
    ////////////////////////////////////////////////////////
    // // instalamos el paquete http
    final resp = await http.get(url);
    // transformando el string de resp a un map
    final decodedData = json.decode(resp.body); // mapeando la respuesta
    /**
     * barriendo cada uno de los resultados que tiene decodeData
     * y creando una lista de peliculas
     */
    final cast = new Actores.fromJsonList(decodedData['cast']);
    
    return cast.actores;

  }
  
  Future<List<Pelicula>> getBuscarPelicula(String query) async {
   
    final url = Uri.http(_url, '3/search/movie', {
      'api_key' : _apiKey,
      'language': _language,
      'query'   : query
    });

    return await _procesarRespuesta(url: url);
  }

}