import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String subtitle;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Card(
          elevation: 2,
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('images/user.png'),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.pending,
                            size: 12,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              subtitle,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
