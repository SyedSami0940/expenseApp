import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/content/colors.dart';
import 'package:expenseapp/model/expense/expenseDash_detail_model.dart';
import 'package:expenseapp/screen/loginScreen.dart';
import 'package:expenseapp/services/dashTitle_detail_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

num totalamount = 0;

class ExpenseDetailView extends StatefulWidget {
  const ExpenseDetailView({super.key});

  @override
  State<ExpenseDetailView> createState() => _ExpenseDetailViewState();
}

class _ExpenseDetailViewState extends State<ExpenseDetailView> {
  bool _isLogoutLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
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

  Future<void> _addDetail() async {
    final subTitle = _titleController.text.trim();
    final amount = _amountController.text.trim();
    if (subTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a Amount'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final Title_detail = DashTitleDetail(
        subTitle: subTitle,
        amount: int.parse(amount),
        dateTime: Timestamp.now(),
        TAmount: totalamount,
      );
      await _databaseService.addTitle(Title_detail);
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

  void _showAddTitleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title TextField
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter title...',
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
            ),

            const SizedBox(height: 16), // Spacing

            // Amount TextField
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                hintText: 'Enter amount...',
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                hintText: 'Select date...',
                labelText: 'Date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    String date = DateFormat.yMMMMd().format(pickedDate!);
                    _dateController.text = date;
                    setState(() {});
                    if (pickedDate != null) {
                      _dateController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    }
                  },
                ),
              ),
              readOnly: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addDetail,
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

  Future<void> _deleteTitle(String titleId) async {
    try {
      await _databaseService.deleteTitle(titleId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title deleted successfully'),
          backgroundColor: Colors.green,
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

  Widget _buildTitleItem(DashTitleDetail details, String itemId) {
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
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Amount Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      details.subTitle,
                      style: TextStyle(
                        color: Color(ex_color.black_clr),
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'RS ${details.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Date and Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM yyyy')
                            .format(details.dateTime.toDate()),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.teal),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('h:mm a').format(details.dateTime.toDate()),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.teal),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          onLongPress: () => _deleteTitle(itemId),
        ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(color: Colors.black54),
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
      body: StreamBuilder<QuerySnapshot<DashTitleDetail>>(
        stream: _databaseService.getTitles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Color(ex_color.redout)),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_add,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No entries yet - add one!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final entries = snapshot.data!.docs;
          double totalAmount = entries.fold<double>(
            0.0,
            (sum, doc) => sum + doc.data().amount,
          );

          return Column(
            children: [
              // Expense List
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final doc = entries[index];
                    final details = doc.data();
                    return _buildTitleItem(details, doc.id);
                  },
                ),
              ),
              // Total Amount Section
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'Rs${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      // Main button to add title
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: _showAddTitleDialog,
          backgroundColor: Color(ex_color.btn_botton),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
