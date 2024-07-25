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
  // final _myBox = Hive.box('mybox');
  String resultText = 'result akan muncul setelah Anda memasukan foto';
  // String resultFace = 'rekomendasi akan muncul setelah Anda memasukan foto';
  String recomendation = 'rekomendasi akan muncul setelah Anda memasukan foto';

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
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          'update Result!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Color(0xFFFFC0CB),
        onPressed: () {
          setState(() {
            if (labelText == null || labelText == '') {
              resultText = 'Anda belum memasukan foto';
              recomendation = 'Anda belum memasukan foto';
            }
            if (labelText == 'Steadiness' && textConfidence >= 0.5) {
              resultText =
                  'Orang dengan skor stabilitas tinggi biasanya dapat diandalkan, sabar, dan tenang. Mereka suka mendukung dan membantu orang lain, dan sering kali menjadi teman yang setia. Mereka cenderung menghindari perubahan dan lebih suka rutinitas yang teratur, serta bekerja dengan baik dalam lingkungan yang harmonis';
            } else if (labelText == 'Steadiness' && textConfidence < 0.5) {
              resultText =
                  'Cobalah Hal Baru: Tantang diri Anda untuk mencoba kegiatan atau hobi baru. Perubahan kecil bisa memberikan perspektif baru dan menyegarkan pikiran.\nTemukan Dukungan Emosional: Bicarakan perasaan Anda dengan teman atau profesional yang bisa memberikan dukungan emosional dan saran yang bijak.';
            }
            if (labelText == 'Dominance' && textConfidence >= 0.5) {
              resultText =
                  'Orang dengan skor dominan tinggi cenderung menunjukkan sifat-sifat seperti percaya diri, tegas, dan berorientasi pada hasil. Mereka adalah pemimpin alami yang mengambil inisiatif dan tidak takut menghadapi tantangan. Mereka cenderung mengambil keputusan cepat dan kadang-kadang bisa terlihat agresif atau kompetitif.';
            } else if (labelText == 'Dominance' && textConfidence < 0.5) {
              resultText =
                  'Mereka dengan skor dominan rendah biasanya lebih tenang dan mudah menerima pendapat orang lain. Mereka cenderung menghindari konflik dan lebih suka bekerja dalam tim daripada memimpin. Keputusan mereka cenderung lebih hati-hati dan dipikirkan matang-matang, dengan mempertimbangkan berbagai sudut pandang.';
            }
            if (labelText == 'Influence' && textConfidence >= 0.5) {
              resultText =
                  'Individu dengan tingkat pengaruh tinggi adalah komunikator yang baik dan sangat sosial. Mereka menikmati berinteraksi dengan orang lain, mudah bergaul, dan sering kali menjadi pusat perhatian. Mereka cenderung optimis dan energik, serta mampu menginspirasi dan memotivasi orang lain dengan mudah.';
            } else if (labelText == 'Influence' && textConfidence < 0.5) {
              resultText =
                  'Mereka yang memiliki skor pengaruh rendah lebih introspektif dan cenderung lebih sedikit berbicara. Mereka sering kali lebih serius dan tidak terlalu suka menjadi pusat perhatian. Dalam komunikasi, mereka lebih suka mendengarkan daripada berbicara, dan cenderung lebih fokus pada fakta dan data daripada perasaan.';
            }
            if (labelText == 'Conscientiousness' && textConfidence >= 0.5) {
              resultText =
                  'Individu dengan tingkat ketelitian tinggi cenderung sangat detail-oriented, analitis, dan teliti. Mereka menghargai ketepatan dan akurasi dalam pekerjaan mereka dan sering kali sangat perfeksionis. Mereka cenderung membuat keputusan berdasarkan data dan bukti yang solid.';
            } else if (labelText == 'Conscientiousness' &&
                textConfidence < 0.5) {
              resultText =
                  'Mereka dengan skor ketelitian rendah biasanya lebih fleksibel dan tidak terlalu terikat pada detail. Mereka lebih suka melihat gambaran besar dan lebih nyaman dengan ambiguitas. Mereka cenderung membuat keputusan lebih cepat dan tidak terlalu khawatir tentang kesempurnaan.';
            }

            // HAPPYYYYYYYYYYYYY

            if (labelText == 'Steadiness' &&
                labelFace == 'Happy' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Rayakan dengan Cara yang Tenang: Lakukan aktivitas yang menenangkan seperti berjalan di taman atau mendengarkan musik favorit. \n\nBerbagi dengan Orang Lain: Bantu orang lain atau lakukan tindakan kebaikan yang dapat menyebarkan kebahagiaan Anda.\n\nTrivia: "Kebahagiaan dapat ditemukan dalam stabilitas dan ketenangan hati."\n\n"Happiness is not something ready-made. It comes from your own actions." – Dalai Lama';
            } else if (labelText == 'Steadiness' &&
                labelFace == 'Happy' &&
                textConfidence < 0.5) {
              recomendation =
                  'Coba Hal Baru: Gunakan kebahagiaan Anda sebagai motivasi untuk mencoba aktivitas atau hobi baru.\nBagikan Pengalaman Anda: Ceritakan kepada teman-teman tentang hal-hal baru yang Anda coba dan nikmati. \n Trivia: "Mencoba hal baru bisa memperkaya kebahagiaan dan membawa perspektif baru." \n"Happiness is the consequence of personal effort." – Elizabeth Gilbert';
            }

            if (labelText == 'Dominance' &&
                labelFace == 'Happy' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Ambil Proyek Baru: Gunakan energi positif Anda untuk memulai proyek atau tantangan baru yang dapat memberi Anda rasa pencapaian.\n\nBerbagi Inspirasi: Bagikan kesuksesan Anda dengan orang lain dan dorong mereka untuk mencapai tujuan mereka.\n\nTrivia: "Orang yang berorientasi pada hasil sering kali menemukan kebahagiaan dalam pencapaian dan inovasi."\n\n"Success is not the key to happiness. Happiness is the key to success." – Albert Schweitzer';
            } else if (labelText == 'Dominance' &&
                labelFace == 'Happy' &&
                textConfidence < 0.5) {
              recomendation =
                  'Nikmati Kebahagiaan dengan Orang Terdekat: Luangkan waktu bersama teman dan keluarga untuk merayakan kebahagiaan bersama.\n\nRefleksi Pribadi: Gunakan momen ini untuk merenungkan apa yang membuat Anda bahagia dan bagaimana Anda bisa mempertahankannya.\n\nTrivia: "Kebahagiaan dapat ditemukan dalam momen-momen kecil dan hubungan yang kuat."\n\n"The most important thing is to enjoy your life—to be happy—its all that matters." – Audrey Hepburn';
            }

            if (labelText == 'Influence' &&
                labelFace == 'Happy' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Bagikan Kegembiraan Anda: Gunakan media sosial atau acara sosial untuk berbagi kebahagiaan Anda dan menginspirasi orang lain.\n\nLibatkan Diri dalam Aktivitas Sosial: Ikuti kegiatan komunitas atau acara sosial untuk menambah kesenangan.\n\nTrivia: "Kebahagiaan sering kali menjadi lebih bermakna saat dibagikan dengan orang lain."\n\n"Happiness is only real when shared." – Christopher McCandless';
            } else if (labelText == 'Influence' &&
                labelFace == 'Happy' &&
                textConfidence < 0.5) {
              recomendation =
                  'Ekspresikan Rasa Syukur: Tuliskan di jurnal atau luangkan waktu untuk merenungkan hal-hal yang membuat Anda bahagia.\n\nTemukan Ketenangan: Nikmati kebahagiaan dalam momen-momen tenang dan reflektif.\n\nTrivia: "Ketenangan dan kesederhanaan dapat menjadi sumber kebahagiaan yang dalam."\n\n"The greatest wealth is to live content with little." – Plato';
            }

            if (labelText == 'Conscientiousness' &&
                labelFace == 'Happy' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Nikmati Kesuksesan: Akui dan rayakan pencapaian Anda dengan cara yang sesuai dengan nilai-nilai dan standar Anda.\n\nRefleksi dan Perencanaan: Gunakan momen ini untuk merencanakan langkah-langkah berikutnya dalam hidup atau karier Anda.\n\nTrivia: "Kebahagiaan dapat ditemukan dalam pencapaian yang terencana dan berarti."\n\n"Happiness lies in the joy of achievement and the thrill of creative effort." – Franklin D. Roosevelt';
            } else if (labelText == 'Conscientiousness' &&
                labelFace == 'Happy' &&
                textConfidence < 0.5) {
              recomendation =
                  'Terima Kebahagiaan dengan Fleksibilitas: Izinkan diri Anda untuk menikmati momen kebahagiaan tanpa terlalu banyak perencanaan atau analisis.\n\nRayakan dengan Sederhana: Lakukan sesuatu yang sederhana namun bermakna untuk merayakan kebahagiaan Anda.\n\nTrivia: "Kebahagiaan tidak harus sempurna; itu bisa ditemukan dalam momen-momen spontan."\n\n"The art of being happy lies in the power of extracting happiness from common things." – Henry Ward Beecher';
            }

            // SADDDDDDDDDDDD

            if (labelText == 'Dominance' &&
                labelFace == 'Sad' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Aktif Melakukan Kegiatan: Fokus pada kegiatan yang menantang dan memungkinkan Anda untuk merasa berprestasi. Misalnya, mulai proyek baru atau olahraga.\n\nCari Dukungan dari Mentor: Temui seseorang yang Anda hormati dan diskusikan perasaan Anda. Mentor dapat memberikan perspektif yang kuat dan motivasi.';
            } else if (labelText == 'Dominance' &&
                labelFace == 'Sad' &&
                textConfidence < 0.5) {
              recomendation =
                  'Terima Perasaan Anda: Jangan terlalu keras pada diri sendiri. Izinkan diri Anda merasakan dan memahami kesedihan.\n\nBerkomunikasi dengan Orang Terdekat: Luangkan waktu untuk berbicara dengan teman atau keluarga yang dapat mendengarkan dengan empati dan tanpa menghakimi.';
            }

            if (labelText == 'Influence' &&
                labelFace == 'Sad' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Bersosialisasi dengan Teman-teman: Luangkan waktu dengan orang-orang yang bisa membuat Anda tertawa dan merasa baik. Acara sosial dapat membantu mengalihkan perhatian dari kesedihan.\n\nEkspresikan Diri: Gunakan seni, musik, atau tulisan sebagai cara untuk mengekspresikan perasaan Anda dan memproses emosi.';
            } else if (labelText == 'Influence' &&
                labelFace == 'Sad' &&
                textConfidence < 0.5) {
              recomendation =
                  'Mencari Waktu untuk Diri Sendiri: Luangkan waktu sendirian untuk refleksi diri dan pemahaman lebih dalam terhadap perasaan Anda.\n\nBaca atau Menulis Jurnal: Membaca buku atau menulis jurnal bisa membantu Anda mengeksplorasi dan memahami perasaan Anda lebih dalam.';
            }

            if (labelText == 'Steadiness' &&
                labelFace == 'Sad' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Pertahankan Rutinitas: Jaga rutinitas harian Anda. Stabilitas dalam aktivitas sehari-hari dapat memberikan rasa aman dan kenyamanan.\n\nBerpartisipasi dalam Kegiatan Relaksasi: Cobalah kegiatan yang menenangkan seperti meditasi, yoga, atau berjalan-jalan di alam.';
            } else if (labelText == 'Steadiness' &&
                labelFace == 'Sad' &&
                textConfidence < 0.5) {
              recomendation =
                  'Cobalah Hal Baru: Tantang diri Anda untuk mencoba kegiatan atau hobi baru. Perubahan kecil bisa memberikan perspektif baru dan menyegarkan pikiran.\n\nTemukan Dukungan Emosional: Bicarakan perasaan Anda dengan teman atau profesional yang bisa memberikan dukungan emosional dan saran yang bijak.';
            }

            if (labelText == 'Conscientiousness' &&
                labelFace == 'Sad' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Analisis Penyebab Kesedihan: Cobalah untuk memahami secara logis apa yang menyebabkan kesedihan Anda. Menulis daftar faktor penyebab dan solusi yang mungkin bisa membantu.\n\nTetapkan Tujuan Kecil: Fokus pada pencapaian tujuan kecil yang dapat memberikan rasa kemajuan dan pengendalian diri.';
            } else if (labelText == 'Conscientiousness' &&
                labelFace == 'Sad' &&
                textConfidence < 0.5) {
              recomendation =
                  'Jangan Terlalu Keras pada Diri Sendiri: Izinkan diri Anda untuk tidak selalu perfeksionis. Terima bahwa kesedihan adalah bagian alami dari kehidupan.\n\nCari Dukungan dari Orang Lain: Bicarakan perasaan Anda dengan seseorang yang bisa memberikan perspektif berbeda dan dukungan emosional.';
            }

            // ANGRYYYYYYYYYYYYY

            if (labelText == 'Dominance' &&
                labelFace == 'Angry' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Aktivitas Fisik Intensif: Salurkan kemarahan melalui aktivitas fisik yang intens seperti berolahraga, berlari, atau kickboxing untuk melepaskan energi berlebih.\n\nCari Solusi Proaktif: Fokus pada mencari solusi untuk masalah yang memicu kemarahan. Ambil tindakan yang konstruktif untuk menyelesaikan konflik atau situasi.';
            } else if (labelText == 'Dominance' &&
                labelFace == 'Angry' &&
                textConfidence < 0.5) {
              recomendation =
                  'Tenangkan Diri dengan Refleksi: Luangkan waktu untuk menenangkan diri melalui meditasi atau pernapasan dalam sebelum merespons situasi yang memicu kemarahan.\n\nKomunikasi Terbuka: Bicarakan perasaan Anda dengan tenang kepada orang yang terlibat. Gunakan "I statements" untuk menyampaikan perasaan tanpa menyalahkan.';
            }

            if (labelText == 'Influence' &&
                labelFace == 'Angry' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Ekspresikan Emosi secara Kreatif: Gunakan seni, musik, atau tulisan sebagai cara untuk mengekspresikan kemarahan dan meredakannya.\n\nBerbicaralah dengan Teman: Luangkan waktu dengan teman-teman yang bisa mendengarkan Anda dan memberikan perspektif yang menenangkan.';
            } else if (labelText == 'Influence' &&
                labelFace == 'Angry' &&
                textConfidence < 0.5) {
              recomendation =
                  'Refleksi Pribadi: Luangkan waktu sendirian untuk merenungkan penyebab kemarahan Anda dan cari cara untuk mengelolanya secara lebih tenang.\n\nJurnal Emosi: Tulis perasaan Anda di jurnal untuk memahami sumber kemarahan dan menemukan cara untuk meredakannya.';
            }

            if (labelText == 'Steadiness' &&
                labelFace == 'Angry' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Aktivitas Relaksasi: Cobalah aktivitas yang menenangkan seperti meditasi, yoga, atau berjalan-jalan di alam untuk meredakan ketegangan.\n\nJaga Rutinitas: Pertahankan rutinitas harian Anda untuk menjaga stabilitas emosional dan memberikan rasa aman.';
            } else if (labelText == 'Steadiness' &&
                labelFace == 'Angry' &&
                textConfidence < 0.5) {
              recomendation =
                  'Cobalah Aktivitas Baru: Alihkan perhatian dengan mencoba aktivitas baru atau hobi yang bisa memberikan perspektif segar dan mengurangi kemarahan.\n\nDukungan Emosional: Cari dukungan dari teman atau profesional yang bisa membantu Anda mengelola emosi dengan lebih baik.';
            }

            if (labelText == 'Conscientiousness' &&
                labelFace == 'Angry' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Analisis Situasi: Gunakan pendekatan analitis untuk memahami penyebab kemarahan dan mencari solusi yang logis dan konstruktif.\n\nTetapkan Batas Waktu: Tetapkan batas waktu untuk merenungkan masalah sebelum mengambil tindakan atau berbicara dengan orang lain.';
            } else if (labelText == 'Conscientiousness' &&
                labelFace == 'Angry' &&
                textConfidence < 0.5) {
              recomendation =
                  'Fleksibilitas dan Penerimaan: Cobalah untuk lebih fleksibel dan menerima bahwa tidak semua hal bisa sempurna. Terima kekurangan dan fokus pada hal-hal yang dapat Anda kendalikan.\n\nBerbicaralah dengan Orang Lain: Bicarakan perasaan Anda dengan seseorang yang dapat memberikan perspektif berbeda dan membantu Anda melihat situasi dari sudut pandang yang lebih tenang.';
            }

            // SUPRIIIIIIIIIIIISEEEEEEE

            if (labelText == 'Dominance' &&
                labelFace == 'Surprise' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Evaluasi Situasi Secara Objektif: Saat terkejut, cobalah untuk segera menilai situasi dengan kepala dingin dan fokus pada solusi yang mungkin.\n\nGunakan Energi Kejutan untuk Bertindak: Salurkan energi kejutan ke dalam tindakan positif atau keputusan yang cepat dan strategis.\n\nTrivia: "Individu dominan sering menggunakan kejutan sebagai katalis untuk perubahan dan inovasi."\n\n"Surprise is the greatest gift which life can grant us." – Boris Pasternak';
            } else if (labelText == 'Dominance' &&
                labelFace == 'Surprise' &&
                textConfidence < 0.5) {
              recomendation =
                  'Luangkan Waktu untuk Memproses: Beri diri Anda waktu untuk merenung dan memahami apa yang terjadi sebelum merespons.\n\nCari Dukungan dan Perspektif Lain: Diskusikan situasi dengan seseorang yang Anda percayai untuk mendapatkan pandangan yang lebih luas.\n\nTrivia: "Ketenangan dalam menghadapi kejutan membantu menemukan solusi yang lebih bijak."\n\n"The unexpected moment is always sweeter." – Julia Quinn';
            }

            if (labelText == 'Influence' &&
                labelFace == 'Surprise' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Bagikan Kejutan dengan Orang Lain: Gunakan kejutan sebagai cerita menarik untuk dibagikan dengan teman atau di media sosial.\n\nLihat Sisi Positif: Fokus pada potensi positif dari kejutan dan gunakan kreativitas Anda untuk menghadapinya.\n\nTrivia: "Kejutan seringkali menjadi kesempatan untuk menginspirasi dan menghibur orang lain."\n\n"Sometimes, the best discoveries come from unexpected moments." – Unknown';
            } else if (labelText == 'Influence' &&
                labelFace == 'Surprise' &&
                textConfidence < 0.5) {
              recomendation =
                  'Renungkan dengan Tenang: Alih-alih bereaksi berlebihan, renungkan situasinya dan catat apa yang Anda pelajari dari kejutan tersebut.\n\nCari Pemahaman Mendalam: Gunakan kejutan sebagai kesempatan untuk memahami diri Anda sendiri dengan lebih baik.\n\nTrivia: "Mengambil waktu untuk refleksi setelah kejutan dapat memperkuat pemahaman pribadi."\n\n"In the middle of difficulty lies opportunity." – Albert Einstein';
            }

            if (labelText == 'Steadiness' &&
                labelFace == 'Surprise' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Cari Stabilitas: Kembali ke rutinitas harian untuk memulihkan perasaan tenang setelah terkejut.\n\nBerbagi Pengalaman dengan Orang Terdekat: Diskusikan kejutan dengan orang-orang terdekat untuk mendapatkan dukungan emosional.\n\nTrivia: "Rutinitas dan stabilitas dapat membantu mengelola perasaan terkejut dengan lebih baik."\n\n"Life is full of surprises, but the biggest surprise of all is learning what it takes to handle them." – Unknown';
            } else if (labelText == 'Steadiness' &&
                labelFace == 'Surprise' &&
                textConfidence < 0.5) {
              recomendation =
                  'Terima Perubahan dengan Fleksibilitas: Lihat kejutan sebagai peluang untuk beradaptasi dan tumbuh dalam situasi baru.\n\nCoba Hal Baru: Gunakan momen kejutan untuk mendorong diri mencoba sesuatu yang berbeda dan mengasyikkan.\n\nTrivia: "Kejutan bisa menjadi motivasi untuk memperluas batasan dan mencoba hal baru."\n\n"Surprises are the joy of living; they make life worth waiting." – Oscar Wilde';
            }

            if (labelText == 'Conscientiousness' &&
                labelFace == 'Surprise' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Analisis Kejutan secara Mendalam: Lakukan analisis mendalam tentang apa yang menyebabkan kejutan dan bagaimana hal itu memengaruhi rencana Anda.\n\nRencanakan Langkah Selanjutnya: Buat rencana untuk menyesuaikan dengan situasi baru setelah kejutan tersebut.\n\nTrivia: "Pendekatan analitis terhadap kejutan dapat mengubah ketidakpastian menjadi peluang."\n\n"Expect the unexpected, and whenever possible, be the unexpected." – Lynda Barry';
            } else if (labelText == 'Conscientiousness' &&
                labelFace == 'Surprise' &&
                textConfidence < 0.5) {
              recomendation =
                  'Nikmati Momen Tak Terduga: Terimalah kejutan dengan rasa ingin tahu dan terbuka terhadap kemungkinan baru.\n\nKurangi Ketegangan dengan Fleksibilitas: Izinkan diri Anda untuk menikmati spontanitas dari kejutan tanpa terlalu khawatir tentang rencana yang terpengaruh.\n\nTrivia: "Kebahagiaan dari kejutan sering ditemukan dalam spontanitas dan keterbukaan terhadap pengalaman baru."\n\n"Let us live for the beauty of our own reality." – Charles Lamb';
            }

            // NEUTRALLLLLLLLLLLLLL

            if (labelText == 'Dominance' &&
                labelFace == 'Neutral' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Tetapkan Tujuan Baru: Gunakan periode netral ini untuk menetapkan tujuan baru yang dapat memberikan motivasi dan arah yang jelas.\n\nEvaluasi Proyek yang Sedang Berjalan: Luangkan waktu untuk menilai kemajuan proyek dan membuat penyesuaian yang diperlukan untuk mencapai hasil yang lebih baik.\n\nTrivia: "Momen netral sering kali merupakan waktu terbaik untuk mengevaluasi dan merencanakan langkah berikutnya."\n\n"Setting goals is the first step in turning the invisible into the visible." – Tony Robbins';
            } else if (labelText == 'Dominance' &&
                labelFace == 'Neutral' &&
                textConfidence < 0.5) {
              recomendation =
                  'Jaga Keseimbangan: Gunakan waktu ini untuk menjaga keseimbangan antara pekerjaan dan kehidupan pribadi. Pastikan Anda tidak terlalu memaksakan diri.\n\nBerkomunikasi dengan Tim: Libatkan diri Anda dalam diskusi tim untuk memahami kebutuhan dan kekhawatiran mereka, serta membangun hubungan yang lebih kuat.\n\nTrivia: "Keadaan netral bisa menjadi kesempatan untuk memperkuat hubungan dan meningkatkan kolaborasi."\n\n"Balance is not something you find, it\'s something you create." – Jana Kingsford';
            }

            if (labelText == 'Influence' &&
                labelFace == 'Neutral' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Jelajahi Koneksi Sosial: Manfaatkan momen netral untuk menjalin hubungan baru atau memperkuat yang sudah ada.\n\nKembangkan Kreativitas: Ikuti kegiatan yang dapat merangsang kreativitas Anda, seperti menghadiri acara seni atau workshop.\n\nTrivia: "Keadaan netral memungkinkan eksplorasi sosial dan kreativitas yang lebih besar."\n\n"Creativity is intelligence having fun." – Albert Einstein';
            } else if (labelText == 'Influence' &&
                labelFace == 'Neutral' &&
                textConfidence < 0.5) {
              recomendation =
                  'Nikmati Waktu Sendiri: Gunakan waktu ini untuk refleksi dan menikmati momen ketenangan yang bisa membawa kedamaian batin.\n\nPerkuat Hubungan Dekat: Fokus pada hubungan yang sudah ada dengan lebih mendalam, seperti keluarga dan teman dekat.\n\nTrivia: "Waktu netral bisa menjadi peluang untuk introspeksi dan memperdalam hubungan yang berarti."\n\n"The quieter you become, the more you can hear." – Ram Dass';
            }

            if (labelText == 'Steadiness' &&
                labelFace == 'Neutral' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Pertahankan Rutinitas yang Menenangkan: Lanjutkan rutinitas harian yang memberi rasa aman dan stabilitas.\n\nBerpartisipasi dalam Aktivitas Relaksasi: Ikuti aktivitas yang menenangkan seperti meditasi, yoga, atau berjalan-jalan untuk menjaga ketenangan.\n\nTrivia: "Ketenangan dalam momen netral membantu menjaga keseimbangan emosional dan mental."\n\n"In the midst of movement and chaos, keep stillness inside of you." – Deepak Chopra';
            } else if (labelText == 'Steadiness' &&
                labelFace == 'Neutral' &&
                textConfidence < 0.5) {
              recomendation =
                  'Cobalah Sesuatu yang Baru: Gunakan momen netral untuk menjelajahi hobi atau aktivitas baru yang dapat memperkaya hidup Anda.\n\nAdaptasi dengan Fleksibilitas: Tetap terbuka terhadap perubahan dan kesempatan baru yang mungkin muncul.\n\nTrivia: "Momen netral adalah peluang sempurna untuk beradaptasi dan menemukan minat baru."\n\n"The only way to make sense out of change is to plunge into it, move with it, and join the dance." – Alan Watts';
            }

            if (labelText == 'Conscientiousness' &&
                labelFace == 'Neutral' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Refleksi dan Perencanaan: Gunakan waktu netral untuk mengevaluasi pencapaian masa lalu dan merencanakan langkah selanjutnya dengan lebih terstruktur.\n\nTingkatkan Pengetahuan: Manfaatkan waktu ini untuk memperdalam pengetahuan atau keterampilan dalam bidang yang Anda minati.\n\nTrivia: "Kondisi netral menawarkan kesempatan untuk perencanaan yang lebih bijak dan pengembangan diri."\n\n"By failing to prepare, you are preparing to fail." – Benjamin Franklin';
            } else if (labelText == 'Conscientiousness' &&
                labelFace == 'Neutral' &&
                textConfidence < 0.5) {
              recomendation =
                  'Nikmati Momen Spontan: Gunakan kesempatan ini untuk menikmati momen spontan tanpa terlalu banyak perencanaan atau analisis.\n\nEksplorasi Kreatif: Izinkan diri Anda bereksperimen dengan ide-ide baru yang mungkin belum pernah dicoba sebelumnya.\n\nTrivia: "Waktu netral memungkinkan eksplorasi spontan dan kreatif yang menyenangkan."\n\n"The art of life lies in a constant readjustment to our surroundings." – Kakuzo Okakura';
            }

            // FEARRRRRRRRRR

            if (labelText == 'Dominance' &&
                labelFace == 'Fear' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Hadapi Ketakutan dengan Tindakan: Cobalah untuk mengambil langkah konkret dalam menghadapi apa yang membuat Anda takut. Buat rencana dan lakukan tindakan kecil yang dapat mengurangi ketakutan Anda.\n\nGunakan Ketakutan sebagai Motivasi: Alihkan rasa takut menjadi motivasi untuk bertindak dan mencapai tujuan. Jadikan ketakutan sebagai katalisator untuk mengubah situasi menjadi lebih baik.\n\nTrivia: "Bagi mereka yang dominan, rasa takut bisa menjadi pendorong untuk mencapai hal-hal besar."\n\n"Do one thing every day that scares you." – Eleanor Roosevelt';
            } else if (labelText == 'Dominance' &&
                labelFace == 'Fear' &&
                textConfidence < 0.5) {
              recomendation =
                  'Analisis Penyebab Ketakutan: Luangkan waktu untuk memahami akar dari ketakutan Anda dan cari solusi yang tepat untuk mengatasinya.\n\nBerbicaralah dengan Mentor atau Kolega: Diskusikan ketakutan Anda dengan seseorang yang Anda hormati untuk mendapatkan perspektif dan dukungan.\n\nTrivia: "Mengidentifikasi dan menganalisis ketakutan dapat memberikan kekuatan untuk menghadapinya dengan lebih baik."\n\n"You gain strength, courage, and confidence by every experience in which you really stop to look fear in the face." – Eleanor Roosevelt';
            }

            if (labelText == 'Influence' &&
                labelFace == 'Fear' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Berbagi Ketakutan dengan Orang Lain: Bicarakan perasaan Anda dengan teman atau keluarga yang bisa mendukung dan memberi Anda perspektif positif.\n\nGunakan Kreativitas untuk Menghadapi Ketakutan: Ekspresikan ketakutan Anda melalui seni, musik, atau tulisan, dan gunakan kreativitas Anda untuk menghadapinya.\n\nTrivia: "Ekspresi diri dan dukungan sosial dapat membantu meredakan ketakutan dan memberikan kepercayaan diri."\n\n"The greatest mistake we make is living in constant fear that we will make one." – John C. Maxwell';
            } else if (labelText == 'Influence' &&
                labelFace == 'Fear' &&
                textConfidence < 0.5) {
              recomendation =
                  'Temukan Ketenangan dalam Refleksi: Luangkan waktu untuk introspeksi dan temukan cara untuk menenangkan diri melalui meditasi atau teknik relaksasi lainnya.\n\nCari Pemahaman dari Dalam: Gunakan momen ini untuk mengeksplorasi diri Anda lebih dalam dan memahami bagaimana Anda dapat mengatasi ketakutan secara mandiri.\n\nTrivia: "Refleksi diri dapat menjadi alat yang kuat untuk menghadapi dan memahami ketakutan."\n\n"Everything you want is on the other side of fear." – Jack Canfield';
            }

            if (labelText == 'Steadiness' &&
                labelFace == 'Fear' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Pertahankan Rutinitas yang Menenangkan: Gunakan rutinitas harian untuk memberikan rasa stabilitas dan keamanan saat menghadapi ketakutan.\n\nCari Dukungan dari Lingkungan Terdekat: Diskusikan ketakutan Anda dengan orang-orang terdekat yang dapat memberikan dukungan emosional dan perspektif yang menenangkan.\n\nTrivia: "Stabilitas dan dukungan dari orang terdekat dapat membantu meredakan ketakutan dan memberikan rasa aman."\n\n"Fear is only as deep as the mind allows." – Japanese Proverb';
            } else if (labelText == 'Steadiness' &&
                labelFace == 'Fear' &&
                textConfidence < 0.5) {
              recomendation =
                  'Cobalah Hal Baru untuk Mengalihkan Perhatian: Alihkan perhatian dari ketakutan dengan mencoba aktivitas baru yang menyenangkan dan bisa memberikan perspektif baru.\n\nAdaptasi dan Terima Perubahan: Jadikan momen ini sebagai kesempatan untuk belajar menerima ketidakpastian dan beradaptasi dengan perubahan.\n\nTrivia: "Ketidakpastian dapat menjadi peluang untuk pertumbuhan dan adaptasi yang lebih baik."\n\n"Courage is not the absence of fear, but the triumph over it." – Nelson Mandela';
            }

            if (labelText == 'Conscientiousness' &&
                labelFace == 'Fear' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Analisis dan Persiapkan Diri: Gunakan pendekatan analitis untuk memahami ketakutan Anda dan buat rencana untuk mengatasi setiap aspek yang memicu rasa takut.\n\nBuat Strategi Menghadapi Ketakutan: Dengan perencanaan yang matang, Anda dapat mengurangi ketakutan dan meningkatkan rasa kontrol.\n\nTrivia: "Pendekatan analitis dapat memberikan rasa kontrol dan mengurangi ketidakpastian."\n\n"Do not be afraid of mistakes, providing you do not make the same one twice." – Eleanor Roosevelt';
            } else if (labelText == 'Conscientiousness' &&
                labelFace == 'Fear' &&
                textConfidence < 0.5) {
              recomendation =
                  'Terima Ketidaksempurnaan: Izinkan diri Anda untuk menerima bahwa tidak semua hal dapat diprediksi atau dikontrol, dan itu adalah bagian dari kehidupan.\n\nGunakan Fleksibilitas untuk Menghadapi Ketakutan: Cobalah untuk lebih fleksibel dalam menghadapi ketidakpastian dan belajar menyesuaikan diri dengan situasi yang tidak terduga.\n\nTrivia: "Fleksibilitas dan penerimaan dapat membantu mengurangi ketegangan dan rasa takut."\n\n"Fear is a reaction. Courage is a decision." – Winston Churchill';
            }

            // DISGUSTTTTTTTTTTTT

            if (labelText == 'Dominance' &&
                labelFace == 'Disgust' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Identifikasi Sumber Ketidaknyamanan: Langsung cari tahu apa yang menyebabkan rasa muak dan buat rencana konkret untuk mengatasinya.\n\nAmbil Tindakan Segera: Jangan menunda. Lakukan tindakan cepat untuk mengubah situasi yang menyebabkan ketidaknyamanan atau muak.\n\nFokus pada Solusi: Alihkan energi dari rasa muak untuk mencari solusi dan memperbaiki keadaan.';
            } else if (labelText == 'Dominance' &&
                labelFace == 'Disgust' &&
                textConfidence < 0.5) {
              recomendation =
                  'Coba Pendekatan Diplomatis: Alih-alih bertindak agresif, gunakan pendekatan diplomatis untuk mengatasi sumber ketidaknyamanan.\n\nCari Dukungan: Diskusikan perasaan Anda dengan rekan kerja atau teman yang dapat membantu menemukan solusi.\n\nJangan Terburu-buru: Beri diri Anda waktu untuk merenungkan dan memproses sebelum mengambil tindakan yang diperlukan.';
            }

            if (labelText == 'Influence' &&
                labelFace == 'Disgust' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Ekspresikan Perasaan Anda: Bagikan perasaan Anda dengan orang lain untuk mendapatkan perspektif baru dan merasa didengar.\n\nAlihkan Perhatian dengan Aktivitas Positif: Lakukan sesuatu yang Anda nikmati untuk mengalihkan perhatian dari perasaan muak.\n\nCiptakan Lingkungan yang Menyenangkan: Ubahlah lingkungan Anda menjadi lebih positif untuk mengurangi rasa tidak nyaman.';
            } else if (labelText == 'Influence' &&
                labelFace == 'Disgust' &&
                textConfidence < 0.5) {
              recomendation =
                  'Berpikir dengan Tenang: Luangkan waktu untuk sendiri dan refleksikan apa yang menyebabkan perasaan muak.\n\nBatasi Paparan ke Hal Negatif: Hindari situasi atau orang yang memicu perasaan tersebut hingga Anda merasa siap untuk menghadapinya.\n\nPerkuat Hubungan dengan Orang Terdekat: Habiskan waktu dengan orang-orang yang mendukung Anda dan dapat memberikan kenyamanan emosional.';
            }

            if (labelText == 'Steadiness' &&
                labelFace == 'Disgust' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Cari Kenyamanan dalam Rutinitas: Kembali ke aktivitas rutin yang menenangkan untuk meredakan perasaan tidak nyaman.\n\nBicarakan dengan Orang Terpercaya: Diskusikan perasaan Anda dengan seseorang yang bisa memberikan dukungan dan nasihat.\n\nFokus pada Positivitas: Fokus pada hal-hal positif dalam hidup Anda untuk mengurangi rasa muak.';
            } else if (labelText == 'Steadiness' &&
                labelFace == 'Disgust' &&
                textConfidence < 0.5) {
              recomendation =
                  'Jelajahi Hal Baru: Cobalah aktivitas baru yang menarik untuk mengalihkan perhatian dari perasaan muak.\n\nTetap Fleksibel: Terbuka untuk menyesuaikan diri dengan perubahan dan temukan cara baru untuk menghadapi situasi.\n\nTemukan Keseimbangan: Jangan terlalu fokus pada satu hal yang membuat Anda muak; seimbangkan dengan kegiatan lain yang menyenangkan.';
            }

            if (labelText == 'Conscientiousness' &&
                labelFace == 'Disgust' &&
                textConfidence >= 0.5) {
              recomendation =
                  'Analisis Sumber Ketidaknyamanan: Lakukan analisis mendalam tentang apa yang membuat Anda merasa muak dan cari solusi yang sistematis.\n\nBuat Rencana Terperinci: Buat rencana langkah demi langkah untuk mengatasi situasi yang menyebabkan rasa muak.\n\nTetap Terorganisir: Pastikan lingkungan Anda teratur untuk mengurangi rasa tidak nyaman.';
            } else if (labelText == 'Conscientiousness' &&
                labelFace == 'Disgust' &&
                textConfidence < 0.5) {
              recomendation =
                  'Terima Ketidaksempurnaan: Sadari bahwa tidak semua situasi dapat diubah dengan segera, dan terimalah ketidaksempurnaan itu.\n\nGunakan Kreativitas untuk Menghadapi Ketidaknyamanan: Cari cara kreatif untuk mengatasi rasa muak, seperti mengeksplorasi hobi baru.\n\nBeri Diri Waktu: Jangan terburu-buru dalam mencari solusi; beri diri Anda waktu untuk merenung dan menemukan cara terbaik untuk bergerak maju.';
            }
          });
        },
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
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: filepathText == null
                                ? const Image(
                                    image: AssetImage('assets/foto.jpg'),
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    filepathText!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
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
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: filepathFace == null
                                ? const Image(
                                    image: AssetImage('assets/foto.jpg'),
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    filepathFace!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
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
                        '$labelText ${textConfidence.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
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
                        "Recommendation",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$labelFace',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        recomendation,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 128,
              )
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
