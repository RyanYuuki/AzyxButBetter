// import 'dart:convert';
// import 'dart:developer';

// import 'package:daizy_tv/components/Anime/episode_list.dart';
// import 'package:daizy_tv/components/Anime/reusableList.dart';
// import 'package:daizy_tv/components/Anime/videoplayer.dart';
// import 'package:daizy_tv/dataBase/appDatabase.dart';
// import 'package:daizy_tv/scraper/episodeScrapper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;
// import 'package:iconsax/iconsax.dart';
// import 'package:ionicons/ionicons.dart';

// import 'package:lite_rolling_switch/lite_rolling_switch.dart';
// import 'package:provider/provider.dart';
// import 'package:text_scroll/text_scroll.dart';

// class Stream extends StatefulWidget {
//   final String id;
//   const Stream({super.key, required this.id});

//   @override
//   State<Stream> createState() => _StreamState();
// }

// class _StreamState extends State<Stream> {
//   dynamic episodeData;
//   dynamic filteredEpisodes;
//   dynamic AnimeData;
//   dynamic Episode;
//   int? episodeId;
//   String? category;
//   dynamic tracks;
//   bool dub = false;
//   final box = Hive.box("mybox");

//   TextEditingController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//   final String baseUrl = 'https://goodproxy.goodproxy.workers.dev/fetch?url=${dotenv.get("HIANIME_URL")}anime/info?id=';
//   final String episodeUrl =
//       '${dotenv.get("HIANIME_URL")}anime/episode-srcs?id=';

//   Future<void> fetchData() async {
//     log(baseUrl + widget.id);
//     try {
//       final provider = Provider.of<Data>(context, listen: false);
//       final response = await http.get(Uri.parse(baseUrl + widget.id));
//       final episodeResponse =
//           await scrapeAnimeEpisodes(widget.id);
//           log(episodeResponse.toString());
//           setState(() {
//             episodeData = episodeResponse['episodes'];
//           filteredEpisodes = episodeData;
//           });
//       if (response.statusCode == 200) {
//         final tempAnimeData = jsonDecode(response.body);

//         setState(() {
//           AnimeData = tempAnimeData;
//           episodeId = int.tryParse(provider.getCurrentEpisodeForAnime(
//               AnimeData['anime']['info']['id']?.toString() ?? '1')!);
//           category = 'sub';
//           provider.addWatchedAnimes(
//               animeId: AnimeData['anime']['info']['id'],
//               animeTitle: AnimeData['anime']['info']['name'],
//               currentEpisode: episodeId?.toString() ?? '',
//               posterImage: AnimeData['anime']['info']['poster']);
//         });

//         await fetchEpisode();
//       } else {
//         log("Failed to load data");
//       }
//     } catch (e) {
//       log("Error occurred: $e");
//     }
//   }

//   Future<void> fetchEpisode() async {
//     if (episodeData == null || episodeId == null) return;
//     try {
//       final provider = Provider.of<Data>(context, listen: false);
//       final episodeIdValue = episodeData[(episodeId! - 1)]['episodeId'];
//       final response = await http.get(Uri.parse(
//           '$episodeUrl$episodeIdValue?server=vidstreaming&category=$category'));
//       final captionsResponse = await http.get(Uri.parse(
//           '$episodeUrl$episodeIdValue&category=sub'));
//           log('$episodeUrl$episodeIdValue?server=vidstreaming&category=$category');
//       if (response.statusCode == 200) {
//         final decodeData = jsonDecode(response.body);
//         final tempdata = jsonDecode(captionsResponse.body);
//         setState(() {
//           Episode = decodeData['sources'][0]["url"];
//           tracks = tempdata['tracks'];
//         });
//         provider.addWatchedAnimes(
//             animeId: AnimeData['anime']['info']['id'],
//             animeTitle: AnimeData['anime']['info']['name'],
//             currentEpisode: episodeId!.toString(),
//             posterImage: AnimeData['anime']['info']['poster']);
//       } else {
//         log('Error fetching episode data');
//       }
//     } catch (e) {
//       log("Error in fetchEpisode: $e");
//     }
//   }

//   void handleEpisode(int? episode) {
//     if (episode != null) {
//       setState(() {
//         episodeId = episode;
//         Episode = "";
//       });
//       fetchEpisode();
//     }
//   }

//   void handleCategory(String newCategory) {
//     if (episodeData != null && AnimeData['anime']['info']['stats']['episodes']['dub'] >= episodeId) {
//       setState(() {
//         category = newCategory;
//         Episode = "";
//         log(newCategory);
//       });
//       fetchEpisode();
//     }
//   }

