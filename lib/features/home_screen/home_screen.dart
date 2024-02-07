import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uct_chat/features/home_screen/cubit/home_screen_cubit.dart';
import 'package:uct_chat/features/home_screen/widgets/calls_tab.dart';
import 'package:uct_chat/features/home_screen/widgets/chats_tab.dart';
import 'package:uct_chat/features/home_screen/widgets/updates_tab.dart';

import '../../api/apis.dart';
import '../profile_screen/profile_screen.dart';

//home screen -- where all available contacts are shown
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;
  @override
  void initState() {
    initAnimation();
    super.initState();
    APIs.getSelfInfo();
    viewMode();
  }

  @override
  Widget build(BuildContext context) {
    var homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    return BlocConsumer<HomeScreenCubit, HomeScreenState>(
      listener: (context, state) {},
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "Chats",
                  ),
                  Tab(
                    text: "Updates",
                  ),
                  Tab(
                    text: "Leaves",
                  ),
                ],
              ),
              leading: const Icon(CupertinoIcons.home),
              title: homeScreenCubit.isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search..',
                      ),
                      autofocus: true,
                      style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                      //when search text changes then updated search list
                      onChanged: (val) {
                        homeScreenCubit.onChanged(val);
                      },
                    )
                  : const Text('UCT Chat'),
              actions: [
                //search user button
                IconButton(
                  onPressed: () {
                    homeScreenCubit.changeIsSearching();
                  },
                  icon: Icon(homeScreenCubit.isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search),
                ),

                //more features button
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: APIs.me)));
                  },
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
            body: TabBarView(
              children: [
                ChatsTab(
                  homeScreenCubit: homeScreenCubit,
                  animation: _animation,
                  animationController: _animationController,
                ),
                const UpdatesTab(),
                const LeavesTab(),
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
