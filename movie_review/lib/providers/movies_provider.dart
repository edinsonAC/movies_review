import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '7c43f79bcf476a517d803d2ebbad25fd';
  final String _language = 'es-ES';

  MoviesProvider() {
    print('Movies initial');
    getOnDisplayMovies();
  }

  getOnDisplayMovies() async {
    print('getOnDisplayMovies');
    var url = Uri.https(_baseUrl, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language, 'page': '1'});

    final response = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(response.body);

    print(decodedData['dates']);
  }
}
