import 'dart:developer';

import 'package:daizy_tv/auth/auth_provider.dart';
import 'package:daizy_tv/backupData/anilist_anime.dart';
import 'package:daizy_tv/backupData/anilist_manga.dart';
import 'package:daizy_tv/components/Anime/reusableList.dart';
import 'package:daizy_tv/components/Common/user_lists.dart';
import 'package:daizy_tv/components/Common/Header.dart';
import 'package:daizy_tv/components/Recently-added/animeCarousale.dart';
import 'package:daizy_tv/components/Recently-added/mangaCarousale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic recomendAnime;
  dynamic recomendManga;

  @override
  void initState() {
    super.initState();
    data();
  }

  void data() {
    setState(() {
      recomendAnime = fallbackAnilistData['data']["trendingAnimes"]['media'];
      recomendManga = fallbackMangaData['data']["trendingManga"]['media'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // var box = Hive.box("app-data");
    // final provider = Provider.of<AniListProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Header(
              name: "Fun",
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer<AniListProvider>(
              builder: (context, provider, child) {
                return provider.userData['name'] != null
                    ? const UserLists()
                    : const SizedBox.shrink();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer<AniListProvider>(
              builder: (context, provider, child) {
                final data = provider.userData['animeList'] != null ? provider.userData['animeList']
                    .where((anime) => anime['status'] == "CURRENT")
                    .toList() : [];
                return data != null && provider.userData['animeList'] != null
                    ? Animecarousale(
                        carosaleData: data)
                    : const SizedBox.shrink();
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Consumer<AniListProvider>(
              builder: (context, provider, child) {
                final data = provider.userData['mangaList'] != null ? provider.userData['mangaList']
                    .where((anime) => anime['status'] == "CURRENT")
                    .toList() : [];
                return data != null && provider.userData['mangaList'] != null
                    ? Mangacarousale(
                        carosaleData: data)
                    : const SizedBox.shrink();
              },
            ),
            ReusableList(
                name: "Recommend Animes",
                taggName: "recommended",
                route: '/detailspage',
                data: recomendAnime),
            const SizedBox(
              height: 20,
            ),
            ReusableList(
                name: "Recommend Mangas",
                taggName: "recommended",
                route: '/mangaDetail',
                data: recomendManga),
          ],
        ),
      ),
    );
  }
}
