
/* -------- ACCOUNT SETTING PAGE -----------------*/
/*
    This page contains various setting releated to user account

    - delete own account
    --- and many more

 */



import 'package:chit_chat/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({super.key});

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {

  // ask for the confirmation from the user before deleteing the account
  void _confirmDeletion(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Account"),
          content: const Text("Are you sure you want to Delete your Account?"),
          actions: [
            // cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            // delete button
            TextButton(
              onPressed: () async{

                // delete account
                await AuthService().deleteAccount();

                // then navigate to initial account route (AuthGate() page)
                Navigator.pushNamedAndRemoveUntil(context, '/', (route)=> false);

              },
              child: const Text("Delete"),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MANAGE ACCOUNT"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // delete tile
          GestureDetector(
            onTap: ()=> _confirmDeletion(context),
            child: Card(
              margin: EdgeInsets.all(22),
              color: Theme.of(context).colorScheme.secondary,
              elevation: 1,
              child: Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delete Account", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                    Icon(Icons.delete_outline_sharp, color: Theme.of(context).colorScheme.inversePrimary,)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


