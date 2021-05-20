/// Modelo para agrupar varios Actores, se crea una instancia
/// de actores, y esta instancia recibe una lista de actores
/// y a su vez mapea todos los actores
class Actores {
  List<Actor> actores = new List(); // lista dinamica

  /// Constructor
  Actores.fromJsonList(List<dynamic> jsonList){
    if ( jsonList == null ) return; // si esta vacio no hace nada
    // recorriendo cada uno de los elementos que se encuentran en el jsonList
    jsonList.forEach((item){
      //creamos una instancia de actor
      final actor = new Actor.fromJsonMap(item);
      // agregando el actor a la lista de actores
      actores.add(actor);

    });
  }
}

/// clase para un solo actor 
class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  /// metodo para recibir la informacion en una mapa y asignar 
  /// cada una de las propiedades del map a las propiedades de 
  /// la clase actor, a su vez crea una instancia de la clase 
  Actor.fromJsonMap(Map<String, dynamic> json) {
    castId      = json['cast_id'];
    character   = json['character'];
    creditId    = json['credit_id'];
    gender      = json['gender'];
    id          = json['id'];
    name        = json['name'];
    order       = json['order'];
    profilePath = json['profile_path'];
  }
  /// Este metodo permite obtener la foto del actor
  getFoto(){
    // en caso que no tenga imagen en el poster_path
    if (profilePath == null) {
      return 'http://forum.spaceengine.org/styles/se/theme/images/no_avatar.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}

