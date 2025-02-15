import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/Theme/theme_provider.dart';
import 'package:flutter/material.dart%20';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HELP & SUPPORT"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30,),
              Image.asset("images/help_support.png", scale: 2,),
              const SizedBox(height: 12,),
               Text("How can we help you?", style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
              const SizedBox(height: 20,),

              // email support
              GestureDetector(
                onTap: (){
                  launch('mailto:paras.influxifotech@gmail.com?subject=This is mail');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.email_outlined, size: 30, color: Theme.of(context).colorScheme.inversePrimary,),

                          const SizedBox(width: 30,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Send Email",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.inversePrimary,
                                    fontSize: 18
                                  )
                              ),
                              Text("click here to send enquiry",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.inversePrimary,
                                      fontSize: 16, fontWeight: FontWeight.w300
                                  )
                              )
                            ],
                          ),
                          // const SizedBox(width: 20,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              // call support
              GestureDetector(
                onTap: (){
                  launch('tel:+91-8923888640');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.call, size: 30, color: Theme.of(context).colorScheme.inversePrimary,),
                
                          const SizedBox(width: 30,),
                
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Call Support",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.inversePrimary,
                                      fontSize: 18
                                  )
                              ),
                              Text("Reach as At +91-8923888640",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.inversePrimary,
                                      fontSize: 16, fontWeight: FontWeight.w300
                                  )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              // whatsapp support
              GestureDetector(
                onTap: (){
                  launchUrl(Uri.parse("https://wa.me/+91-8923888640/?text=hello}"),
                      mode: LaunchMode.externalApplication);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    color: Theme.of(context).colorScheme.secondary
                    ,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.phone, size: 30,
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                          ),
                
                          const SizedBox(width: 30,),
                
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Get Support on WhatsApp",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 18
                                )
                              ),
                              Text("click here to send enquiry",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.inversePrimary,
                                      fontSize: 16, fontWeight: FontWeight.w300
                                  )
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
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
