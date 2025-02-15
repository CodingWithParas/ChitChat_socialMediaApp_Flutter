  /*
      Follow List Page

      This page display a tab bar for ( a given Uid )

      -- a list of all followers
      -- a list of all following

   */

  import 'package:chit_chat/componenets/my_user_tile_for_following%20list.dart';
import 'package:chit_chat/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/user.dart';

  class FollowListPage extends StatefulWidget {

    String uid;
    FollowListPage({super.key, required this.uid});

    @override
    State<FollowListPage> createState() => _FollowListPageState();
  }

  class _FollowListPageState extends State<FollowListPage> {

    // PROVIDERS
    late final listeningProvider = Provider.of<DatabaseProvider>(context);
    late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

    // on the startup
    @override
  void initState() {
      super.initState();

      // load follower list
      loadFollowerList();

      // load following list
      loadFollowingList();

  }

    // load followers
    Future<void> loadFollowerList() async {
      await databaseProvider.loadUserFollowerProfiles(widget.uid);
    }

    // load following
    Future<void> loadFollowingList() async {
      await databaseProvider.loadUserFollowingProfiles(widget.uid);
    }

    @override
    Widget build(BuildContext context) {

      // listen to followers and following
      final followers = listeningProvider.getListOfFollowersProfile(widget.uid);
      final following = listeningProvider.getListOfFollowingProfile(widget.uid);

      return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,

              bottom: TabBar(
                dividerColor: Colors.transparent,
                labelColor: Theme.of(context).colorScheme.inversePrimary,
                unselectedLabelColor: Theme.of(context).colorScheme.primary,
                tabs: const[
                  Tab(text: "Followers",),

                  Tab(text: "Following"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildUserList(
                    followers,
                    "No Followers.."
                ),
                _buildUserList(
                    following,
                    "No Following.."
                ),
              ],
            ),
          )
      );
    }

    // build the user list , given a list of profile
    Widget _buildUserList(List<UserProfile>userList, String emptyMessage){
      return userList.isEmpty
          ?
          // empty message if there are no users
      Center(child: Text(emptyMessage),)
          :
          // user list
      ListView.builder(
        itemCount: userList.length,
          itemBuilder: (context, index) {
            // get each user
            final user = userList[index];

            // return as a user list tile
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: MyUserTileForFollowingList(user: user),
            );
          }
      );
    }
  }
