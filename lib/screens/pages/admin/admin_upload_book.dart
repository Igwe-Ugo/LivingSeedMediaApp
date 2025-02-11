import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:provider/provider.dart';
import '../../common/widget.dart';

class UploadBookScreen extends StatefulWidget {
  const UploadBookScreen({super.key});

  @override
  State<UploadBookScreen> createState() => _UploadBookScreenState();
}

class _UploadBookScreenState extends State<UploadBookScreen> {
  int selectedChapterNum = 1;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _whoseAboutController = TextEditingController();
  final TextEditingController _aboutAuthorController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  List<TextEditingController> _bookChapterController = [
    TextEditingController()
  ]; // initial textfield

  void updateTextFields(int count) {
    setState(() {
      selectedChapterNum = count;
      _bookChapterController =
          List.generate(count, (index) => TextEditingController());
    });
  }

  XFile? _coverImage;
  PlatformFile? _bookFile;

  Future<void> _pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _coverImage = pickedImage;
      });
    }
  }

  Future<void> _pickBookFile() async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _bookFile = result.files.first;
      });
    }
  }

  void _uploadBook() {
    if (_formKey.currentState!.validate() &&
        _coverImage != null &&
        _bookFile != null) {
      // Perform the upload logic here, e.g., send data to backend or Firebase
      _uploadBookToJson;
      _clearFields;
      showMessage('Book uploaded successfully!', context);
      // Clear the form
      _formKey.currentState!.reset();
      setState(() {
        _coverImage = null;
        _bookFile = null;
      });
    } else {
      showMessage('Please fill all fields and upload files!', context);
    }
  }

  void _clearFields() {
    _titleController.clear();
    _authorController.clear();
    _amountController.clear();
    _reviewController.clear();
    _aboutAuthorController.clear();
    _aboutAuthorController.clear();
    _whoseAboutController.clear();
    _bookChapterController.forEach((controller) => controller.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                        icon: const Icon(
                          Iconsax.arrow_left_2,
                          size: 17,
                        )),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Upload Book',
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        elevation: WidgetStatePropertyAll(0),
                      ),
                      onPressed: _pickCoverImage,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: const [
                            Icon(
                              Iconsax.image,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              'Upload Cover Image',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (_coverImage != null)
                      Text(
                        'Image Selected',
                        style: TextStyle(color: Colors.green[700]),
                      )
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Book Title...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the book title';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _authorController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Author of book...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the author of the book';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Book Price... (#)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the prize of the book';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton(
                  value: selectedChapterNum,
                  items: List.generate(
                    20,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text(
                          'How many chapters of book?... ${index + 1} Fields'),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      updateTextFields(value);
                    }
                  },
                ),

                // display text field based on selected chapter numbers
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedChapterNum,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            border: Border.all(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.15),
                            ),
                          ),
                          child: TextFormField(
                            controller: _bookChapterController[index],
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Chapter ${index + 1} title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.2),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the number of chapters of the book';
                              }
                              return null;
                            },
                          ),
                        );
                      }),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Write preface...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    maxLines: 10,
                    maxLength: 300,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please write about the preface of the book';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "What's it about...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    maxLines: 10,
                    maxLength: 300,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe what the book is about!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _whoseAboutController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Who's it about...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    maxLines: 10,
                    maxLength: 300,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the target audience';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _aboutAuthorController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "About the author...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    maxLines: 10,
                    maxLength: 300,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please tell us about the author';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(elevation: WidgetStatePropertyAll(0)),
                      onPressed: _pickBookFile,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: const [
                            Icon(
                              Iconsax.document_1,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Upload Book File (PDF)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (_bookFile != null)
                      Text(
                        'File Selected',
                        style: TextStyle(color: Colors.green[700]),
                      )
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _uploadBook,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(10, 50),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Center(
                          child: Text('Upload Book',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17.0,
                                  color: Colors.white))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _uploadBookToJson() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all available input spaces', context);
    }

    List<Map<String, String>> chapters = [];

    for (int i = 0; i < _bookChapterController.length; i++) {
      String text = _bookChapterController[i].text.trim();
      if (text.isEmpty) {
        chapters.add({
          "index 1": "Dedication",
          "index 2": "Preface",
          "index 3": "Acknowledgements",
          "chapter ${i + 1}": text
        });
      }
    }

    AboutBooks newUpload = AboutBooks(
        coverImage: _coverImage.toString(),
        bookTitle: _titleController.text,
        author: _authorController.text,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        aboutPreface: _reviewController.text,
        aboutAuthor: _aboutAuthorController.text,
        aboutBook: _descriptionController.text,
        whoseAbout: _whoseAboutController.text,
        chapterNum: _bookChapterController.length,
        pdfLink: _bookFile.toString(),
        chapters: chapters,
        ratingReviews: []);

    bool success = await Provider.of<AboutBookProvider>(context, listen: false)
        .uploadBook(newUpload);
    if (success) {
      showMessage('Upload is successful!', context);
      return;
    } else {
      showMessage('Book already exists, please upload a new book', context);
      return;
    }
  }
}
