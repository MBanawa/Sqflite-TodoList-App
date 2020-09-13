import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/service/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {




  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = List<Category>();

  var category;

  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCateory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescriptionController.text =
          category[0]['description'] ?? 'No Description';
    });
    _editFormDialog(context);
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(
      content: message,
      backgroundColor: Colors.green,
      duration: const Duration(milliseconds: 1000),
    );
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  _showDeleteSnackBar(message) {
    var _snackBar = SnackBar(
      content: message,
      backgroundColor: Colors.red,
      duration: const Duration(milliseconds: 1000),
    );
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  // form dialog for ADDING new categories
  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                color: Colors.red,
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Colors.green,
                onPressed: () async {                  
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;
                  var result = await _categoryService.saveCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackBar(
                      Text('Category Successfully Added!'),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
            title: Text('Categories Form'),
            content: SingleChildScrollView(
                child: Column(
              children: [
                TextField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a Category',
                    labelText: 'Category',
                  ),
                ),
                TextField(
                  controller: _categoryDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Write a Description',
                    labelText: 'Description',
                  ),
                ),
              ],
            )),
          );
        });
  }

// form dialog for EDITING  categories
  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                color: Colors.red,
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Colors.green,
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryNameController.text;
                  _category.description =
                      _editCategoryDescriptionController.text;
                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackBar(
                      Text('Category Successfully Updated!'),
                    );
                  }
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit Categories Form'),
            content: SingleChildScrollView(
                child: Column(
              children: [
                TextField(
                  controller: _editCategoryNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a Category',
                    labelText: 'Category',
                  ),
                ),
                TextField(
                  controller: _editCategoryDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Write a Description',
                    labelText: 'Description',
                  ),
                ),
              ],
            )),
          );
        });
  }

  // form dialog for DELETING  categories
  _deleteFormDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                color: Colors.grey,
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              FlatButton(
                color: Colors.red,
                onPressed: () async {

                  var result = await _categoryService.deleteCategory(categoryId);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
                    _showDeleteSnackBar(
                      Text('Category Deleted Permanently'),
                    );
                  }
                },
                child: Text('Delete'),
              ),
            ],
            title: Text('Are you sure you want to delete this Category?'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: FlatButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen())),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text('Categories'),
      ),
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                elevation: 8.0,
                child: ListTile(
                  leading: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editCateory(context, _categoryList[index].id);
                      }),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_categoryList[index].name),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          _deleteFormDialog(context, _categoryList[index].id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
