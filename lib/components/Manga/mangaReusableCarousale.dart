
import 'dart:io';

import 'package:azyx/Screens/Anime/details.dart';
import 'package:azyx/Screens/Manga/mangaDetails.dart';
import 'package:azyx/components/Anime/anime_item.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// ignore: must_be_immutable
class MangaReusableList extends StatelessWidget {
  dynamic data;
  final String? name;
  final String? taggName;

  MangaReusableList(
      {super.key, this.data, required this.name, required this.taggName});

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name!,
                style: TextStyle(
                  fontSize: Platform.isAndroid || Platform.isIOS ? 18 : 25,
                  fontFamily: "Poppins-Bold",
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.inverseSurface,
                        Theme.of(context).colorScheme.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                ),
              ),
              Icon(
                Iconsax.arrow_right_4,
                size: Platform.isAndroid || Platform.isIOS ? 25 : 35,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: Platform.isAndroid || Platform.isIOS ? 190 : 300,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: data!.length,
              itemBuilder: (context, index) {
                final tagg = data[index]['id'].toString() + taggName! + index.toString();
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Mangadetails(
                          id: data[index]['id'].toString(),
                          image: data[index]['coverImage']['large'],
                          tagg: tagg,)));
                  },
                  child: ItemCard(id: data[index]['id'].toString(), poster: data[index]['coverImage']['large'], type: data[index]['type'] ?? '', name: data[index]['title']['english'] ?? data[index]['title']['native'] ?? data[index]['title']['romaji'] ?? "Unknown", rating: data[index]['averageScore'] ?? 0, tagg: tagg, status: data[index]['status'],));
              },
            ),
          ),
        ],
      ),
    );
  }
}
