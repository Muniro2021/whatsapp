import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uct_chat/features/profile_screen/profile_screen.dart';
import 'package:uct_chat/features/user_home_feature/cubit/home_screen_cubit.dart';
import 'package:uct_chat/features/user_home_feature/widgets/chats_tab.dart';
import 'package:uct_chat/features/user_home_feature/widgets/leaves_tab.dart';
import 'package:uct_chat/features/user_home_feature/widgets/updates_tab.dart';
import 'package:uct_chat/features/user_statistics_feature/statistics.dart';

import '../../api/apis.dart';

//home screen -- where all available contacts are shown
class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;
  @override
  void initState() {
    initAnimation();
    super.initState();
    APIs.getSelfInfo(APIs.me.role);
    viewMode();
  }

  @override
  Widget build(BuildContext context) {
    var homeScreenCubit = BlocProvider.of<UserHomeScreenCubit>(context);
    return BlocConsumer<UserHomeScreenCubit, UserHomeScreenState>(
      listener: (context, state) {},
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                indicatorColor: Colors.orange,
                tabs: [
                  Tab(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontFamily: 'Unna',
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      child: Text("Chats"),
                    ),
                  ),
                  Tab(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontFamily: 'Unna',
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      child: Text("Updates"),
                    ),
                  ),
                  Tab(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontFamily: 'Unna',
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      child: Text("Leaves"),
                    ),
                  ),
                ],
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(user: APIs.me),
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: APIs.me.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'UCT Chat',
                    style: TextStyle(
                      fontFamily: 'Unna',
                      fontSize: 30,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'user_statistics') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const UserStatistic(),
                          ),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'user_statistics',
                        child: Text('User Statistics'),
                      ),
                    ],
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                UsersChatsTab(
                  homeScreenCubit: homeScreenCubit,
                  animation: _animation,
                  animationController: _animationController,
                ),
                const UsersUpdatesTab(),
                const UsersLeavesTab(),
              ],
            ),
          ),
        );
      },
    );
  }

  void viewMode() {
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  void initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }
}
