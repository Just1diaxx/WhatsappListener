import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const WhatsappListener());
}

class WhatsappListener extends StatelessWidget {
  const WhatsappListener({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      home: const WhatsappListenerHome(),
    );
  }
}

class WhatsappListenerHome extends StatefulWidget {
  const WhatsappListenerHome({super.key});

  @override
  State<WhatsappListenerHome> createState() => _WhatsappListenerHomeState();
}

class _WhatsappListenerHomeState extends State<WhatsappListenerHome> {
  FilePickerResult? result;
  AudioPlayer player = AudioPlayer();
  double playbackRate = 1.0;
  String durationText = "";

  @override
  void initState() {
    super.initState();
    player.onDurationChanged.listen((Duration duration) {
      setState(() {
        durationText = formatDuration(duration);
      });
    });
  }

  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whatsapp Listener'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          children: [
            Image.network('https://i.imgur.com/klbOWRT.png', height: 300),
            result == null
                ? const Text('Select an audio file from whatsapp to play.')
                : Text(result!.files.single.name),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: result != null ? playAudio : null,
                  icon: Icon(
                      result != null ? Icons.play_arrow : Icons.play_disabled),
                  iconSize: 100,
                ),
                IconButton(
                  onPressed: result != null ? stopAudio : null,
                  icon: const Icon(Icons.stop),
                  iconSize: 50,
                ),
                ElevatedButton(
                  onPressed: togglePlaybackRate,
                  child: Text("x$playbackRate"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (result != null) {
                      // Display duration in UI
                      null;
                    }
                  },
                  child: Text(durationText),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: pickFile,
              child: const Icon(Icons.audio_file),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickFile() async {
    result = await FilePicker.platform.pickFiles(type: FileType.audio);
    player.play(DeviceFileSource(result!.files.single.path!));
    player.pause();
    setState(() {});
  }

  void playAudio() {
    if (result != null) {
      // Load and play the audio file
      player.play(DeviceFileSource(result!.files.single.path!));
    }
  }

  void togglePlaybackRate() {
    playbackRate = playbackRate == 1.0 ? 2.0 : 1.0;
    player.setPlaybackRate(playbackRate);
    setState(() {});
  }

  void stopAudio() {
    result == null ? null : player.stop();
  }
}
