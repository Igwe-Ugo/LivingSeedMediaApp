import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:provider/provider.dart';
import '../../common/widget.dart';

class UploadBibleStudy extends StatefulWidget {
  const UploadBibleStudy({super.key});

  @override
  State<UploadBibleStudy> createState() => _UploadBibleStudyState();
}

class _UploadBibleStudyState extends State<UploadBibleStudy> {
  int selectedChapterNum = 1;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  List<TextEditingController> _bibleStudyChapterController = [
    TextEditingController()
  ]; // initial textfield

  void updateTextFields(int count) {
    setState(() {
      selectedChapterNum = count;
      _bibleStudyChapterController =
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

  Future<void> _pickBibleStudyFile() async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _bookFile = result.files.first;
      });
    }
  }

  void _uploadBibleStudy() {
    if (_formKey.currentState!.validate() &&
        _coverImage != null &&
        _bookFile != null) {
      // Perform the upload logic here, e.g., send data to backend or Firebase
      _uploadBibleStudyToJson();
      _clearFields();
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
    _subtitleController.clear();
    _amountController.clear();
    _bibleStudyChapterController.forEach((controller) => controller.clear());
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
                      'Upload Bible Study Material',
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 18,
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
                    controller: _subtitleController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Subtitle of bible study...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the subtitle of the bible study';
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
                      hintText: 'Bible Study Price... (#)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the prize of the bible study material';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: DropdownButton(
                    value: selectedChapterNum,
                    items: List.generate(
                      20,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text(
                          'How many contents of bible study?... ${index + 1} Fields',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        updateTextFields(value);
                      }
                    },
                  ),
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
                            controller: _bibleStudyChapterController[index],
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Content ${index + 1} title',
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
                Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(elevation: WidgetStatePropertyAll(0)),
                      onPressed: _pickBibleStudyFile,
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
                              'Upload Bible Study File (PDF)',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (_bookFile != null)
                      Text(
                        'File Selected',
                        style:
                            TextStyle(color: Colors.green[700], fontSize: 12),
                      )
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _uploadBibleStudy,
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
                          child: Text('Upload Bible Study',
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

  void _uploadBibleStudyToJson() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all available input spaces', context);
    }

    List<Map<String, String>> contents = [];

    for (int i = 0; i < _bibleStudyChapterController.length; i++) {
      String text = _bibleStudyChapterController[i].text.trim();
      if (text.isNotEmpty) {
        contents.add({"chapter ${i + 1}": text});
      }
    }

    BibleStudyMaterial newUpload = BibleStudyMaterial(
        coverImage: _coverImage!.path.toString(),
        title: _titleController.text,
        subTitle: _subtitleController.text,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        chapterNum: _bibleStudyChapterController.length,
        pdfLink: _bookFile!.path.toString(),
        contents: contents,
        ratingReviews: []);

    bool success = await Provider.of<BibleStudyProvider>(context, listen: false)
        .uploadBibleStudy(newUpload);
    if (success) {
      showMessage('Bible Study uploaded successfully!', context);
      GoRouter.of(context).pop();
    } else {
      showMessage(
          'Bible Study already exists, please upload a new book', context);
      return;
    }
  }
}
