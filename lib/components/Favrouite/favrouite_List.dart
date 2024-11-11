import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FavrouiteList extends StatelessWidget {
  dynamic data;
  final String route;
   FavrouiteList({super.key, required this.data, required this.route});

  @override
  Widget build(BuildContext context) {
    if(data == null){
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                childAspectRatio: 0.56),
            itemCount: data!.length,
            itemBuilder: (context, index) {
              final tagg = '${data![index]['id']}new';
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, route, arguments: {
                    "id": data![index]['id'].toString(),
                    "image": data![index]['image'],
                    "tagg": tagg
                  });
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 150,
                          width: 103,
                          margin: const EdgeInsets.only(right: 10),
                          child: Hero(
                            tag: tagg,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: data![index]['image'],
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Center(
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data![index]['title'].length > 12
                          ? '${data![index]['title'].substring(0, 10)}...'
                          : data![index]['title'],
                      style: const TextStyle(fontFamily: "Poppins-Bold"),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
