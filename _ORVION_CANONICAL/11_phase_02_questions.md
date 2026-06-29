# Phase 02 Questions

Version: 0.1
Status: Draft
Canonical: Yes

---

# Purpose

These questions complete the first executable specification before database table design.

The goal is to remove ambiguity from statuses, permissions, accounting behavior, and booking workflows.

---

# A. Lead Statuses

1. ما الحالات الرسمية للـ lead من أول دخوله حتى غلقه؟
2. هل يوجد حالات مثل: new, assigned, contacted, qualified, quotation_sent, converted, lost, duplicate؟
3. متى يتحول lead إلى customer؟
4. متى يتحول lead إلى booking؟
5. هل lead المكرر يتم دمجه أم أرشفته أم ربطه بالعميل الموجود؟

---

# B. Booking Statuses

1. ما الحالات الرسمية للـ booking؟
2. ما الحالات الرسمية لكل booking item مثل ticket, hotel, visa؟
3. هل يمكن إصدار خدمة قبل تحصيل كامل المبلغ؟
4. هل كل booking يحتاج موافقة مالية قبل التنفيذ؟
5. هل cancellation و refund جزء من MVP؟

---

# C. Finance Details

1. هل تريد شجرة حسابات جاهزة داخل النظام أم يتم إنشاؤها لكل شركة؟
2. هل يجب منع إصدار الخدمة إذا لم تتم موافقة الحسابات على التحويل؟

3. هل يمكن للموظف إدخال سعر البيع والتكلفة أم التكلفة للحسابات/الإدارة فقط؟
4. من يحدد سعر الصرف اليدوي؟
5. هل سعر الصرف يثبت على booking item أم يمكن تعديله لاحقا بإذن؟

---

# D. Permissions

1. ما الأدوار الأساسية داخل الشركة؟
2. هل يوجد role ثابت مثل owner, branch_manager, department_manager, sales, operations, finance, admin؟
3. هل مدير الشركة يرى كل الفروع؟
4. هل مدير الفرع يرى كل أقسام فرعه؟
5. هل موظف المبيعات يرى فقط leads الخاصة به أم queue القسم كله؟

---

# E. Documents

1. ما أول قائمة أنواع ملفات يجب دعمها في MVP؟
2. هل ملفات الجوازات تحفظ على مستوى customer أم passenger أم الاثنين؟
3. هل التذاكر والتأشيرات تحفظ على مستوى booking item؟
4. هل الملفات يجب أن يكون لها تاريخ انتهاء؟
5. هل هناك ملفات ممنوع تحميلها إلا بصيغة PDF أو صورة فقط؟

---

# F. SaaS Plans

1. كم عدد المستخدمين والفروع المقترح لكل باقة؟
2. هل باقة CRM تسمح برفع ملفات؟
3. هل باقة CRM تسمح بإنشاء booking أم leads/customers فقط؟
4. هل الحسابات موجودة فقط في الباقة التكاملية والشاملة؟
5. هل التحليلات المتقدمة فقط في الباقة الشاملة؟

---

# G. Integrations Priority

1. ما أول integration يجب تنفيذه بعد الأساسيات: WhatsApp, Google Ads, GTM, n8n, أم غيره؟
2. هل WhatsApp يجب أن يكون استقبال رسائل فقط أولا أم إرسال واستقبال؟
3. هل Google Ads مطلوب منه source attribution فقط أم call tracking كامل؟
4. هل n8n سيكون للتنبيهات فقط في البداية أم workflows أوسع؟

