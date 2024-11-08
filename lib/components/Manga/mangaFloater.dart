import 'dart:developer';
import 'dart:ui';

import 'package:daizy_tv/Hive_Data/appDatabase.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class Mangafloater extends StatelessWidget {
final String? id;
final String? image;
final String? title;

  const Mangafloater({super.key,required this.id, this.image, this.title});

  @override
  Widget build(BuildContext context) {    
     final provider = Provider.of<Data>(context);
    final currentChapter =
        provider.getCurrentChapterForManga(id!) ?? 'chapter-1';

    return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            margin: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 130),
                            child: TextScroll(
                              title!,
                              mode: TextScrollMode.bouncing,
                              velocity: const Velocity(
                                  pixelsPerSecond: Offset(20, 0)),
                              delayBefore: const Duration(milliseconds: 500),
                              pauseBetween:
                                  const Duration(milliseconds: 1000),
                              textAlign: TextAlign.center,
                              selectable: true,
                              style: const TextStyle( fontFamily: "Poppins-Bold")
                            ),
                          ),
                          Text(
                            currentChapter.isEmpty
                                  ? 'Chapter 1'
                                  : currentChapter,
                            style: const TextStyle(
                                color: Color.fromARGB(187, 141, 135, 135), fontFamily: "Poppins-Bold"),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/read',
                              arguments: {"mangaId": id, "chapterId":currentChapter, "image": image});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Theme.of(context).colorScheme.inverseSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:  Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Ionicons.book,
                               color: Theme.of(context).colorScheme.inversePrimary, // Icon color
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Read',
                              style: TextStyle(
                                 color: Theme.of(context).colorScheme.surface,
                                 fontFamily: "Poppins-Bold" // Text color
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }
}