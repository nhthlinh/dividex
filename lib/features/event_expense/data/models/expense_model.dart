import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';

enum ExpenseStatus { done, notYet }

class ExpenseModel {
  final String? id;
  final DateTime? updatedAt;
  final String? name;
  final String? event;
  final CurrencyEnum? currency;
  final double? totalAmount;
  final String? note;
  final String? paidBy;
  final UserModel? paidByUser;
  final SplitTypeEnum? splitType;
  final DateTime? expenseDate;
  final DateTime? remindAt;
  final String? category;
  final List<UserDebt>? userDebts;
  final List<UserDeptInfo>? userDebtInfos;
  final List<ImageModel>? images;
  final ExpenseStatus? status;

  ExpenseModel({
    this.id,
    this.updatedAt,
    this.name,
    this.event,
    this.currency,
    this.totalAmount,
    this.note,
    this.paidBy,
    this.paidByUser,
    this.splitType,
    this.expenseDate,
    this.remindAt,
    this.category,
    this.userDebts,
    this.images,
    this.userDebtInfos,
    this.status,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
    id: json['uid'] as String?,
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    name: json['name'] as String?,
    currency: json['currency'] == null
        ? null
        : $enumDecodeNullable(
            $CurrencyEnumEnumMap,
            json['currency'].toString().toLowerCase(),
          ),
    totalAmount: (json['total_amount'] as num? ?? json['amount'] as num?)?.toDouble(),
    note: json['note'] as String?,
    category: json['category'] as String?,
    expenseDate: json['expense_date'] == null
        ? null
        : DateTime.parse(json['expense_date'] as String),
    remindAt: json['end_date'] == null
        ? null
        : DateTime.parse(json['end_date'] as String),
    paidByUser: json['paid_by'] == null
        ? null
        : UserModel.fromJson(json['paid_by'] as Map<String, dynamic>),
    splitType: $enumDecodeNullable(_$SplitTypeEnumEnumMap, json['splitType']),
    event: json['event'] as String?,
    images: (json['receipt_url'] as List<dynamic>?)
        ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    userDebts: (json['list_expense_member'] as List<dynamic>?)
        ?.map((e) => UserDebt.fromJson(e as Map<String, dynamic>))
        .toList(),
    userDebtInfos: (json['list_user'] as List<dynamic>?)
        ?.map((e) => UserDeptInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  factory ExpenseModel.fromListExpenseInGroupJson(Map<String, dynamic> json) {
    final eventName = json['event'] as String?;
    final expenseList = json['expense'] as List<dynamic>? ?? [];

    return ExpenseModel(
      event: eventName,
      id: expenseList.isNotEmpty ? expenseList.first['uid'] as String? : null,
      name: expenseList.isNotEmpty
          ? expenseList.first['name'] as String?
          : null,
      currency: expenseList.isNotEmpty
          ? $enumDecodeNullable(
              $CurrencyEnumEnumMap,
              expenseList.first['currency'].toString().toLowerCase(),
            )
          : null,
      totalAmount: expenseList.isNotEmpty
          ? (expenseList.first['amount'] != null
                ? (expenseList.first['amount'] as num).toDouble()
                : null)
          : null,
      status: expenseList.isNotEmpty
          ? $enumDecodeNullable(
              _$ExpenseStatusEnumMap,
              expenseList.first['status'],
            )
          : null,
    );
  }

  Map<String, dynamic> $ExpenseModelToJson(
    ExpenseModel instance,
  ) => <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'event': instance.event,
    'currency': $CurrencyEnumEnumMap[instance.currency],
    'totalAmount': instance.totalAmount,
    'description': instance.note,
    'paidBy': instance.paidBy,
    'splitType': _$SplitTypeEnumEnumMap[instance.splitType],
    'expenseDate': instance.expenseDate?.toIso8601String(),
    'remindAt': instance.remindAt?.toIso8601String(),
    'category': instance.category,
    'list_expense_member': instance.userDebts?.map((e) => e.toJson()).toList(),
  };
}

const _$ExpenseStatusEnumMap = {
  ExpenseStatus.done: 'DONE',
  ExpenseStatus.notYet: 'NOTYET',
};

const _$SplitTypeEnumEnumMap = {
  SplitTypeEnum.equal: 'equal',
  SplitTypeEnum.percentage: 'percentage',
  SplitTypeEnum.custom: 'custom',
};

const $CurrencyEnumEnumMap = {
  CurrencyEnum.aed: 'aed',
  CurrencyEnum.afn: 'afn',
  CurrencyEnum.all: 'all',
  CurrencyEnum.amd: 'amd',
  CurrencyEnum.ang: 'ang',
  CurrencyEnum.aoa: 'aoa',
  CurrencyEnum.ars: 'ars',
  CurrencyEnum.aud: 'aud',
  CurrencyEnum.awg: 'awg',
  CurrencyEnum.azn: 'azn',
  CurrencyEnum.bam: 'bam',
  CurrencyEnum.bbd: 'bbd',
  CurrencyEnum.bdt: 'bdt',
  CurrencyEnum.bgn: 'bgn',
  CurrencyEnum.bhd: 'bhd',
  CurrencyEnum.bif: 'bif',
  CurrencyEnum.bmd: 'bmd',
  CurrencyEnum.bnd: 'bnd',
  CurrencyEnum.bob: 'bob',
  CurrencyEnum.brl: 'brl',
  CurrencyEnum.bsd: 'bsd',
  CurrencyEnum.btn: 'btn',
  CurrencyEnum.bwp: 'bwp',
  CurrencyEnum.byn: 'byn',
  CurrencyEnum.bzd: 'bzd',
  CurrencyEnum.cad: 'cad',
  CurrencyEnum.cdf: 'cdf',
  CurrencyEnum.chf: 'chf',
  CurrencyEnum.clp: 'clp',
  CurrencyEnum.cny: 'cny',
  CurrencyEnum.cop: 'cop',
  CurrencyEnum.crc: 'crc',
  CurrencyEnum.cup: 'cup',
  CurrencyEnum.cve: 'cve',
  CurrencyEnum.czk: 'czk',
  CurrencyEnum.djf: 'djf',
  CurrencyEnum.dkk: 'dkk',
  CurrencyEnum.dop: 'dop',
  CurrencyEnum.dzd: 'dzd',
  CurrencyEnum.egp: 'egp',
  CurrencyEnum.ern: 'ern',
  CurrencyEnum.etb: 'etb',
  CurrencyEnum.eur: 'eur',
  CurrencyEnum.fjd: 'fjd',
  CurrencyEnum.fkp: 'fkp',
  CurrencyEnum.fok: 'fok',
  CurrencyEnum.gbp: 'gbp',
  CurrencyEnum.gel: 'gel',
  CurrencyEnum.ggp: 'ggp',
  CurrencyEnum.ghs: 'ghs',
  CurrencyEnum.gip: 'gip',
  CurrencyEnum.gmd: 'gmd',
  CurrencyEnum.gnf: 'gnf',
  CurrencyEnum.gtq: 'gtq',
  CurrencyEnum.gyd: 'gyd',
  CurrencyEnum.hkd: 'hkd',
  CurrencyEnum.hnl: 'hnl',
  CurrencyEnum.hrk: 'hrk',
  CurrencyEnum.htg: 'htg',
  CurrencyEnum.huf: 'huf',
  CurrencyEnum.idr: 'idr',
  CurrencyEnum.ils: 'ils',
  CurrencyEnum.imp: 'imp',
  CurrencyEnum.inr: 'inr',
  CurrencyEnum.iqd: 'iqd',
  CurrencyEnum.irr: 'irr',
  CurrencyEnum.isk: 'isk',
  CurrencyEnum.jep: 'jep',
  CurrencyEnum.jmd: 'jmd',
  CurrencyEnum.jod: 'jod',
  CurrencyEnum.jpy: 'jpy',
  CurrencyEnum.kes: 'kes',
  CurrencyEnum.kgs: 'kgs',
  CurrencyEnum.khr: 'khr',
  CurrencyEnum.kid: 'kid',
  CurrencyEnum.kmf: 'kmf',
  CurrencyEnum.krw: 'krw',
  CurrencyEnum.kwd: 'kwd',
  CurrencyEnum.kyd: 'kyd',
  CurrencyEnum.kzt: 'kzt',
  CurrencyEnum.lak: 'lak',
  CurrencyEnum.lbp: 'lbp',
  CurrencyEnum.lkr: 'lkr',
  CurrencyEnum.lrd: 'lrd',
  CurrencyEnum.lsl: 'lsl',
  CurrencyEnum.lyd: 'lyd',
  CurrencyEnum.mad: 'mad',
  CurrencyEnum.mdl: 'mdl',
  CurrencyEnum.mga: 'mga',
  CurrencyEnum.mkd: 'mkd',
  CurrencyEnum.mmk: 'mmk',
  CurrencyEnum.mnt: 'mnt',
  CurrencyEnum.mop: 'mop',
  CurrencyEnum.mru: 'mru',
  CurrencyEnum.mur: 'mur',
  CurrencyEnum.mvr: 'mvr',
  CurrencyEnum.mwk: 'mwk',
  CurrencyEnum.mxn: 'mxn',
  CurrencyEnum.myr: 'myr',
  CurrencyEnum.mzn: 'mzn',
  CurrencyEnum.nad: 'nad',
  CurrencyEnum.ngn: 'ngn',
  CurrencyEnum.nio: 'nio',
  CurrencyEnum.nok: 'nok',
  CurrencyEnum.npr: 'npr',
  CurrencyEnum.nzd: 'nzd',
  CurrencyEnum.omr: 'omr',
  CurrencyEnum.pab: 'pab',
  CurrencyEnum.pen: 'pen',
  CurrencyEnum.pgk: 'pgk',
  CurrencyEnum.php: 'php',
  CurrencyEnum.pkr: 'pkr',
  CurrencyEnum.pln: 'pln',
  CurrencyEnum.pyg: 'pyg',
  CurrencyEnum.qar: 'qar',
  CurrencyEnum.ron: 'ron',
  CurrencyEnum.rsd: 'rsd',
  CurrencyEnum.rub: 'rub',
  CurrencyEnum.rwf: 'rwf',
  CurrencyEnum.sar: 'sar',
  CurrencyEnum.sbd: 'sbd',
  CurrencyEnum.scr: 'scr',
  CurrencyEnum.sdg: 'sdg',
  CurrencyEnum.sek: 'sek',
  CurrencyEnum.sgd: 'sgd',
  CurrencyEnum.shp: 'shp',
  CurrencyEnum.sle: 'sle',
  CurrencyEnum.sos: 'sos',
  CurrencyEnum.srd: 'srd',
  CurrencyEnum.ssp: 'ssp',
  CurrencyEnum.stn: 'stn',
  CurrencyEnum.syp: 'syp',
  CurrencyEnum.szl: 'szl',
  CurrencyEnum.thb: 'thb',
  CurrencyEnum.tjs: 'tjs',
  CurrencyEnum.tmt: 'tmt',
  CurrencyEnum.tnd: 'tnd',
  CurrencyEnum.top: 'top',
  CurrencyEnum.try_: 'try_',
  CurrencyEnum.ttd: 'ttd',
  CurrencyEnum.tvd: 'tvd',
  CurrencyEnum.twd: 'twd',
  CurrencyEnum.tzs: 'tzs',
  CurrencyEnum.uah: 'uah',
  CurrencyEnum.ugx: 'ugx',
  CurrencyEnum.usd: 'usd',
  CurrencyEnum.uyu: 'uyu',
  CurrencyEnum.uzs: 'uzs',
  CurrencyEnum.ves: 'ves',
  CurrencyEnum.vnd: 'vnd',
  CurrencyEnum.vuv: 'vuv',
  CurrencyEnum.wst: 'wst',
  CurrencyEnum.xaf: 'xaf',
  CurrencyEnum.xcd: 'xcd',
  CurrencyEnum.xdr: 'xdr',
  CurrencyEnum.xof: 'xof',
  CurrencyEnum.xpf: 'xpf',
  CurrencyEnum.yer: 'yer',
  CurrencyEnum.zar: 'zar',
  CurrencyEnum.zmw: 'zmw',
  CurrencyEnum.zwl: 'zwl',
};
