import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie_review/helpers/debouncer.dart';
import 'package:movie_review/models/models.dart';
import 'package:movie_review/models/search_movie_response.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '7c43f79bcf476a517d803d2ebbad25fd';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovie = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionsStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionsStreamController.stream;

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint,
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

  Future<List<Movie>> searchMovies(String query) async {
    var url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromRawJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovies(value);
      _suggestionsStreamController.add(results);
    };
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((value) => timer.cancel());
  }
}
