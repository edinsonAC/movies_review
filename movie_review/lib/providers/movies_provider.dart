import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie_review/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '7c43f79bcf476a517d803d2ebbad25fd';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovie = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    final response = await http.get(url);

    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromRawJson(jsonData);

    onDisplayMovie = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);

    final popularResponse = PopularResponse.fromRawJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int id) async {
    try {
      if (moviesCast.containsKey(id)) return moviesCast[id]!;
      final jsonData = await _getJsonData('3/movie/$id/credits');
      final casting = CreditsResponse.fromRawJson(jsonData);

      moviesCast[id] = casting.cast;
      return casting.cast;
    } catch (e) {
      return [];
    }
  }
}
