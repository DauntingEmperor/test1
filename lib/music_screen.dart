import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';

class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _filePath;
  bool _isPlaying = false;

  Future<void> _pickMusicFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      _filePath = result.files.single.path;
      setState(() {});
    }
  }

  void _playMusic() {
    if (_filePath != null) {
      _audioPlayer.play(_filePath!, isLocal: true);
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _pauseMusic() {
    _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _stopMusic() {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _filePath == null
                ? Text('No music file selected.')
                : Text('Selected file: ${_filePath!.split('/').last}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickMusicFile,
              child: Text('Pick Music File'),
            ),
            if (_filePath != null) ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isPlaying ? _pauseMusic : _playMusic,
                child: Text(_isPlaying ? 'Pause' : 'Play'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _stopMusic,
                child: Text('Stop'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
