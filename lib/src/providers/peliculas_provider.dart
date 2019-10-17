import 'package:http/http.dart' as http;
import 'package:movies/src/models/actor_model.dart';
import 'dart:async';
import 'dart:convert';

import 'package:movies/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apiKey = '52cb11a53ac5ffbfdc062df51361e04c';
  String _url = 'api.themoviedb.org';
  String _language = 'es_ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = List();

  final _popularesStreamCtrl = StreamController<List<Pelicula>>.broadcast();
  //broadcast permite al stream ser escuchado de varios lados

  Function(List<Pelicula>) get popularesSink => _popularesStreamCtrl.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamCtrl.stream;

  void disposeStreams() {
    // cuando se deja de usar un stream (al cerrar un page por ej) hay que cerrar el stream
    _popularesStreamCtrl?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final result = await http.get(url);
    final decodedData = json.decode(result.body);

    final peliculas = Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    /* code sin usar la función _procesarRespuesta
    final result = await http.get(url);
    final decodedData = json.decode(result.body);
    final peliculas = Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items; */

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;
    _popularesPage++;

    print('cargando siguientes peliculas al slide...');

    final url = Uri.http(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': 'es_ES',
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliculaId) async {
    final url = Uri.https(_url, '3/movie/$peliculaId/credits',
        {'api_key': _apiKey, 'language': _language,});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(
      _url,
      '3/search/movie',
      {'api_key': _apiKey, 'language': _language, 'query': query},
    );

    return await _procesarRespuesta(url);
  }
}
