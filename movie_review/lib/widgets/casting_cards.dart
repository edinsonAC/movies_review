// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_review/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class CastingCards extends StatelessWidget {
  final int id;

  const CastingCards({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final moviesPorvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesPorvider.getMovieCast(id),
      builder: (BuildContext context, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 300),
            height: 180,
            child: const CupertinoActivityIndicator(),
          );
        }
        final cast = snapshot.data!;
        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return _CastCard(actor: cast[index]);
            },
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({super.key, required this.actor});
  final Cast actor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
