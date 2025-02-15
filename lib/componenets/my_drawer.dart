import 'package:chit_chat/Pages/home_page.dart';
import 'package:chit_chat/Pages/user_profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Pages/chit_chat_page.dart';
import '../Pages/setting_page.dart';
import '../services/auth/auth_service.dart';

class MyDrawer extends StatefulWidget {
   MyDrawer({super.key});

   // access auth service
   final _auth = AuthService();


   @override
   _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  int _page = 0;
  final PageController _pageController = PageController();

   late final List<Widget> _widgetOptions = <Widget>[
     ChitChatPage(),
     HomePage(),
     UserProfilePage(uid: widget._auth.getCurrentUid()),
     SettingPage()
   ];

   void _onItemTapped(int index) {
     setState(() {
       _page = index;
     });
     _pageController.animateToPage(
         index, duration: Duration(milliseconds: 300),
         curve: Curves.easeInOut);
   }

  void _onPageChanged(int index) {
    setState(() {
      _page = index;
    });
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children : _widgetOptions),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
          color: Theme.of(context).colorScheme.primary,
          height: 48,
          items: <Widget>[
            Icon(Icons.home, size: 22,),
            Icon(Icons.chat, size: 22,),
            Icon(Icons.person, size: 22,),
            Icon(Icons.settings, size: 22,),
          ],
        index: _page,
        onTap: _onItemTapped,
      )
    );

  /// OLd DRAWER
    // return Drawer(
    //   backgroundColor: Theme.of(context).colorScheme.background,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Column(
    //         children: [
    //           SizedBox(height: 80,),
    //           // logo
    //           Container(
    //             child: Center(
    //                 child: Image.asset("images/chitchat.png", scale: 3,)
    //             ),
    //           ),
    //           SizedBox(height: 50,),
    //           // home list tile
    //           Padding(
    //             padding: const EdgeInsets.only(left: 20.0),
    //             child: ListTile(
    //               title: Text("H O M E", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
    //               leading: Icon(Icons.home, color: Theme.of(context).colorScheme.inversePrimary,),
    //               onTap: (){
    //                 // pop drawer
    //                 Navigator.pop(context);
    //               },
    //             ),
    //           ),
    //
    //           // Setting List tile
    //           Padding(
    //             padding: const EdgeInsets.only(left: 20.0),
    //             child: ListTile(
    //               title: Text("S E T T I N G", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
    //               leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.inversePrimary,),
    //               onTap: (){
    //                 // pop drawer
    //                 Navigator.pop(context);
    //
    //                 // navigate to setting page
    //                 Navigator.push(context,
    //                     MaterialPageRoute(
    //                         builder: (context)=> SettingPage()));
    //               },
    //             ),
    //           ),
    //         ],
    //       ),
    //       // Logout list tile
    //       Padding(
    //         padding: const EdgeInsets.only(left: 20.0, bottom: 25),
    //         child: ListTile(
    //           title: Text("L O G O U T", style:
    //             TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
    //           leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.inversePrimary,),
    //           onTap: logout
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
