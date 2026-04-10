import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const JXStudioPro());
}

class JXStudioPro extends StatelessWidget {
  const JXStudioPro({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const MainStudio(),
    );
  }
}

class MainStudio extends StatefulWidget {
  const MainStudio({super.key});
  @override
  _MainStudioState createState() => _MainStudioState();
}

class _MainStudioState extends State<MainStudio> {
  CameraController? _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool showSidhuAlert = false;
  int subCount = 104000;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  _initCamera() async {
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    await _controller!.initialize();
    setState(() {});
  }

  // THE REVOLUTIONARY ALERT SYSTEM
  void triggerMoosewalaAlert() async {
    setState(() {
      showSidhuAlert = true;
      subCount++;
    });
    
    // Play Sidhu Moosewala Sound
    await _audioPlayer.play(AssetSource('sound.mp3'));

    // Hide alert after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      setState(() => showSidhuAlert = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Preview (Full Screen)
          if (_controller != null && _controller!.value.isInitialized)
            Positioned.fill(child: CameraPreview(_controller!)),

          // 2. iOS Style Header
          Positioned(
            top: 50, left: 20, right: 20,
            child: FadeInDown(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("JX STUDIO PRO", style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.amber)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black26, borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.greenAccent),
                    ),
                    child: Text("$subCount SUBS", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),

          // 3. SIDHU MOOSEWALA POPUP (Cartoon Character)
          if (showSidhuAlert)
            Center(
              child: ZoomIn(
                duration: const Duration(milliseconds: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset('assets/character.json', height: 300), // Tera Cartoon
                    const SizedBox(height: 10),
                    Text("NEW JATT SUBSCRIBER!", style: GoogleFonts.permanentMarker(fontSize: 25, color: Colors.white)),
                  ],
                ),
              ),
            ),

          // 4. iOS Glass Bottom Controls
          Positioned(
            bottom: 40, left: 20, right: 20,
            child: FadeInUp(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white10, borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(CupertinoIcons.settings, color: Colors.white),
                    IconButton(
                      icon: const Icon(CupertinoIcons.play_circle_fill, color: Colors.amber, size: 50),
                      onPressed: triggerMoosewalaAlert, // Testing alert
                    ),
                    const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white),
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

