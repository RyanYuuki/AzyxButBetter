// ignore_for_file: file_names
import 'package:azyx/Extensions/ExtensionScreen.dart';
import 'package:azyx/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class Header extends StatefulWidget {
  final String? name;
  const Header({super.key, this.name});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box("mybox");
    final provider = Provider.of<AniListProvider>(context);

    final userData = provider.userData;
    final bool isLoggedIn = userData != null;
    final String image = isLoggedIn ? userData?['avatar']?['large'] ?? "" : "";
    final String userName = isLoggedIn ? userData['name'] ?? "Guest" : "Guest";

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box box, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Enjoy unlimited ${widget.name ?? 'content'}!",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _displayBottomSheet(context, box);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: image.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 30,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _displayBottomSheet(BuildContext context, Box box) {
    final provider = Provider.of<AniListProvider>(context, listen: false);
    final userData = provider.userData;
    final bool isLoggedIn = userData != null;
    final String userName = isLoggedIn ? userData['name'] ?? "Guest" : "Guest";
    final String image = isLoggedIn ? userData?['avatar']?['large'] ?? "" : "";

    return showModalBottomSheet(
      context: context,
      barrierColor: Colors.black87.withOpacity(0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: userData['name'] != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color:
                          Theme.of(context).colorScheme.onPrimaryFixedVariant,
                    ),
                    child: isLoggedIn
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Iconsax.user,
                                  color: Colors.white,
                                  size: 30,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Iconsax.user,
                            color: Colors.white,
                            size: 30,
                          ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    userData?['name'] != null
                        ? Navigator.pushNamed(context, './profile')
                        : Navigator.pushNamed(context, "/login-page");
                  });
                },
                child: userData?['name'] != null
                    ? Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: Row(
                          children: [
                            coloredIcon(context, const Icon(Ionicons.people)),
                            const SizedBox(width: 20),
                            const Text(
                              "Profile",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    Navigator.pushNamed(context, './settings');
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      coloredIcon(context, const Icon(Icons.settings)),
                      const SizedBox(width: 20),
                      const Text(
                        "Setting",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ExtensionScreen()));
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      coloredIcon(context, const Icon(Icons.extension)),
                      const SizedBox(width: 20),
                      const Text(
                        "Extensions",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    provider.userData?['name'] != null
                        ? provider.logout(context)
                        : provider.login(context);
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Row(
                    children: [
                      box.get("userName") != null
                          ? coloredIcon(context, const Icon(Iconsax.login))
                          : coloredIcon(context, const Icon(Iconsax.logout)),
                      const SizedBox(width: 20),
                      Text(
                        userData['name'] != null ? "LogOut" : "LogIn",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container coloredIcon(BuildContext context, Icon icon) {
    return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(50)),
        child: icon);
  }
}
