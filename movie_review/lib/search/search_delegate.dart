import 'package:flutter/material.dart';
import 'package:movie_review/models/movie.dart';
import 'package:movie_review/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return _emptyContainer();
        }
        final movies = snapshot.data;
        return ListView.builder(
            itemCount: movies!.length,
            itemBuilder: (_, int index) => _MovieItem(movie: movies[index]));
      },
    );
  }

  Widget _emptyContainer() {
    return const Center(
      child:
          Icon(Icons.movie_creation_outlined, color: Colors.black87, size: 130),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return _emptyContainer();
        }
        final movies = snapshot.data;
        return ListView.builder(
            itemCount: movies!.length,
            itemBuilder: (_, int index) => _MovieItem(movie: movies[index]));
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.heroId}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpg'),
            image: NetworkImage(movie.fullPosterImg),
            height: 100,
            width: 40,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}
