import 'package:chit_chat/Pages/account_setting_page.dart';
import 'package:chit_chat/componenets/help_and_support.dart';
import 'package:chit_chat/Theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import 'blocked_user_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  void logout (){
    // get auth service
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("S E T T I N G S"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              // dark mode button
              Container(
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.secondary
                ),
                margin: EdgeInsets.only(left: 25, right: 25),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // dark mode
                    Text("Dark Mode",
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),

                    // switch toggle
                    CupertinoSwitch(
                      value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                      onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15,),
              // blockUser Button
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=> BlockedUserPage())
                  );
                },
                child:  Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.secondary
                  ),
                  margin: EdgeInsets.only(left: 25, right: 25),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // dark mode
                      Text("Blocked Users",
                        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),

                      // button to go to blocked user page
                      IconButton(onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=> BlockedUserPage())),
                        icon: Icon(Icons.block, color: Theme.of(context).colorScheme.inversePrimary,),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15,),

              // help and support button
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=> HelpAndSupport())
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.secondary
                  ),
                  margin: EdgeInsets.only(left: 25, right: 25),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // help and Support button
                      Text("Help & Support",
                        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),

                      // button for logout the user
                      IconButton(onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context)=> HelpAndSupport()
                            )
                        );
                      },
                        icon: Icon(Icons.help_outline
                          , color: Theme.of(context).colorScheme.inversePrimary, ),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15,),

              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=> AccountSettingPage())
                  );
                },
                child:  Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.secondary
                  ),
                  margin: EdgeInsets.only(left: 25, right: 25),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // dark mode
                      Text("Manage Account",
                        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),

                      // button to go to blocked user page
                      IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AccountSettingPage()));
                        },
                        icon: Icon(Icons.manage_accounts_outlined, color: Theme.of(context).colorScheme.inversePrimary,),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15,),

              // logout button
              GestureDetector(
                onTap: logout,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.secondary
                  ),
                  margin: EdgeInsets.only(left: 25, right: 25),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // logout button
                      Text("LogOut",
                        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),

                      // button for logout the user
                      IconButton(onPressed: logout,
                        icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.inversePrimary,),
                      )
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
}

// Container(
//                 dark mode button
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Theme.of(context).colorScheme.secondary
//               ),
//               margin: EdgeInsets.all(25),
//               padding: EdgeInsets.all(15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // dark mode
//                   Text("Dark Mode",
//                     style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
//
//                   // switch toggle
//                   CupertinoSwitch(
//                     value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
//                     onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false)
//                         .toggleTheme(),
//                   ),
//                 ],
//               ),
//             ),