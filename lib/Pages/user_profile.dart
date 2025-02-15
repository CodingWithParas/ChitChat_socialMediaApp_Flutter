import 'package:chit_chat/Models/user.dart';
import 'package:chit_chat/componenets/my_bio_box.dart';
import 'package:chit_chat/componenets/my_follow_button.dart';
import 'package:chit_chat/componenets/my_input_alertbox_bio.dart';
import 'package:chit_chat/componenets/my_post_tile.dart';
import 'package:chit_chat/componenets/my_profile_stats.dart';
import 'package:chit_chat/helper/navigate_pages.dart';

import 'package:chit_chat/services/auth/auth_service.dart';
import 'package:chit_chat/services/database/database_provider.dart';
import 'package:flutter/material.dart ';
import 'package:provider/provider.dart';

import 'follow_list.dart';

class UserProfilePage extends StatefulWidget {

  String uid;
   UserProfilePage({super.key,
   required this.uid
   });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // provider
  late final listeningProvider =  Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // user info
  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  // text controller for bio
  final bioTextController = TextEditingController();

  // loading....
  bool _isLoading = true;

  //  isfollowing state
  bool _isFollowing = false;

  // on the startup
  @override
  void initState() {
    super.initState();

    // let's load user info
    loadUser();
  }

  Future<void> loadUser() async {
    // get the user profile info
    user = await databaseProvider.userProfile(widget.uid);

    // load followers and following for the user
    await databaseProvider.loadUserFollowers(widget.uid);
    await databaseProvider.loadUserFollowing(widget.uid);

    // update following state
    _isFollowing = databaseProvider.isFollowing(widget.uid);

    // finished loading...
    setState(() {
      _isLoading = false;
    });
  }

  // show edit bio box
  void _showEditBioBox () {
    showDialog(
        context: context,
        builder: (context) => MyInputAlertboxBio(
          hintText: 'Write Bio....',
          textController: bioTextController,
          onPressed: saveBio,
          onPressedText: 'Save',)
    );
  }

  // save updated bio
  Future<void> saveBio()async{
    // start loading...
    setState(() {
      _isLoading = true;
    });

    // update bio
    await databaseProvider.updateBio(bioTextController.text);

    // reload user
    await loadUser();

    // done loading...
    setState(() {
      _isLoading = false;
    });
  }

  // toggle to follow
  Future<void> toggleFollow() async{
    // unfollow
    if (_isFollowing) {
      showDialog(
          context: context,
          builder: (context)=>AlertDialog(
            title: Text("UnFollow"),
            content: Text("Are you sure you want to unfollow?"),
            actions: [
              // cancel
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")
              ),
              // Yes
              TextButton(
                  onPressed: () async {
                    // pop the box
                    Navigator.pop(context);
                    // perform unfollow
                    await databaseProvider.unfollowUser(widget.uid);
                  },
                  child: Text("Yes")
              )
            ],
          ),
      );
    }
    // follow
    else {
      await databaseProvider.followUser(widget.uid);
    }

    // update isfollowing state
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {

    // get the user post
    final allUserPost = listeningProvider.filterUserPosts(widget.uid);

    // listen the all follower and following count
    final followerCount = listeningProvider.getFollowerCount(widget.uid);
    final followingCount = listeningProvider.getFollowingCount(widget.uid);

    // listen to is following
    _isFollowing = listeningProvider.isFollowing(widget.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text('P R O F I L E'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [

          //username handles
          Center(
            child: Text(_isLoading ? "" : user!.name ),
          ),

          const SizedBox(height: 25,),
          // Profile pic
          Center(
            child: CircleAvatar(
              radius: 80,
              child: Image.asset(
                "images/user.png",
              ),
            ),
          ),
          const SizedBox(height: 25,),

          // profile stats -> number of posts / followers / following
          MyProfileStats(
            postCount: allUserPost.length,
            followerCount: followerCount,
            followingCount: followingCount,
            onTap: ()=> Navigator.push(context, MaterialPageRoute(
                builder: (context)=>  FollowListPage(uid: widget.uid,)
              )
            ),
          ),

          const SizedBox(height: 20,),

          // follow and unfollow button
          // only show if the user is viewing someone else's profile
          if (user != null && user!.uid != currentUserId)
            MyFollowButton(
              onPressed: toggleFollow,
              isFollowing: _isFollowing,
            ),

          // edit bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bio",
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 18, fontWeight: FontWeight.w600),
                ),

                // button
                // only show edit button if it's current user page
                if (user != null && user!.uid == currentUserId)
                GestureDetector(
                  onTap: _showEditBioBox,
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )
                )
              ],
            ),
          ),
          const SizedBox(height: 5,),
          // bio
          MyBioBox(text: _isLoading ? "....." : user!.bio),

          Padding(
              padding: EdgeInsets.only(left: 25, top: 25) ,
            child: Text(
              "Posts",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.w500, fontSize: 18
              ),
            ),
          ),

          // user post
          allUserPost.isEmpty ?

          // user post is empty
          const Padding(
            padding: EdgeInsets.all(15.0),
            child:  Center(child: Text("No post yet.."),
            ),
          )
          :
          // user post in NOT Empty
          ListView.builder(
            itemCount: allUserPost.length,
            physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder:(context, index) {
                // get individual post
                final post = allUserPost[index];

                // post tile UI
                return MyPostTile(
                    post: post,
                  onUserTap: (){},
                );
              }
          )

        ],
      ),
    );
  }
}
