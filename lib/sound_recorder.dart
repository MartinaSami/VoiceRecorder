import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

const pathToSaveAudio = 'audio_example.aac';

class SoundREcorder {
  FlutterSoundRecorder? audioRecorder;
  bool isRecordingInitialsied = false;
  bool get isRecording => audioRecorder!.isRecording;

  Future init() async {
    audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone Permission");
    }
    await audioRecorder!.openAudioSession();
    isRecordingInitialsied = true;
  }

  void dispose() {
    if (!isRecordingInitialsied) return;
    audioRecorder!.closeAudioSession();
    audioRecorder = null;
    isRecordingInitialsied = false;
  }

  Future record() async {
    if (!isRecordingInitialsied) return;
    await audioRecorder!.startRecorder(toFile: pathToSaveAudio);
    
  }

  Future stop() async {
    if (!isRecordingInitialsied) return;
    await audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (audioRecorder!.isStopped) {
      await record();
    } else {
      await stop();
    }
  }
}
