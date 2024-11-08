import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daizy_tv/Provider/manga_sources.dart';
import 'package:daizy_tv/components/Manga/sliderBar.dart';
import 'package:daizy_tv/Hive_Data/appDatabase.dart';
import 'package:daizy_tv/utils/scraper/Manga/Manga_Extenstions/extract_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Read extends StatefulWidget {
  final String mangaId;
  String chapterLink;
  String image;

  Read({
    super.key,
    required this.mangaId,
    required this.chapterLink,
    required this.image,
  });

  @override
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> {
  dynamic chapterData;
  List<dynamic>? chapterImages;
  String? currentChapter;
  String? mangaTitle;
  String? url;
  ExtractClass? source;

  bool isLoading = true;
  bool hasError = false;
  bool isNext = true;
  bool isPrev = true;

  @override
  void initState() {
    super.initState();
    fetchChapterData();
  }

  final ScrollController _scrollController = ScrollController();

  Future<void> fetchChapterData() async {
    final provider = Provider.of<MangaSourcesProvider>(context, listen: false);
    source = provider.instance;
    try {
      if (source != null) {
        final resp = await source!.fetchPages(widget.chapterLink);
        final dataProvider = Provider.of<Data>(context, listen: false);
        
        if (resp != null && resp.toString().isNotEmpty) {
          setState(() {
            chapterImages = resp['images'];
            currentChapter = resp['currentChapter'];
            mangaTitle = resp['title'];
            chapterData = resp;
            isLoading = false;
            isNext = resp['nextChapter'] != null;
            isPrev = resp['previousChapter'] != null;
          });

          dataProvider.addReadsManga(
            mangaId: widget.mangaId,
            mangaTitle: resp['title'],
            currentChapter: chapterData['link'],
            mangaImage: widget.image,
          );
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
          log('Error: Chapter data is empty');
        }
      }
    } catch (e) {
      log('Error: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> fetchChapterImages() async {
    setState(() {
      isLoading = true;
    });
    try {
      final dataProvider = Provider.of<Data>(context, listen: false);
      final data = await source!.fetchPages(url!);
      if (data != null && data.toString().isNotEmpty) {
        setState(() {
          chapterImages = data['images'];
          currentChapter = data['currentChapter'];
          isNext = data['nextChapter'] != null;
          isPrev = data['previousChapter'] != null;
          chapterData = data;
          isLoading = false;
        });

        dataProvider.addReadsManga(
          mangaId: widget.mangaId,
          mangaTitle: mangaTitle!,
          currentChapter: chapterData['link'],
          mangaImage: widget.image,
        );

      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

 void handleChapter(String? direction) async {
  if ((direction == 'right' && chapterData['nextChapter'] != null) ||
      (direction == 'left' && chapterData['previousChapter'] != null)) {
        log(direction == 'right '? 'isright' : 'isleft');
        setState(() {
          url = direction == 'right' ? chapterData['nextChapter'] : chapterData['previousChapter'];
        });
 
    setState(() {
      isNext = false;
      isPrev = false;
      isLoading = true;
    });

    await fetchChapterImages();

    setState(() {
      isNext = chapterData['nextChapter'] != null;
      isPrev = chapterData['previousChapter'] != null;
    });

  }
}


  @override
  Widget build(BuildContext context) {
    return Sliderbar(
      title: isLoading ? '??' : mangaTitle ?? "Unknown",
      chapter: isLoading ? 'Chapter ?' : currentChapter ?? "Unknown",
      totalImages: chapterImages?.length ?? 0,
      scrollController: _scrollController,
      handleChapter: handleChapter,
      isNext: isNext,
      isPrev: isPrev,
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : hasError
                ? const Text('Failed to load data')
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: chapterImages!.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        httpHeaders: {'Referer': widget.chapterLink},
                        imageUrl: chapterImages![index]['image'],
                        fit: BoxFit.cover,
                        placeholder: (context, progress) => SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      );
                    },
                  ),
      ),
    );
  }
}
