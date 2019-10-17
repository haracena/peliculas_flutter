import 'package:flutter/material.dart';
import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  
  String seleccion;
  final peliculasProvider = PeliculasProvider();

  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Don wea',
    'Super juanito'
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitam America'
  ];


  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = ''; // valor de búsqueda
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que se mostrarán
    return Center(
      child: Container(
        child: Text(seleccion),
      ),
    );
  }

    @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando el user escribe
    if(query.isEmpty){
      return Container();
    } else {
      return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.map((pelicula) {
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets(img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(pelicula.title),
                  subtitle: Text(pelicula.originalTitle),
                  onTap: (){
                    close(context, null);
                    pelicula.uniqueId = ''; // para que no de error el Hero animation
                    Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                  },
                );
              }).toList()
            );
          } else {
            return Center(
              child: CircularProgressIndicator()
            );
          }
        },
      );
    }
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Son las sugerencias que aparecen cuando el user escribe

  //   final listaSugerida = (query.isEmpty) 
  //                         ? peliculasRecientes 
  //                         : peliculas.where(
  //                           (pelicula) => pelicula.toLowerCase().startsWith(query.toLowerCase())
  //                         ).toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugerida[i]),
  //         onTap: (){
  //           seleccion = listaSugerida[i];
  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  // }

}