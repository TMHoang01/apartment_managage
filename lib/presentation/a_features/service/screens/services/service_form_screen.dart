import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/service/enum_service.dart';
import 'package:apartment_managage/domain/models/service/price_list.dart';
import 'package:apartment_managage/domain/models/service/service.dart';
import 'package:apartment_managage/presentation/a_features/service/blocs/service_form/service_form_bloc.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/sl.dart';
import 'package:apartment_managage/utils/utils.dart';

class ServiceFormScreen extends StatefulWidget {
  final ServiceModel? service;
  const ServiceFormScreen({super.key, this.service});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final ServiceFormBloc _serviceFormBloc = sl.get<ServiceFormBloc>();

  final _keyForm = GlobalKey<FormState>();
  final _imageController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController(text: 'Hoangf des');
  ServiceType? _typeController;
  List<PriceListItem> priceList = [];
  int selectType = 0;
  Widget sizebox20 = const SizedBox(height: 20);
  @override
  void dispose() {
    _keyForm.currentState?.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.service != null) {
      _serviceFormBloc.add(ServiceFormEditStarted(
        service: widget.service!,
      ));
      _titleController.text = widget.service!.title!;
      _descriptionController.text = widget.service!.description!;
      _typeController = widget.service!.type;
      priceList = [...widget.service!.priceList!];
    } else {
      _serviceFormBloc.add(ServiceFormAddStarted());
      // priceList = [PriceList()];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Tạo dịch vụ'),
      ),
      body: BlocProvider.value(
        value: _serviceFormBloc,
        child: BlocConsumer<ServiceFormBloc, ServiceFormState>(
          // bloc: _serviceFormBloc,
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            _handleListener(context, state);
          },
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              // physics: const NeverScrollableScrollPhysics(),
              child: _handleState(state),
            );
          },
        ),
      ),
    );
  }

  void _handleListener(BuildContext context, ServiceFormState state) {
    if (state.isAddForm && state.status == ServiceFormStatus.success) {
      showSnackBar(context, 'Thêm dịch vụ thành công', Colors.green);
      Navigator.of(context).pop();
    } else if (!state.isAddForm && state.status == ServiceFormStatus.success) {
      showSnackBar(context, 'Sửa dịch vụ thành công', Colors.green);
      Navigator.of(context).pop();
    } else if (state.status == ServiceFormStatus.failure) {
      showSnackBarError(context, state.message);
    }
  }

  Widget _handleState(ServiceFormState state) {
    return _formCreate(context, state);
  }

  Widget _formCreate(BuildContext context, ServiceFormState state) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Form(
      key: _keyForm,
      child: Column(
        children: [
          sizebox20,
          SizedBox(
            height: 200,
            child: ImageInputPiker(
              url: widget.service?.image,
              onFileSelected: (file) {
                _imageController.text = file!.path;
              },
            ),
          ),
          sizebox20,
          CustomTextFormField(
            controller: _titleController,
            hintText: 'Tên dịch vụ',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập tên dịch vụ';
              }
              return null;
            },
          ),
          sizebox20,
          CustomTextFormField(
            controller: _descriptionController,
            maxLines: 5,
            textInputType: TextInputType.multiline,
            hintText: 'Mô tả',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mô tả';
              }
              return null;
            },
          ),
          sizebox20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonFormField<ServiceType>(
              decoration: const InputDecoration(
                // hintText: 'Chọn loại dịch vụ',
                labelText: 'Chọn loại dịch vụ',
              ),
              iconSize: 20,
              value: _typeController,
              validator: (value) =>
                  value == null ? 'Vui lòng chọn loại dịch vụ' : null,
              items: ServiceType.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(' ${e.toName()}'),
                      ))
                  .toList(),
              onChanged: (value) {
                _typeController = value;
              },
            ),
          ),
          sizebox20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hình thức tính giá',
                  style: theme.textTheme.headlineMedium!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                serviceFormStateBlocSelector<PriceType?>(
                  selector: (state) {
                    return state.service?.priceType ?? PriceType.fixed;
                  },
                  builder: (context, priceType) {
                    return Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...PriceType.values
                                  .map(
                                    (e) => SelectWidget(
                                      warp: true,
                                      text: e.toName(),
                                      isSelect: priceType == e,
                                      onChanged: () {
                                        if (e == priceType) {
                                          return;
                                        }
                                        if ((e == PriceType.other &&
                                                priceType ==
                                                    PriceType.package) ||
                                            (e == PriceType.package &&
                                                priceType == PriceType.other)) {
                                          logger.d(' not clear price list');
                                        } else {
                                          priceList = [];
                                        }
                                        _serviceFormBloc.add(
                                          ServiceFormPriceTypeChanged(
                                              priceType: e),
                                        );
                                      },
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                        _buildSelectTypePrice(context, priceType),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          sizebox20,
          CustomButton(
            title: 'Xác nhận',
            prefixWidget: state.status == ServiceFormStatus.loading
                ? Transform.scale(
                    scale: 0.5,
                    child: const CircularProgressIndicator(),
                  )
                : null,
            onPressed: state.status == ServiceFormStatus.loading
                ? null
                : () {
                    _handleSubmit(context);
                  },
          ),
        ],
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    if (!_keyForm.currentState!.validate()) {
      logger.d('validate fail $_typeController');
      showSnackBar(context, 'Vui lòng nhập đủ thông tin', Colors.red);
      return;
    } else if (_imageController.text.isEmpty &&
        (widget.service!.image == null || widget.service!.image!.isEmpty)) {
      showSnackBar(context, 'Vui lòng chọn ảnh', Colors.red);
      return;
    } else {
      ServiceModel service = ServiceModel(
        title: _titleController.text,
        description: _descriptionController.text,
        type: _typeController!,
        priceList: priceList,
      );
      if (widget.service != null) {
        service = service.copyWith(
          id: widget.service!.id,
          image: widget.service!.image,
          type: _typeController!,
          priceList: priceList,
        );
      }
      _serviceFormBloc.add(
          ServiceFormSubmit(service: service, file: _imageController.text));
    }
  }

  void _handleAddPrice(BuildContext context, {PriceListItem? price}) {
    // open dialog
    showDialog(
        context: context,
        builder: (context) => _dialogBuilder(context, price: price));
  }

  Widget _dialogBuilder(BuildContext context, {PriceListItem? price}) {
    final TextEditingController noteController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    if (price != null) {
      noteController.text = price.note ?? '';
      priceController.text = price.price?.toString() ?? '';
      nameController.text = price.name ?? '';
    }

    // Xây dựng AlertDialog
    final AlertDialog alertDialog = AlertDialog(
      title: const Text('Thêm dịch vụ'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              margin: EdgeInsets.zero,
              controller: nameController,
              hintText: 'Tên dịch vụ',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: priceController,
              margin: EdgeInsets.zero,
              hintText: 'Giá',
              textInputType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập giá';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: noteController,
              margin: EdgeInsets.zero,
              hintText: 'Ghi chú',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập ghi chú';
                }
                return null;
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            // FocusScope.of(context).unfocus();
            if (nameController.text.isNotEmpty &&
                priceController.text.isNotEmpty &&
                noteController.text.isNotEmpty) {
              final newItem = PriceListItem(
                name: nameController.text,
                price: double.parse(priceController.text),
                note: noteController.text,
              );
              if (price != null) {
                priceList = priceList.map((e) {
                  if (e == price) {
                    return newItem;
                  }
                  return e;
                }).toList();
              } else {
                priceList.add(newItem);
              }
              Navigator.pop(context);
            } else {
              showSnackBar(context, 'Vui lòng nhập đủ thông tin', Colors.red);
            }
          },
          child: Text(price != null ? 'Sửa' : 'Thêm'),
        ),
      ],
    );

    // Trả về AlertDialog
    return alertDialog;
  }

  Widget _buildSelectTypePrice(BuildContext context, PriceType? priceType) {
    ThemeData theme = Theme.of(context);
    num? priceBase = context.read<ServiceFormBloc>().state.service?.priceBase;
    String priceBaseInit = TextFormat.formatMoney(priceBase ?? 0);
    Widget listBuilder = SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: priceList.length,
        itemBuilder: (context, index) {
          PriceListItem price = priceList[index % priceList.length];
          return ListTile(
            shape: const Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(0),
            title: Text('${price.name}'),
            subtitle: Text('${TextFormat.formatMoney(price.price ?? 0)} đ'),
            trailing: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton(
                    color: Colors.blue,
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      _handleAddPrice(context, price: price);
                    },
                  ),
                ),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton(
                    color: Colors.red,
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () {
                      setState(() {
                        priceList.removeAt(index);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    Widget titleBuilder(String title) {
      return Row(
        children: [
          Text(
            title,
            style: theme.textTheme.headlineMedium!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          CustomCircleButton(
            icon: Icons.add,
            iconSize: 20,
            onPressed: () {
              setState(() {
                _handleAddPrice(context);
              });
            },
          ),
        ],
      );
    }

    switch (priceType) {
      case PriceType.fixed:
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: CustomTextFormField(
            margin: EdgeInsets.zero,
            initialValue: priceBaseInit,
            hintText: 'Giá',
            textInputType: TextInputType.number,
            onChanged: (vaule) {
              context.read<ServiceFormBloc>().add(
                  ServiceFormPriceBaseChanged(priceBase: double.parse(vaule)));
            },
            validator: (value) => Validators.validateEmpty(value),
          ),
        );
      case PriceType.hourly:
        return Column(
          children: [
            const SizedBox(height: 16),
            CustomTextFormField(
              initialValue: priceBaseInit,
              margin: EdgeInsets.zero,
              hintText: 'Giá 1 giờ',
              textInputType: TextInputType.number,
              onChanged: (vaule) {
                context.read<ServiceFormBloc>().add(
                      ServiceFormPriceBaseChanged(
                          priceBase: TextFormat.parseMoney(vaule)),
                    );
              },
              validator: (value) => Validators.validateEmpty(value),
              onFieldSubmitted: (p0) {},
            ),
            // titleBuilder('Bảng giá theo giờ'),
          ],
        );
      case PriceType.package:
        return Column(
          children: [
            titleBuilder('Bảng giá các gói dịch vụ'),
            listBuilder,
          ],
        );

      default:
        return Column(
          children: [
            titleBuilder('Bảng báo giá tham khảo'),
            listBuilder,
          ],
        );
    }
  }

  serviceFormStateBlocSelector<T>({
    required T Function(ServiceFormState) selector,
    required Widget Function(BuildContext, T) builder,
  }) =>
      BlocSelector<ServiceFormBloc, ServiceFormState, T>(
        selector: selector,
        builder: builder,
      );
}
