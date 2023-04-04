class PaymentInitResModel {
  int? status;
  bool? error;
  String? message;
  PaymentInitData? data;

  PaymentInitResModel({this.status, this.error, this.message, this.data});

  PaymentInitResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? PaymentInitData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PaymentInitData {
  UserPaymentMethod? userPaymentMethod;

  Customer? customer;
  Key? key;
  PaymentIntent? paymentIntent;
  String? publishableKey;

  PaymentInitData(
      {this.customer,
      this.key,
      this.paymentIntent,
      this.publishableKey,
      this.userPaymentMethod});

  PaymentInitData.fromJson(Map<String, dynamic> json) {
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    key = json['key'] != null ? Key.fromJson(json['key']) : null;
    paymentIntent = json['paymentIntent'] != null
        ? PaymentIntent.fromJson(json['paymentIntent'])
        : null;
    publishableKey = json['publishableKey'];
    userPaymentMethod = json['userPaymentMethod'] != null
        ? UserPaymentMethod.fromJson(json['userPaymentMethod'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (key != null) {
      data['key'] = key!.toJson();
    }
    if (paymentIntent != null) {
      data['paymentIntent'] = paymentIntent!.toJson();
    }
    if (userPaymentMethod != null) {
      data['userPaymentMethod'] = userPaymentMethod!.toJson();
    }
    data['publishableKey'] = publishableKey;
    return data;
  }
}

class UserPaymentMethod {
  String? object;
  List<UserPaymentMethodData>? data;
  bool? hasMore;
  String? url;

  UserPaymentMethod({this.object, this.data, this.hasMore, this.url});

  UserPaymentMethod.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    if (json['data'] != null) {
      data = <UserPaymentMethodData>[];
      json['data'].forEach((v) {
        data!.add(UserPaymentMethodData.fromJson(v));
      });
    }
    hasMore = json['has_more'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['object'] = object;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['has_more'] = hasMore;
    data['url'] = url;
    return data;
  }
}

class UserPaymentMethodData {
  String? id;
  String? object;
  BillingDetails? billingDetails;
  Card? card;
  int? created;
  String? customer;
  bool? livemode;
  Metadata? metadata;
  String? type;

  UserPaymentMethodData(
      {this.id,
      this.object,
      this.billingDetails,
      this.card,
      this.created,
      this.customer,
      this.livemode,
      this.metadata,
      this.type});

  UserPaymentMethodData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    billingDetails = json['billing_details'] != null
        ? BillingDetails.fromJson(json['billing_details'])
        : null;
    card = json['card'] != null ? Card.fromJson(json['card']) : null;
    created = json['created'];
    customer = json['customer'];
    livemode = json['livemode'];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    if (billingDetails != null) {
      data['billing_details'] = billingDetails!.toJson();
    }
    if (card != null) {
      data['card'] = card!.toJson();
    }
    data['created'] = created;
    data['customer'] = customer;
    data['livemode'] = livemode;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['type'] = type;
    return data;
  }
}

class BillingDetails {
  Address? address;
  String? email;
  String? name;
  String? phone;

  BillingDetails({this.address, this.email, this.name, this.phone});

  BillingDetails.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}

class Address {
  String? city;
  String? country;
  String? line1;
  String? line2;
  String? postalCode;
  String? state;

  Address(
      {this.city,
      this.country,
      this.line1,
      this.line2,
      this.postalCode,
      this.state});

  Address.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
    line1 = json['line1'];
    line2 = json['line2'];
    postalCode = json['postal_code'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['country'] = country;
    data['line1'] = line1;
    data['line2'] = line2;
    data['postal_code'] = postalCode;
    data['state'] = state;
    return data;
  }
}

class Card {
  String? brand;
  Checks? checks;
  String? country;
  int? expMonth;
  int? expYear;
  String? fingerprint;
  String? funding;
  String? generatedFrom;
  String? last4;
  Networks? networks;
  ThreeDSecureUsage? threeDSecureUsage;
  String? wallet;

  Card(
      {this.brand,
      this.checks,
      this.country,
      this.expMonth,
      this.expYear,
      this.fingerprint,
      this.funding,
      this.generatedFrom,
      this.last4,
      this.networks,
      this.threeDSecureUsage,
      this.wallet});

  Card.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    checks = json['checks'] != null ? Checks.fromJson(json['checks']) : null;
    country = json['country'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    fingerprint = json['fingerprint'];
    funding = json['funding'];
    generatedFrom = json['generated_from'];
    last4 = json['last4'];
    networks =
        json['networks'] != null ? Networks.fromJson(json['networks']) : null;
    threeDSecureUsage = json['three_d_secure_usage'] != null
        ? ThreeDSecureUsage.fromJson(json['three_d_secure_usage'])
        : null;
    wallet = json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand'] = brand;
    if (checks != null) {
      data['checks'] = checks!.toJson();
    }
    data['country'] = country;
    data['exp_month'] = expMonth;
    data['exp_year'] = expYear;
    data['fingerprint'] = fingerprint;
    data['funding'] = funding;
    data['generated_from'] = generatedFrom;
    data['last4'] = last4;
    if (networks != null) {
      data['networks'] = networks!.toJson();
    }
    if (threeDSecureUsage != null) {
      data['three_d_secure_usage'] = threeDSecureUsage!.toJson();
    }
    data['wallet'] = wallet;
    return data;
  }
}

class Checks {
  String? addressLine1Check;
  String? addressPostalCodeCheck;
  String? cvcCheck;

  Checks({this.addressLine1Check, this.addressPostalCodeCheck, this.cvcCheck});

  Checks.fromJson(Map<String, dynamic> json) {
    addressLine1Check = json['address_line1_check'];
    addressPostalCodeCheck = json['address_postal_code_check'];
    cvcCheck = json['cvc_check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address_line1_check'] = addressLine1Check;
    data['address_postal_code_check'] = addressPostalCodeCheck;
    data['cvc_check'] = cvcCheck;
    return data;
  }
}

class Networks {
  List<String>? available;
  var preferred;

  Networks({this.available, this.preferred});

  Networks.fromJson(Map<String, dynamic> json) {
    available = json['available'].cast<String>();
    preferred = json['preferred'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['available'] = available;
    data['preferred'] = preferred;
    return data;
  }
}

class ThreeDSecureUsage {
  bool? supported;

  ThreeDSecureUsage({this.supported});

  ThreeDSecureUsage.fromJson(Map<String, dynamic> json) {
    supported = json['supported'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supported'] = supported;
    return data;
  }
}

class Customer {
  String? id;
  String? object;
  String? address;
  int? balance;
  int? created;
  String? currency;
  String? defaultSource;
  bool? delinquent;
  String? description;
  String? discount;
  String? email;
  String? invoicePrefix;
  InvoiceSettings? invoiceSettings;
  bool? livemode;
  Metadata? metadata;
  String? name;
  int? nextInvoiceSequence;
  String? phone;
  List<String>? preferredLocales;
  String? shipping;
  String? taxExempt;
  String? testClock;

  Customer(
      {this.id,
      this.object,
      this.address,
      this.balance,
      this.created,
      this.currency,
      this.defaultSource,
      this.delinquent,
      this.description,
      this.discount,
      this.email,
      this.invoicePrefix,
      this.invoiceSettings,
      this.livemode,
      this.metadata,
      this.name,
      this.nextInvoiceSequence,
      this.phone,
      this.preferredLocales,
      this.shipping,
      this.taxExempt,
      this.testClock});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    address = json['address'];
    balance = json['balance'];
    created = json['created'];
    currency = json['currency'];
    defaultSource = json['default_source'];
    delinquent = json['delinquent'];
    description = json['description'];
    discount = json['discount'];
    email = json['email'];
    invoicePrefix = json['invoice_prefix'];
    invoiceSettings = json['invoice_settings'] != null
        ? InvoiceSettings.fromJson(json['invoice_settings'])
        : null;
    livemode = json['livemode'];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    name = json['name'];
    nextInvoiceSequence = json['next_invoice_sequence'];
    phone = json['phone'];
    preferredLocales = json['preferred_locales'].cast<String>();
    shipping = json['shipping'];
    taxExempt = json['tax_exempt'];
    testClock = json['test_clock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    data['address'] = address;
    data['balance'] = balance;
    data['created'] = created;
    data['currency'] = currency;
    data['default_source'] = defaultSource;
    data['delinquent'] = delinquent;
    data['description'] = description;
    data['discount'] = discount;
    data['email'] = email;
    data['invoice_prefix'] = invoicePrefix;
    if (invoiceSettings != null) {
      data['invoice_settings'] = invoiceSettings!.toJson();
    }
    data['livemode'] = livemode;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['name'] = name;
    data['next_invoice_sequence'] = nextInvoiceSequence;
    data['phone'] = phone;
    data['preferred_locales'] = preferredLocales;
    data['shipping'] = shipping;
    data['tax_exempt'] = taxExempt;
    data['test_clock'] = testClock;
    return data;
  }
}

class InvoiceSettings {
  String? customFields;
  String? defaultPaymentMethod;
  String? footer;
  String? renderingOptions;

  InvoiceSettings(
      {this.customFields,
      this.defaultPaymentMethod,
      this.footer,
      this.renderingOptions});

  InvoiceSettings.fromJson(Map<String, dynamic> json) {
    customFields = json['custom_fields'];
    defaultPaymentMethod = json['default_payment_method'];
    footer = json['footer'];
    renderingOptions = json['rendering_options'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['custom_fields'] = customFields;
    data['default_payment_method'] = defaultPaymentMethod;
    data['footer'] = footer;
    data['rendering_options'] = renderingOptions;
    return data;
  }
}

class Metadata {
  Metadata();

  Metadata.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class Key {
  String? id;
  String? object;
  List<AssociatedObjects>? associatedObjects;
  int? created;
  int? expires;
  bool? livemode;
  String? secret;

  Key(
      {this.id,
      this.object,
      this.associatedObjects,
      this.created,
      this.expires,
      this.livemode,
      this.secret});

  Key.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    if (json['associated_objects'] != null) {
      associatedObjects = <AssociatedObjects>[];
      json['associated_objects'].forEach((v) {
        associatedObjects!.add(AssociatedObjects.fromJson(v));
      });
    }
    created = json['created'];
    expires = json['expires'];
    livemode = json['livemode'];
    secret = json['secret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    if (associatedObjects != null) {
      data['associated_objects'] =
          associatedObjects!.map((v) => v.toJson()).toList();
    }
    data['created'] = created;
    data['expires'] = expires;
    data['livemode'] = livemode;
    data['secret'] = secret;
    return data;
  }
}

class AssociatedObjects {
  String? id;
  String? type;

  AssociatedObjects({this.id, this.type});

  AssociatedObjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}

class PaymentIntent {
  String? id;
  String? object;
  int? amount;
  int? amountCapturable;
  AmountDetails? amountDetails;
  int? amountReceived;
  String? application;
  String? applicationFeeAmount;
  AutomaticPaymentMethods? automaticPaymentMethods;
  String? canceledAt;
  String? cancellationReason;
  String? captureMethod;
  Charges? charges;
  String? clientSecret;
  String? confirmationMethod;
  int? created;
  String? currency;
  String? customer;
  String? description;
  String? invoice;
  String? lastPaymentError;
  bool? livemode;
  Metadata? metadata;
  String? nextAction;
  String? onBehalfOf;
  String? paymentMethod;
  PaymentMethodOptions? paymentMethodOptions;
  List<String>? paymentMethodTypes;
  String? processing;
  String? receiptEmail;
  String? review;
  String? setupFutureUsage;
  String? shipping;
  String? source;
  String? statementDescriptor;
  String? status;
  String? transferData;
  String? transferGroup;

  PaymentIntent(
      {this.id,
      this.object,
      this.amount,
      this.amountCapturable,
      this.amountDetails,
      this.amountReceived,
      this.application,
      this.applicationFeeAmount,
      this.automaticPaymentMethods,
      this.canceledAt,
      this.cancellationReason,
      this.captureMethod,
      this.charges,
      this.clientSecret,
      this.confirmationMethod,
      this.created,
      this.currency,
      this.customer,
      this.description,
      this.invoice,
      this.lastPaymentError,
      this.livemode,
      this.metadata,
      this.nextAction,
      this.onBehalfOf,
      this.paymentMethod,
      this.paymentMethodOptions,
      this.paymentMethodTypes,
      this.processing,
      this.receiptEmail,
      this.review,
      this.setupFutureUsage,
      this.shipping,
      this.source,
      this.statementDescriptor,
      this.status,
      this.transferData,
      this.transferGroup});

  PaymentIntent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    amount = json['amount'];
    amountCapturable = json['amount_capturable'];
    amountDetails = json['amount_details'] != null
        ? AmountDetails.fromJson(json['amount_details'])
        : null;
    amountReceived = json['amount_received'];
    application = json['application'];
    applicationFeeAmount = json['application_fee_amount'];
    automaticPaymentMethods = json['automatic_payment_methods'] != null
        ? AutomaticPaymentMethods.fromJson(json['automatic_payment_methods'])
        : null;
    canceledAt = json['canceled_at'];
    cancellationReason = json['cancellation_reason'];
    captureMethod = json['capture_method'];
    charges =
        json['charges'] != null ? Charges.fromJson(json['charges']) : null;
    clientSecret = json['client_secret'];
    confirmationMethod = json['confirmation_method'];
    created = json['created'];
    currency = json['currency'];
    customer = json['customer'];
    description = json['description'];
    invoice = json['invoice'];
    lastPaymentError = json['last_payment_error'];
    livemode = json['livemode'];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    nextAction = json['next_action'];
    onBehalfOf = json['on_behalf_of'];
    paymentMethod = json['payment_method'];
    paymentMethodOptions = json['payment_method_options'] != null
        ? PaymentMethodOptions.fromJson(json['payment_method_options'])
        : null;
    paymentMethodTypes = json['payment_method_types'].cast<String>();
    processing = json['processing'];
    receiptEmail = json['receipt_email'];
    review = json['review'];
    setupFutureUsage = json['setup_future_usage'];
    shipping = json['shipping'];
    source = json['source'];
    statementDescriptor = json['statement_descriptor'];
    status = json['status'];
    transferData = json['transfer_data'];
    transferGroup = json['transfer_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    data['amount'] = amount;
    data['amount_capturable'] = amountCapturable;
    if (amountDetails != null) {
      data['amount_details'] = amountDetails!.toJson();
    }
    data['amount_received'] = amountReceived;
    data['application'] = application;
    data['application_fee_amount'] = applicationFeeAmount;
    if (automaticPaymentMethods != null) {
      data['automatic_payment_methods'] = automaticPaymentMethods!.toJson();
    }
    data['canceled_at'] = canceledAt;
    data['cancellation_reason'] = cancellationReason;
    data['capture_method'] = captureMethod;
    if (charges != null) {
      data['charges'] = charges!.toJson();
    }
    data['client_secret'] = clientSecret;
    data['confirmation_method'] = confirmationMethod;
    data['created'] = created;
    data['currency'] = currency;
    data['customer'] = customer;
    data['description'] = description;
    data['invoice'] = invoice;
    data['last_payment_error'] = lastPaymentError;
    data['livemode'] = livemode;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['next_action'] = nextAction;
    data['on_behalf_of'] = onBehalfOf;
    data['payment_method'] = paymentMethod;
    if (paymentMethodOptions != null) {
      data['payment_method_options'] = paymentMethodOptions!.toJson();
    }
    data['payment_method_types'] = paymentMethodTypes;
    data['processing'] = processing;
    data['receipt_email'] = receiptEmail;
    data['review'] = review;
    data['setup_future_usage'] = setupFutureUsage;
    data['shipping'] = shipping;
    data['source'] = source;
    data['statement_descriptor'] = statementDescriptor;
    data['status'] = status;
    data['transfer_data'] = transferData;
    data['transfer_group'] = transferGroup;
    return data;
  }
}

class AmountDetails {
  Metadata? tip;

  AmountDetails({this.tip});

  AmountDetails.fromJson(Map<String, dynamic> json) {
    tip = json['tip'] != null ? Metadata.fromJson(json['tip']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tip != null) {
      data['tip'] = tip!.toJson();
    }
    return data;
  }
}

class AutomaticPaymentMethods {
  bool? enabled;

  AutomaticPaymentMethods({this.enabled});

  AutomaticPaymentMethods.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enabled'] = enabled;
    return data;
  }
}

class Charges {
  String? object;
  List<String>? data;
  bool? hasMore;
  int? totalCount;
  String? url;

  Charges({this.object, this.data, this.hasMore, this.totalCount, this.url});

  Charges.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    data = json['data'].cast<String>();
    hasMore = json['has_more'];
    totalCount = json['total_count'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['object'] = object;
    data['data'] = this.data;
    data['has_more'] = hasMore;
    data['total_count'] = totalCount;
    data['url'] = url;
    return data;
  }
}

class PaymentMethodOptions {
  Card? card;

  PaymentMethodOptions({this.card});

  PaymentMethodOptions.fromJson(Map<String, dynamic> json) {
    card = json['card'] != null ? Card.fromJson(json['card']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (card != null) {
      data['card'] = card!.toJson();
    }
    return data;
  }
}