//   void handleEpisodeList(String value) {
//     setState(() {
//       if (value.isEmpty) {
//         filteredEpisodes = episodeData; 
//       } else {
//         filteredEpisodes = episodeData?.where((episode) {
//           final episodes = episode['number']?.toString() ?? '';
//           return episodes.contains(value);
//         }).toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (episodeData == null || AnimeData == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: TextScroll(
//           AnimeData['anime']['info']['name'].toString(),
//           mode: TextScrollMode.bouncing,
//           velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
//           delayBefore: const Duration(milliseconds: 500),
//           pauseBetween: const Duration(milliseconds: 1000),
//           textAlign: TextAlign.center,
//           selectable: true,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//       ),
//       body: ListView(
//         children: [
//           tracks != null ?
//           MediaPlayer(
//             Episode: Episode,
//             tracks: tracks,
//           ) : const SizedBox(
//               height: 200,
//             child: Center(child: CircularProgressIndicator()),),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Episode ${episodeId ?? 0}',
//                   style: const TextStyle(
//                       fontSize: 20, fontFamily: "Poppins-Bold"),
//                 ),
//                 Swicther(),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: TextField(
//               controller: _controller,
//               onChanged: (value) {
//                 handleEpisodeList(value);
//               },
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Iconsax.search_normal),
//                 hintText: 'Search Episode...',
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: BorderSide(
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: BorderSide.none,
//                 ),
//                 fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
//                 filled: true,
//               ),
//             ),
//           ),
//           EpisodeList(filteredEpisodes: filteredEpisodes, episodeId: episodeId, handleEpisode: handleEpisode),
//           const SizedBox(
//             height: 10,
//           ),
//           Column(
//             children: [
//               AnimeData['mostPopularAnimes']?.isNotEmpty == true
//                   ? ReusableList(
//                       name: "Popular Animes",
//                       data: AnimeData['mostPopularAnimes'],
//                       taggName: "Popular",
//                     )
//                   : const SizedBox.shrink(),
//               const SizedBox(
//                 height: 10,
//               ),
//               ReusableList(
//                 name: "Related Animes",
//                 data: AnimeData['relatedAnimes'],
//                 taggName: "Related",
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               ReusableList(
//                 name: "Recommended Animes",
//                 data: AnimeData['recommendedAnimes'],
//                 taggName: "Recommended",
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ignore: non_constant_identifier_names
//   LiteRollingSwitch Swicther() {
//     return LiteRollingSwitch(
//       value: true,
//       width: 150,
//       textOn: 'Sub',
//       textOff: 'Dub',
//       textOnColor: Colors.white,
//       colorOn: Theme.of(context).colorScheme.onSecondaryFixedVariant,
//       colorOff: Theme.of(context).colorScheme.onTertiaryFixedVariant,
//       iconOn: Icons.closed_caption,
//       iconOff: Icons.mic,
//       animationDuration: const Duration(milliseconds: 300),
//       onChanged: (bool state) {
//         handleCategory(state ? 'sub' : 'dub');
//       },
//       onDoubleTap: () => {},
//       onSwipe: () => {},
//       onTap: () => {},
//     );
//   }

//   // Padding EpisodeList() {
//   //   return Padding(
//   //     padding: const EdgeInsets.all(8.0),
//   //     child: Container(
//   //       height: 350,
//   //       decoration: BoxDecoration(
//   //           color: Theme.of(context).colorScheme.surfaceContainer,
//   //           borderRadius: BorderRadius.circular(20)),
//   //       width: MediaQuery.of(context).size.width,
//   //       child: Padding(
//   //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//   //         child: ListView.builder(
//   //           shrinkWrap: true,
//   //           itemCount: filteredEpisodes?.length ?? 0,
//   //           itemBuilder: (context, index) {
//   //             final item = filteredEpisodes![index];
//   //             final title = item['title'];
//   //             final episodeNumber = item['number'];
//   //             return GestureDetector(
//   //               onTap: () => handleEpisode(episodeNumber),
//   //               child: Container(
//   //                 margin: const EdgeInsets.only(top: 10),
//   //                 decoration: BoxDecoration(
//   //                     borderRadius: BorderRadius.circular(10),
//   //                     border: Border(left: BorderSide(width: 5, color: Theme.of(context).colorScheme.primary)),
//   //                     color: episodeNumber == episodeId
//   //                         ? Theme.of(context).colorScheme.inversePrimary
//   //                         : Theme.of(context)
//   //                             .colorScheme
//   //                             .surfaceContainerHighest),
//   //                 child: Padding(
//   //                   padding:  const EdgeInsets.all(15),
//   //                   child: Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: [
//   //                       SizedBox(
//   //                         width: 220,
//   //                         child: Text(
//   //                           title.length > 25 ? '${title.substring(0, 25)}...' : title,
//   //                           style: TextStyle(
//   //                               color: Theme.of(context)
//   //                                   .colorScheme
//   //                                   .inverseSurface,
//   //                               fontFamily: "Poppins-Bold"),
//   //                         ),
//   //                       ),
//   //                       episodeNumber == episodeId
//   //                           ? Icon(
//   //                               Ionicons.play,
//   //                               color: Theme.of(context)
//   //                                   .colorScheme
//   //                                   .inverseSurface,
//   //                             )
//   //                           : Text(
//   //                               'Ep- $episodeNumber',
//   //                               style: TextStyle(
//   //                                   fontSize: 14,
//   //                                   color: Theme.of(context)
//   //                                       .colorScheme
//   //                                       .inverseSurface,
//   //                                   fontWeight: FontWeight.w500),
//   //                             )
//   //                     ],
//   //                   ),
//   //                 ),
//   //               ),
//   //             );
//   //           },
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
// }
