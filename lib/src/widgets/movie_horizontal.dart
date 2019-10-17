import 'package:flutter/material.dart';
import 'package:movies/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePage;

  MovieHorizontal({@required this.peliculas, @required this.siguientePage});

  final _pageCtrl = PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageCtrl.addListener(() {
      if (_pageCtrl.position.pixels >=
          _pageCtrl.position.maxScrollExtent - 200) {
        siguientePage();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
          pageSnapping: false, // para que no se mueva el slide como con imán
          controller: _pageCtrl,
          itemCount: peliculas
              .length, // indica cuantos items se van a renderizar, sin esto tira error
          itemBuilder: (BuildContext context, i) =>
              _card(context, peliculas[i])),
    );
  }

  Widget _card(BuildContext context, Pelicula pelicula) {

    pelicula.uniqueId = '${pelicula.id}-poster';
    
    final card = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 117.0, //cambiar
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            pelicula.title,
            overflow: TextOverflow
                .ellipsis, // si el texto supera el tamañano asignado agrega "..."
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );

    return GestureDetector(
      child: card,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }

/* Método opcional para el pageView sin el .builder
  List<Widget> _cardList(BuildContext context) {
    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 117.0, //cambiar
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              pelicula.title,
              overflow: TextOverflow
                  .ellipsis, // si el texto supera el tamañano asignado agrega "..."
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    }).toList();
  }*/
}
