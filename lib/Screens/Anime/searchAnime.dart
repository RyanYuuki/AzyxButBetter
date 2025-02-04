
// ignore_for_file: file_names, must_be_immutable

import 'dart:developer';
import 'package:azyx/components/Anime/_gridlist.dart';
import 'package:azyx/components/Anime/_search_list.dart';
import 'package:azyx/utils/api/Anilist/Anime/anilist_search.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';

class SearchAnime extends StatefulWidget {
  String name;
  SearchAnime({super.key, required this.name});

  @override
  State<SearchAnime> createState() => _SearchpageState();
}

class _SearchpageState extends State<SearchAnime> {
  dynamic data;
  bool isGrid = true;

  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
    fetchdata();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> fetchdata() async {
    try {
      final response = await searchAnilistAnime(widget.name);
      if (response.isNotEmpty) {
        setState(() {
          data = response;
        });
      } else {
        log('Failed to load data');
      }
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  void handleSearch(String text) {
    widget.name = text;
    fetchdata();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              hoverColor: Colors.transparent,
              alignment: Alignment.topLeft,
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 40,
              ),
            ),
            const SizedBox(height: 30),
            const Text("Serach Anime", style: TextStyle(fontFamily: "Poppins-Bold", fontSize: 30),),
            const SizedBox(height: 30,),
            Row(
              children: [
                Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) {
                    setState(() {
                      data = null;
                    });
                    handleSearch(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.search_normal),
                    labelText: "Search Anime",
                    hintText: 'Search Anime',
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1
                      )
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        width: 1
                      )
                    ),
                    fillColor:
                        Theme.of(context).colorScheme.surface,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(width: 10,),
                IconButton(
                   onPressed: () {
                  setState(() {
                    isGrid = !isGrid;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.surfaceContainerHigh),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                ),
                  iconSize: 30,
                  icon: Icon(
                    isGrid ? Ionicons.grid :
                    Iconsax.menu_15,
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
              ],
            ), 
            const SizedBox(height: 10,), 
            Expanded(
              child: data == null ? const Center(child: CircularProgressIndicator(),) : (isGrid
                ? GridList(data: data,route: '/detailspage',)
                : SearchList(data: data)),
            ),
          ],
        ),
      ),
    );
  }
}
