
import 'package:daizy_tv/Screens/Bottom_Menu/_profile.dart';
import 'package:daizy_tv/Screens/settings/_about.dart';
import 'package:daizy_tv/Screens/settings/_languages.dart';
import 'package:daizy_tv/Screens/settings/_theme_changer.dart';
import 'package:daizy_tv/Screens/settings/download_settings.dart';
import 'package:daizy_tv/auth/auth_provider.dart';
import 'package:daizy_tv/components/Common/setting_tile.dart';
import 'package:daizy_tv/utils/scraper/Anime/aniwibe_scrapper.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AniListProvider>(context, listen: false);
    
    String userName = provider.userData['name'] ?? "Guest";
    String image = provider.userData?['avatar']?['large'] ?? "";
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("Settings",
              style: TextStyle(fontFamily: "Poppins-Bold")),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                      width: 200,
                      height: 200,
                      child: image != "" && image.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                image,
                                fit: BoxFit.cover,
                              ))
                          : const Icon(
                              Iconsax.user,
                              size: 150,
                            )),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                        fontFamily: "Poppins-Bold", fontSize: 20),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              const SettingTile(
                icon: Icon(Icons.palette),
                name: "Themes",
                routeName: ThemeChange(),
              ),
              const SizedBox(
                height: 10,
              ),
              const SettingTile(
                icon: Icon(Icons.language),
                name: "Languages",
                routeName: Languages(),
              ),
              const SizedBox(
                height: 10,
              ),
              provider.userData['name'] != null
                  ? const SettingTile(
                      icon: Icon(Iconsax.user_tag),
                      name: "Profile",
                      routeName: Profile(),
                    )
                  : const SizedBox.shrink(),
              provider.userData['name'] != null
                  ? const SizedBox(
                      height: 10,
                    )
                  : const SizedBox.shrink(),   
                const SettingTile(
                icon: Icon(Ionicons.cloud_download_sharp),
                name: "Download settings",
                routeName: DownloadSettings(),
              ),
              // const SizedBox(height: 10,),
              // const SettingTile(
              //   icon: Icon(Iconsax.info_circle),
              //   name: "About",
              //   routeName: About(),
              // ),
              ElevatedButton(onPressed: (){
                scrapeSearchdata();
              }, child: Text("Fetch"))
            ],
          ),
        ));
  }
}
