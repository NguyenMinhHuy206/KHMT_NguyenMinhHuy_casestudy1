import 'package:flutter/material.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final bool isEditing;

  const AddEditTransactionScreen({
    super.key,
    required this.isEditing,
  });

  @override
  State<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState
    extends State<AddEditTransactionScreen> {
  bool _isExpense = true;

  late final TextEditingController _amountController;
  late final TextEditingController _dateController;
  late final TextEditingController _noteController;

  String _selectedCategory = 'Ăn uống';

  final List<String> _categories = [
    'Ăn uống',
    'Mua sắm',
    'Giải trí',
    'Hóa đơn',
    'Lương',
  ];

  // Màu đỏ giống ảnh mẫu
  static const Color primaryRed = Color(0xFFFF5B62);

  // Màu xanh nút Lưu
  static const Color primaryBlue = Color(0xFF2878E8);

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(
      text: widget.isEditing ? '100.000' : '',
    );

    _dateController = TextEditingController(
      text: '12/04/2025',
    );

    _noteController = TextEditingController(
      text: widget.isEditing ? 'Ăn trưa' : '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // =========================
  // LABEL
  // =========================

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF26364A),
      ),
    );
  }

  // =========================
  // INPUT STYLE
  // =========================

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(
        color: Color(0xFFD9E0E8),
        width: 1,
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
    String? suffixText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixText: suffixText,
      suffixIcon: suffixIcon,

      hintStyle: const TextStyle(
        color: Color(0xFF9AA5B1),
        fontSize: 12,
      ),

      suffixStyle: const TextStyle(
        color: Color(0xFF657180),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),

      enabledBorder: _inputBorder(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xFF9DB6D4),
          width: 1,
        ),
      ),
    );
  }

  // =========================
  // TAB CHI TIÊU / THU NHẬP
  // =========================

  Widget _buildTransactionType() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFDCE3EB),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpense = true;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _isExpense
                      ? primaryRed
                      : Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  'Chi tiêu',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _isExpense
                        ? Colors.white
                        : const Color(0xFF39485A),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpense = false;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !_isExpense
                      ? primaryRed
                      : Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  'Thu nhập',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: !_isExpense
                        ? Colors.white
                        : const Color(0xFF39485A),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // DANH MỤC
  // =========================

  Widget _buildCategory() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFD9E0E8),
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,

          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Color(0xFF687789),
          ),

          dropdownColor: Colors.white,

          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Row(
                children: [
                  Container(
                    width: 23,
                    height: 23,
                    decoration: BoxDecoration(
                      color: primaryRed,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),

                  const SizedBox(width: 9),

                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF344256),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          onChanged: (value) {
            if (value == null) return;

            setState(() {
              _selectedCategory = value;
            });
          },
        ),
      ),
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        toolbarHeight: 52,

        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 17,
            color: Color(0xFF27374A),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          widget.isEditing
              ? 'Sửa giao dịch'
              : 'Thêm giao dịch',
          style: const TextStyle(
            color: Color(0xFF17263A),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            18,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =========================
              // CHI TIÊU / THU NHẬP
              // =========================

              _buildTransactionType(),

              const SizedBox(height: 15),

              // =========================
              // DANH MỤC
              // =========================

              _buildLabel('Danh mục'),

              const SizedBox(height: 6),

              _buildCategory(),

              const SizedBox(height: 14),

              // =========================
              // SỐ TIỀN
              // =========================

              _buildLabel('Số tiền'),

              const SizedBox(height: 6),

              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF344256),
                  fontWeight: FontWeight.w500,
                ),
                decoration: _inputDecoration(
                  hintText: 'Nhập số tiền',
                  suffixText: 'đ',
                ),
              ),

              const SizedBox(height: 14),

              // =========================
              // NGÀY GIAO DỊCH
              // =========================

              _buildLabel('Ngày giao dịch'),

              const SizedBox(height: 6),

              TextField(
                controller: _dateController,
                readOnly: true,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF344256),
                  fontWeight: FontWeight.w500,
                ),
                decoration: _inputDecoration(
                  suffixIcon: const Icon(
                    Icons.calendar_month_outlined,
                    size: 17,
                    color: Color(0xFF657789),
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2025, 4, 12),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );

                  if (pickedDate != null) {
                    final day =
                    pickedDate.day.toString().padLeft(2, '0');

                    final month =
                    pickedDate.month.toString().padLeft(2, '0');

                    final year =
                    pickedDate.year.toString();

                    setState(() {
                      _dateController.text =
                      '$day/$month/$year';
                    });
                  }
                },
              ),

              const SizedBox(height: 14),

              // =========================
              // GHI CHÚ
              // =========================

              _buildLabel('Ghi chú'),

              const SizedBox(height: 6),

              TextField(
                controller: _noteController,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF344256),
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Nhập ghi chú (tùy chọn)',

                  hintStyle: const TextStyle(
                    color: Color(0xFF9AA5B1),
                    fontSize: 12,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding: const EdgeInsets.all(12),

                  enabledBorder: _inputBorder(),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(
                      color: Color(0xFF9DB6D4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // NÚT LƯU
              // =========================

              SizedBox(
                width: double.infinity,
                height: 40,

                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Lưu giao dịch thành công!',
                        ),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),

                    padding: EdgeInsets.zero,
                  ),

                  child: const Text(
                    'Lưu',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}