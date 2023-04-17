import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthcare_assistant/features/authentification/controller/authentification_controller.dart';
import 'package:healthcare_assistant/features/home/home_controller.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.user});

  final User user;

  HomeController controller = Get.put(HomeController());
  AuthentificationController authentification =
      Get.put(AuthentificationController());

  @override
  Widget build(BuildContext context) {
    controller.initSpeechToText();
    controller.initTextToSpeech();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Healthcare Assistant",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        leading: IconButton(
          onPressed: () => authentification.logout(),
          icon: const Icon(
            HeroIcons.arrow_left_on_rectangle,
            size: 30.0,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String username = data['name'];
            return GetBuilder<HomeController>(
              builder: (controller) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Divider(color: Colors.transparent),
                          Lottie.network(
                              'https://assets2.lottiefiles.com/packages/lf20_bXsnEx.json',
                              width: 130.0),
                          const SizedBox(height: 16.0),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.2,
                                  color:
                                      const Color.fromARGB(141, 158, 158, 158)),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              controller.lastWords.isEmpty &&
                                      controller.speechToText.isNotListening
                                  ? "Hey $username👋, how i can assist you today"
                                  : controller.lastWords,
                              style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (controller.aiResponse != null)
                            const SizedBox(height: 16.0),
                          if (controller.aiResponse != null)
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.2,
                                    color: const Color.fromARGB(
                                        141, 158, 158, 158)),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                controller.aiResponse!,
                                style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          const SizedBox(height: 20.0),
                          const SizedBox(height: 20.0),
                          Visibility(
                            visible: controller.speechToText.isListening,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              child: Lottie.network(
                                  'https://assets5.lottiefiles.com/packages/lf20_MO5MPFgTv1.json'),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.doctorInfo.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(controller.doctorInfo[index].name),
                                subtitle:
                                    Text(controller.doctorInfo[index].location),
                                trailing: IconButton(
                                  onPressed: () async {
                                    final url =
                                        controller.doctorInfo[index].location;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  icon: const Icon(Icons.map),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.speechToText.isNotListening)
                IconButton(
                  onPressed: () async {
                    await controller.askAi(controller.lastWords);
                    String aiResponseNoLink = controller.aiResponse!
                        .replaceAll(RegExp(r'https?:\/\/(?:www\.)?\S+\b'), '');
                    print(aiResponseNoLink);
                    await controller.systemSpeak(aiResponseNoLink);
                  },
                  icon: const Icon(Icons.send),
                ),
              const SizedBox(width: 22.0),
              IconButton(
                onPressed: () async {
                  if (await controller.speechToText.hasPermission &&
                      controller.speechToText.isNotListening) {
                    await controller.startListening();
                  } else if (controller.speechToText.isListening) {
                    controller.stopListening();
                  } else {
                    controller.initSpeechToText();
                  }
                },
                icon: Icon(controller.speechToText.isListening
                    ? Icons.stop
                    : Icons.mic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
