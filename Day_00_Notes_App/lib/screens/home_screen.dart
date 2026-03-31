import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_model.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  Color appBackgroundColor = const Color.fromARGB(255, 227, 177, 219);
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('myBox');
    notes = box.get('notes', defaultValue: <Note>[])!.cast<Note>();
    final savedColorValue = box.get('bgColor');
    if (savedColorValue != null) {
      setState(() {
        appBackgroundColor = Color(savedColorValue);
      });
    }
  }

  Widget _buildNoteCard(int index) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                EditNoteScreen(
                  note: notes[index], // или null для новой заметки
                  backgroundColor: appBackgroundColor,
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  // Плавное появление (Fade) вместо резкого прыжка
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
        if (result != null && result is Note) {
          setState(() {
            notes[index] = result;
            Hive.box('myBox').put('notes', notes);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(notes[index].colorValue ?? 0xFFFFFFFF),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notes[index].title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: Text(
                notes[index].content,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notes[index].createdAt != null
                  ? "${notes[index].createdAt!.day}.${notes[index].createdAt!.month}.${notes[index].createdAt!.year}"
                  : "Дата не указана",
              style: TextStyle(
                fontSize: 10,
                color: Colors.black.withAlpha(150),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        title: const Text('Мои заметки'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Цвет приложения'),
                  content: SingleChildScrollView(
                    child: SlidePicker(
                      pickerColor: appBackgroundColor,
                      onColorChanged: (color) {
                        setState(() {
                          appBackgroundColor = color; // Меняем цвет на лету
                        });
                        Hive.box('myBox').put('bgColor', color.toARGB32());
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
        ],
      ),
      body: Stack(
        children: [
          // 1. Сетка заметок (твой GridView)
          GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: notes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return LongPressDraggable<int>(
                data: index,
                onDragStarted: () => setState(() => isDragging = true),
                onDragEnd: (details) => setState(() => isDragging = false),
                feedback: Material(
                  color: Colors.transparent,
                  child: Container(
                    width:
                        MediaQuery.of(context).size.width *
                        0.4, // 40% ширины экрана
                    height: 150,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(notes[index].colorValue ?? 0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(80),
                          blurRadius: 10,
                          offset: const Offset(4, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notes[index].title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        Expanded(
                          child: Text(
                            notes[index].content,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: _buildNoteCard(index),
                ),
                child: _buildNoteCard(index),
              );
            },
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            // Если тащим заметку — спускаем корзину на 20 пикселей сверху, если нет — прячем за экран (-100)
            top: isDragging ? 20 : -100,
            left: MediaQuery.of(context).size.width / 2 - 40, // Центрируем
            child: DragTarget<int>(
              onAcceptWithDetails: (details) {
                setState(() {
                  notes.removeAt(details.data);
                  Hive.box('myBox').put('notes', notes);
                  isDragging = false; // Прячем корзину после удаления
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Заметка удалена'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              builder: (context, candidateData, rejectedData) {
                bool isHovered = candidateData.isNotEmpty;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isHovered ? Colors.red : Colors.white.withAlpha(180),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    isHovered ? Icons.delete : Icons.delete_outline,
                    color: isHovered ? Colors.white : Colors.red,
                    size: isHovered ? 45 : 35,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  EditNoteScreen(backgroundColor: appBackgroundColor),
            ),
          );
          if (result != null && result is Note) {
            setState(() {
              notes.add(result);
              Hive.box('myBox').put('notes', notes);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
