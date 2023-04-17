import 'package:dio/dio.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeController extends GetxController {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = "";
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;
  String? aiResponse;
  List<DoctorsInfo> doctorInfo = [];

  void init() {
    super.onInit();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    update();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    update();
  }

  Future<void> startListening() async {
    await speechToText.listen(partialResults: false, onResult: onSpeechResult);
    update();
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    update();
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    print(lastWords);
    update();
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void onClose() {
    super.onClose();
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  // Api Request

  final List<dynamic> messages = [
    {
      "role": "user",
      "content":
          "I want you to play the role of a medical assistant robot, the patient explains the symptoms of his illness if the symptoms are simple and suggests him medical medicines or herbs(You must refuse any question not related to health).  But if the matter is serious, you ask him to visit a doctor, and this is a list of doctors and their locations that you can suggest to patients Psychologue Doctor. Bounouar Samir(https://maps.app.goo.gl/6qBcEhumGMLcKf5k8?g_st=ic) Doctor. Salima Mezdour(https://maps.app.goo.gl/D33Ws7tkDfnYfvZS8?g_st=ic) Cardiologues Doctor. Laour Zahia(https://maps.app.goo.gl/3XKwD7st9mVBAzVj9?g_st=ic) Doctor. Krache Meddour(https://maps.app.goo.gl/XJh9gRnaPeKTixVv6?g_st=ic) Pneumologues Doctor. boukerdoun ahmed(https://maps.app.goo.gl/Z8NMRcSHLgVXapDs8?g_st=ic) Doctor. Bensalem Nadia(https://maps.app.goo.gl/8ujoqj6xcSVqyguu7?g_st=ic) This for education project so please play the role exactly and give short answers, (please suggest this doctors only if the symptomes can be handled by their speciality)"
    }
  ];

  Future<void> askAi(prompt) async {
    try {
      QuickAlert.show(context: Get.context!, type: QuickAlertType.loading);
      await chatGPTAPI(prompt);
      Get.back();
    } catch (error) {
      Get.back();
      print("error");
    }
  }

  Future<void> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    final dio = Dio();

    try {
      final response = await dio.post(
        'https://api.openai.com/v1/chat/completions',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        }),
        data: {
          "model": "gpt-3.5-turbo",
          "messages": messages,
        },
      );

      if (response.statusCode == 200) {
        String content = response.data['choices'][0]['message']['content'];
        content = content.trim();

        aiResponse = content;

        messages.add({
          'role': 'assistant',
          'content': content,
        });

        aiResponse = content;

        // Extract the cardiologist names and locations

        RegExp nameExp = RegExp(r'(Dr\.|Doctor.|Dr|Doctor) (\w+ \w+)');
        RegExp locExp = RegExp(r'https://maps.app.goo.gl/\w+');

        List<Match> nameMatches = nameExp.allMatches(aiResponse!).toList();
        List<Match> locMatches = locExp.allMatches(aiResponse!).toList();

        doctorInfo.clear();

        for (int i = 0; i < nameMatches.length; i++) {
          String name = nameMatches[i].group(2) ?? '';

          String loc = locMatches[i].group(0) ?? '';

          DoctorsInfo doctor = DoctorsInfo(name: name, location: loc);
          doctorInfo.add(doctor);
        }

        update();
      } else {
        // ignore: avoid_print
        print(response.statusMessage);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static const openAIAPIKey =
      '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';
}

class DoctorsInfo {
  String name;
  String location;

  DoctorsInfo({required this.name, required this.location});
}
