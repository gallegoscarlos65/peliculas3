// La idea de un provider es que sea el provedor de información
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

//Para que sea un provider valido debe de extender de ChangeNotifier
class MoviesProvider extends ChangeNotifier{

  String _apiKey = '2de8725bc42797c6994595b13b4c1791';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  int _popularPage = 0;
  //Constructor
  MoviesProvider(){
    print('MoviesProvider inicializado');

    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async{
    var url = Uri.https(_baseUrl, endpoint, {
      'api_key':_apiKey,
      'language':_language,
      'page': '$page'
    });
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async{
    // TODO: Optimizacion de codigo
    // var url = Uri.https(_baseUrl, '3/movie/now_playing', {
    //   'api_key': _apiKey,
    //   'language': _language,
    //   'page': '1'
    //   });
  
    final jsonData= await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    //Con esto ya se puede tratar como un mapa
    print(nowPlayingResponse.results[1].title);
    //print(response.body);
    onDisplayMovies = nowPlayingResponse.results;
    //Le dice a todos los widgets que estan escuchando que sucedio un cambio que lo redibuje, solo se va a redibujar lo necesario
    notifyListeners();
  }

  getPopularMovies() async {

    _popularPage++;

    final jsonData= await this._getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    //Con esto ya se puede tratar como un mapa
    //Desestructuracicion ...
    //...Toma todas las peliculas populares y despues le va a concatenar todas las demas
    popularMovies = [...popularMovies, ...popularResponse.results];
    print(popularMovies[0]);
    //Le dice a todos los widgets que estan escuchando que sucedio un cambio que lo redibuje, solo se va a redibujar lo necesario
    notifyListeners();
  }

}