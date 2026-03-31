import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/note_model.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? note;
  final Color backgroundColor;
  const EditNoteScreen({super.key, this.note, required this.backgroundColor});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late Color pickerColor;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');
    pickerColor = widget.note != null
        ? Color(widget.note?.colorValue ?? 0xFFFFFFFF)
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.backgroundColor,
        title: Text(
          widget.note == null ? 'Новая заметка' : 'Редактировать заметку',
        ),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: contentController.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Текст скопирован')),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Введите заголовок заметки',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: contentController,
              maxLines: null,
              decoration: InputDecoration(hintText: 'Введите текст заметки'),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Цвет заметки'),
              trailing: CircleAvatar(backgroundColor: pickerColor, radius: 15),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Выбор цвета'),
                    content: SingleChildScrollView(
                      child: SlidePicker(
                        pickerColor: pickerColor,
                        onColorChanged: (color) {
                          setState(() => pickerColor = color);
                        },
                        displayThumbColor: true,
                        showParams: true,
                        colorModel: ColorModel.rgb,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Готово'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newNote = Note(
                  title: titleController.text,
                  content: contentController.text,
                  createdAt: widget.note?.createdAt ?? DateTime.now(),
                  colorValue: pickerColor.toARGB32(),
                );
                Navigator.pop(context, newNote);
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
