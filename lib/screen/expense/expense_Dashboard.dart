import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/screen/expense/expense_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expenseapp/content/colors.dart';
import 'package:expenseapp/model/expense/expenseDash_model.dart';
import 'package:expenseapp/screen/loginScreen.dart';
import 'package:expenseapp/services/dashboardTitle_db.dart';

class ExpenseDashboardView extends StatefulWidget {
  const ExpenseDashboardView({super.key});

  @override
  State<ExpenseDashboardView> createState() => _ExpenseDashboardViewState();
}

class _ExpenseDashboardViewState extends State<ExpenseDashboardView> {
  bool _isLogoutLoading = false;
  final TextEditingController _titleController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  @override
  void dispose() {
    _titleController.dispose();

    super.dispose();
  }

  Future<void> _logOut() async {
    try {
      setState(() => _isLogoutLoading = true);
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginscreenView()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLogoutLoading = false);
    }
  }

  Future<void> _addTitle() async {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final dashTitle = DashboardTitle(
        title: title,
        createdOn: Timestamp.now(),
      );
      await _databaseService.addTitle(dashTitle);
      if (!mounted) return;
      Navigator.pop(context);
      _titleController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add title: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteTitle(String titleId) async {
    try {
      await _databaseService.deleteTitle(titleId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title deleted successfully'),
          backgroundColor: Color.fromARGB(255, 175, 76, 76),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete title: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddTitleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a Title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter title...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 10),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addTitle,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(ex_color.btn_botton),
            ),
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleItem(DashboardTitle title, String titleId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Color(ex_color.list_color),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          child: ListTile(
            title: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title.title,
                    style: TextStyle(
                      color: Color(ex_color.black_clr),
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  // Text(
                  //   '$totalamount',
                  //   style: TextStyle(
                  //     color: Colors.green,
                  //     fontWeight: FontWeight.w700,
                  //     fontSize: 20,
                  //   ),
                  // ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExpenseDetailView(),
                  ),
                );
              },
            ),
            subtitle: Text(
              DateFormat('dd-MM-yyyy h:mm a').format(title.createdOn.toDate()),
              style: const TextStyle(fontSize: 12, color: Colors.teal),
            ),
            onLongPress: () => _deleteTitle(titleId),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExpenseDetailView(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: _isLogoutLoading ? null : _logOut,
            icon: _isLogoutLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.exit_to_app,
                    color: Color(ex_color.redout),
                  ),
            tooltip: 'Log out',
          ),
        ],
      ),
      drawer: Drawer(),
      body: StreamBuilder<QuerySnapshot<DashboardTitle>>(
        stream: _databaseService.getTitles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No titles yet - add one!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final titles = snapshot.data!.docs;
          return ListView.builder(
            itemCount: titles.length,
            itemBuilder: (context, index) {
              final doc = titles[index];
              return _buildTitleItem(doc.data(), doc.id);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTitleDialog,
        backgroundColor: Color(ex_color.btn_botton),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
