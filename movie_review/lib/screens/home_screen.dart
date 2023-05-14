import 'package:flutter/material.dart';
import 'package:movie_review/providers/movies_provider.dart';
import 'package:movie_review/widgets/widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesPorvider = Provider.of<MoviesProvider>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Películas en cines"),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.search_outlined))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CardSwiper(
                movies: moviesPorvider.onDisplayMovie,
              ),
              MovieSlider(
                title: 'Populares',
                movies: moviesPorvider.popularMovies,
                onNextPage: () => moviesPorvider.getPopularMovies(),
              ),
            ],
          ),
        ));
  }
}
