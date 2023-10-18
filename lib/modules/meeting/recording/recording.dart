import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen_recorder/screen_recorder.dart';

import '../../../core/shared_widgets/shared_widgets.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  bool _recording = false;
  bool _exporting = false;
  ScreenRecorderController controller = ScreenRecorderController();
  bool get canExport => controller.exporter.hasFrames;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("dd"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_exporting)
                const Center(child: const DefaultLoaderGrey())
              else ...[
                ScreenRecorder(
                  height: 500,
                  width: 500,
                  controller: controller,
                  child: const SizedBox(
                      child: Text("ffffffffffffffffffffffffffff")),
                ),
                if (!_recording && !_exporting)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        controller.start();
                        setState(() {
                          _recording = true;
                        });
                      },
                      child: const Text('Start'),
                    ),
                  ),
                if (_recording && !_exporting)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        controller.stop();
                        setState(() {
                          _recording = false;
                        });
                      },
                      child: const Text('Stop'),
                    ),
                  ),
                if (canExport && !_exporting)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _exporting = true;
                        });
                        await controller.exporter.exportFrames().then((value) {
                          if (value == null) {
                            throw Exception();
                          }
                          setState(() => _exporting = false);

                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: SizedBox(
                                  height: 500,
                                  width: 500,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(8.0),
                                    itemCount: value.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final image = value[index].image;
                                      return SizedBox(
                                        height: 150,
                                        child: Image.memory(
                                          image.buffer.asUint8List(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        });
                      },
                      child: const Text('Export as frames'),
                    ),
                  ),
                if (canExport && !_exporting) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _exporting = true;
                        });
                        await controller.exporter.exportGif().then((gif) {
                          if (gif == null) {
                            throw Exception();
                          }
                          setState(() => _exporting = false);

                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Image.memory(Uint8List.fromList(gif)),
                              );
                            },
                          );
                        });
                      },
                      child: const Text('Export as GIF'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          controller.exporter.clear();
                        });
                      },
                      child: const Text('Clear recorded data'),
                    ),
                  )
                ]
              ]
            ],
          ),
        ),
      ),
    );
  }
}
