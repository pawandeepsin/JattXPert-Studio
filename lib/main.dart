 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:audioplayers/audioplayers.dart';
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
  bool showNamePopup = false;
  String lastSubName = "DEEP JATT"; // Default testing name
  int subCount = 104000;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  _initCamera() async {
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras[0], ResolutionPreset.max);
      await _controller!.initialize();
      setState(() {});
    }
  }

  // NAME POPUP LOGIC
  void triggerNewSub(String name) async {
    setState(() {
      lastSubName = name.toUpperCase();
      showNamePopup = true;
      subCount++;
    });
    
    // Play Sidhu Moosewala Sound
    await _audioPlayer.play(AssetSource('sound.mp3'));

    // Hide popup after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      setState(() => showNamePopup = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Feed
          if (_controller != null && _controller!.value.isInitialized)
            Positioned.fill(child: CameraPreview(_controller!)),

          // 2. iOS Header
          Positioned(
            top: 50, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("JX STUDIO PRO", style: GoogleFonts.oswald(fontSize: 24, color: Colors.amber, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black45, borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.greenAccent),
                  ),
                  child: Text("$subCount SUBS", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // 3. SUBSCRIBER NAME POPUP (The New System)
          if (showNamePopup)
            Center(
              child: ElasticIn(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
                      ),
                      child: Text(
                        "NEW SUBSCRIBER",
                        style: GoogleFonts.bebasNeue(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lastSubName,
                      style: GoogleFonts.anton(
                        fontSize: 50, 
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black, blurRadius: 15)],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 4. Bottom Controls
          Positioned(
            bottom: 40, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Testing Button
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => triggerNewSub("Sidhu Fan"), 
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                    child: const Icon(CupertinoIcons.bell_fill, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 
