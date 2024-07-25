import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:developer' as devtools;
import 'package:hive/hive.dart';

void main() async {
  await Hive.initFlutter();

  var box = await Hive.openBox('mybox');

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
  double textConfidence = 0.0;
  double faceConfidence = 0.0;
  final _myBox = Hive.box('mybox');
  String resultText = '';
  String resultFace = '';

  hasil() {
    if (labelText == 'Steadiness') {
      resultText =
          'Steadiness merupakan tipe kepribadian yang merupakan pendengar yan baik, posesif, cenderung stabil, mau memahami dan juga bersahabat';
    }
    ;
    Text(resultText);
  }

  // void writeData() {
  //   _myBox.put(1, 'Mitch');
  //   print(_myBox.get(1));
  // }

  // void readData() {
  //   print(_myBox.get(1));
  // }

  // void deleteData() {
  //   _myBox.delete(1);
  // }

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

    hasil();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "moodScape",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2, // Optional: Add some letter spacing
            color: Colors.white, // Text color
          ),
        ),
        centerTitle: true, // Center the title
        backgroundColor: const Color(0xFFFFC0CB), // Soft pink color
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 24,
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
                        const Text(
                          "Deteksi Tulisan",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              image: AssetImage('assets/foto.jpg'),
                            ),
                          ),
                          child: filepathText == null
                              ? const Text("")
                              : Image.file(filepathText!, fit: BoxFit.fill),
                        ),
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
                                "${textConfidence.toStringAsFixed(0)}%",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 150, // Set a fixed width for the buttons
                      child: ElevatedButton(
                        onPressed: () {
                          pickTextImageCamera();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          backgroundColor:
                              Colors.grey[200], // Neutral background color
                          foregroundColor: Colors.black, // Neutral text color
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt,
                                size: 24,
                                color: Colors.black), // Neutral icon color
                            SizedBox(height: 5), // Space between icon and text
                            Text(
                              "Take a Photo",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 150, // Set a fixed width for the buttons
                      child: ElevatedButton(
                        onPressed: () {
                          pickTextImageGallery();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          backgroundColor:
                              Colors.grey[200], // Neutral background color
                          foregroundColor: Colors.black, // Neutral text color
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.photo_library,
                                size: 24,
                                color: Colors.black), // Neutral icon color
                            SizedBox(height: 5), // Space between icon and text
                            Text(
                              "Pick from Gallery",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              const SizedBox(
                height: 24,
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
                        const Text(
                          "Deteksi Emosi",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                            height: 200,
                            width: 200,
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
                                "${faceConfidence.toStringAsFixed(0)}%",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 150, // Set a fixed width for the buttons
                      child: ElevatedButton(
                        onPressed: () {
                          pickFaceImageCamera();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          backgroundColor:
                              Colors.grey[200], // Neutral background color
                          foregroundColor: Colors.black, // Neutral text color
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt,
                                size: 24,
                                color: Colors.black), // Neutral icon color
                            SizedBox(height: 5), // Space between icon and text
                            Text(
                              "Take a Photo",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 150, // Set a fixed width for the buttons
                      child: ElevatedButton(
                        onPressed: () {
                          pickFaceImageGallery();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          backgroundColor:
                              Colors.grey[200], // Neutral background color
                          foregroundColor: Colors.black, // Neutral text color
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.photo_library,
                                size: 24,
                                color: Colors.black), // Neutral icon color
                            SizedBox(height: 5), // Space between icon and text
                            Text(
                              "Pick from Gallery",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),

              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Result",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        resultText,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // MaterialButton(
              //   onPressed: writeData,
              //   child: Text('Write'),
              //   color: Colors.blue,
              // ),
              // MaterialButton(
              //   onPressed: readData,
              //   child: Text('Read'),
              //   color: Colors.blue,
              // ),
              // MaterialButton(
              //   onPressed: deleteData,
              //   child: Text('Delete'),
              //   color: Colors.blue,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
