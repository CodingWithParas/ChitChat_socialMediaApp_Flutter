import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatLoading extends StatelessWidget {
  const ChatLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            height: 90,
            child: Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Icons
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.primary,
                      highlightColor: Theme.of(context).colorScheme.inversePrimary,
                      child: CircleAvatar(
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(width: 50,),

                    // user name
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.primary,
                      highlightColor: Theme.of(context).colorScheme.inversePrimary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 180,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(05),
                              color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: 140,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(05),
                              color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                        ],
                      ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 15,),

          Container(
            height: 90,
            child: Card(
              elevation: 2,

              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Icons
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.primary,
                      highlightColor: Theme.of(context).colorScheme.inversePrimary,
                      child: CircleAvatar(
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(width: 50,),

                    // user name
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.primary,
                      highlightColor: Theme.of(context).colorScheme.inversePrimary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 180,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: 140,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 15,),

          Container(
            height: 90,
            child: Card(
              elevation: 2,

              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Icons
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.primary,
                      highlightColor: Theme.of(context).colorScheme.inversePrimary,
                      child: CircleAvatar(
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(width: 50,),

                    // user name
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.primary,
                      highlightColor: Theme.of(context).colorScheme.inversePrimary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 180,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: 140,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 15,),

          Container(
            height: 90,
            child: Card(
              elevation: 2,

              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Icons
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.primary,
                      highlightColor: Theme.of(context).colorScheme.inversePrimary,
                      child: CircleAvatar(
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(width: 50,),

                    // user name
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.primary,
                      highlightColor: Theme.of(context).colorScheme.inversePrimary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 180,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: 140,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 15,),

          Container(
            height: 90,
            child: Card(
              elevation: 2,

              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Icons
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.primary,
                      highlightColor: Theme.of(context).colorScheme.inversePrimary,
                      child: CircleAvatar(
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(width: 50,),

                    // user name
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.primary,
                      highlightColor: Theme.of(context).colorScheme.inversePrimary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 180,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: 140,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 15,),

          Container(
            height: 90,
            child: Card(
              elevation: 2,

              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Icons
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.primary,
                      highlightColor: Theme.of(context).colorScheme.inversePrimary,
                      child: CircleAvatar(
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(width: 50,),

                    // user name
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.primary,
                      highlightColor: Theme.of(context).colorScheme.inversePrimary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 180,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: 140,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
