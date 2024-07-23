import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:developer' as devtools;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? filepathText;
  File? filepathFace;
  String labelText = '';
  String labelFace = '';
  // double confidence = 0.0;
  double textConfidence = 0.0;
  double faceConfidence = 0.0;

  Future<void> _textModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
    print("text Model loaded; $res");
  }

  Future<void> _faceModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/cnn_emotion_detection.tflite",
        labels: "assets/labelsFace.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
    print("face Model loaded: $res");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textModel();
    _faceModel();
  }

  pickTextImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;
    await _textModel();
    var imageMap = File(image.path);

    setState(() {
      filepathText = imageMap;
    });

    var textRecognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );

    if (textRecognitions == null) {
      print("textRecognitions is null");
      devtools.log("textRecognitions is null");
      return;
    }
    print(textRecognitions);
    devtools.log(textRecognitions.toString());
    setState(() {
      textConfidence = (textRecognitions[0]['confidence'] * 100);
      labelText = textRecognitions[0]['label'].toString();
    });
  }

  pickFaceImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;
    await _faceModel();
    var imageMap = File(image.path);

    setState(() {
      filepathFace = imageMap;
    });

    var faceRecognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );

    if (faceRecognitions == null) {
      print("faceRecognitions is null");
      devtools.log("faceRecognitions is null");
      return;
    }
    print(faceRecognitions);
    devtools.log(faceRecognitions.toString());
    setState(() {
      faceConfidence = (faceRecognitions[0]['confidence'] * 100);
      labelFace = faceRecognitions[0]['label'].toString();
    });
  }

  pickTextImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;
    await _textModel();
    var imageMap = File(image.path);

    setState(() {
      filepathText = imageMap;
    });

    var textRecognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );

    if (textRecognitions == null) {
      print("textRecognitions is null");
      devtools.log("textRecognitions is null");
      return;
    }
    print(textRecognitions);
    devtools.log(textRecognitions.toString());
    setState(() {
      textConfidence = (textRecognitions[0]['confidence'] * 100);
      labelText = textRecognitions[0]['label'].toString();
    });
  }

  pickFaceImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;
    await _faceModel();
    var imageMap = File(image.path);

    setState(() {
      filepathFace = imageMap;
    });

    var faceRecognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );

    if (faceRecognitions == null) {
      print("faceRecognitions is null");
      devtools.log("faceRecognitions is null");
      return;
    }
    print(faceRecognitions);
    devtools.log(faceRecognitions.toString());
    setState(() {
      faceConfidence = (faceRecognitions[0]['confidence'] * 100);
      labelFace = faceRecognitions[0]['label'].toString();
    });
  }

  // pickTextImageCamera() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.camera);

  //   if (image == null) return;

  //   var imageMap = File(image.path);

  //   setState(() {
  //     filepath = imageMap;
  //   });

  //   var recognitions = await Tflite.runModelOnImage(
  //       path: image.path, // required
  //       imageMean: 0.0, // defaults to 117.0
  //       imageStd: 255.0, // defaults to 1.0
  //       numResults: 2, // defaults to 5
  //       threshold: 0.2, // defaults to 0.1
  //       asynch: true // defaults to true
  //       );

  //   if (recognitions == null) {
  //     print("recognitions is null");
  //     devtools.log("recognitions is null");
  //     return;
  //   }
  //   print(recognitions);
  //   devtools.log(recognitions.toString());
  //   setState(() {
  //     confidence = (recognitions[0]['confidence'] * 100);
  //     label = recognitions[0]['label'].toString();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("deteksi tulisan"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Card(
                elevation: 20,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                            height: 290,
                            width: 280,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: AssetImage('assets/foto.jpg'),
                              ),
                            ),
                            child: filepathText == null
                                ? const Text("")
                                : Image.file(filepathText!, fit: BoxFit.fill)),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                labelText,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                "The Accuracy is ${textConfidence.toStringAsFixed(0)}%",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: () {
                  pickTextImageCamera();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black),
                child: const Text("Take a Photo"),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  pickTextImageGallery();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black),
                child: const Text("Pick from Gallery"),
              ),
              const SizedBox(
                height: 12,
              ),
              Card(
                elevation: 20,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                            height: 290,
                            width: 280,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: AssetImage('assets/foto.jpg'),
                              ),
                            ),
                            child: filepathFace == null
                                ? const Text("")
                                : Image.file(filepathFace!, fit: BoxFit.fill)),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                labelFace,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                "The Accuracy is ${faceConfidence.toStringAsFixed(0)}%",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: () {
                  pickFaceImageCamera();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black),
                child: const Text("Take a Photo"),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  pickFaceImageGallery();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black),
                child: const Text("Pick from Gallery"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
