import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:sudoku/util/app_settings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> imagePaths = [];
  late int maxErrors;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final paths = await AppSettings.getImagePaths();
    final errors = await AppSettings.getMaxErrors();
    setState(() {
      imagePaths = paths;
      maxErrors = errors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.maxErrors),
            subtitle: Text(AppLocalizations.of(context)!.maxErrorsDesc),
            trailing: SizedBox(
              width: 60,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: TextEditingController(text: maxErrors.toString()),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  final newValue = int.tryParse(value);
                  if (newValue != null && newValue > 0) {
                    await AppSettings.setMaxErrors(newValue);
                    setState(() {
                      maxErrors = newValue;
                    });
                  }
                },
              ),
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.backgroundImage),
            subtitle: Text(AppLocalizations.of(context)!.backgroundImageDesc),
            trailing: IconButton(
              icon: Icon(Icons.add_photo_alternate),
              onPressed: () async {
                await AppSettings.pickAndCropImages();
                _loadSettings();
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(imagePaths[index]),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          setState(() {
                            imagePaths.removeAt(index);
                          });
                          await AppSettings.saveImagePaths(imagePaths);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
