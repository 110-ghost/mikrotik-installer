# MikroTik CHR 7.20.7 Installer

اسکریپت نصب خودکار **MikroTik Cloud Hosted Router (CHR) 7.20.7** روی VPS های Ubuntu.

این اسکریپت برای سرورهایی طراحی شده که قرار است Ubuntu به صورت کامل پاک شده و MikroTik CHR مستقیماً روی دیسک سیستم نصب شود.

---

🚀 نصب سریع

برای نصب کافیست اسکریپت را روی VPS Ubuntu اجرا کنید:
```bash
bash <(curl -Ls https://raw.githubusercontent.com/110-ghost/mikrotik-installer/main/install.sh)
```
---

## 🚀 ویژگی ها

- نصب خودکار MikroTik CHR 7.20.7
- دانلود IPv4-only برای جلوگیری از مشکل IPv6
- تشخیص خودکار دیسک سیستم
- تشخیص خودکار کارت شبکه
- نمایش IP و Gateway سرور قبل از نصب
- ایجاد کاربر مدیریتی `ghost`
- فعال بودن SSH
- فعال بودن Winbox
- تغییر پورت SSH
- تغییر پورت Winbox
- غیرفعال کردن Telnet
- غیرفعال کردن FTP
- غیرفعال کردن WebFig HTTP
- غیرفعال کردن WebFig HTTPS
- غیرفعال کردن API
- غیرفعال کردن API-SSL
- غیرفعال کردن IPv6
- فعال بودن ICMP
- غیرفعال کردن MAC-based Management
- غیرفعال کردن MAC Winbox
- غیرفعال کردن Neighbor Discovery
- غیرفعال کردن Bandwidth Server
- غیرفعال کردن DNS Remote Requests
- تنظیم خودکار Router Identity
- فعال کردن Basic IPv4 Input Firewall
- آماده سازی تنظیمات اولیه RouterOS قبل از اولین Boot

---

## ⚙️ مشخصات پیش فرض

```text
RouterOS       : 7.20.7

Username       : ghost
Password       : ghost@ghost

Winbox         : TCP 2526
SSH            : TCP 2525

Telnet         : OFF
FTP            : OFF
WebFig HTTP    : OFF
WebFig HTTPS   : OFF
API            : OFF
API-SSL        : OFF

IPv4 ICMP      : ON
IPv6           : OFF

Firewall       : ON
```

💻 مدیریت MikroTik

بعد از نصب می‌توانید با Winbox به پورت زیر متصل شوید:

TCP 2526

یا از طریق SSH:

TCP 2525

اطلاعات ورود اولیه:

Username: ghost
Password: ghost@ghost

🔐 تنظیمات امنیتی

برای مدیریت اولیه فقط سرویس‌های زیر فعال هستند:

SSH      TCP 2525
Winbox   TCP 2526
ICMP     Enabled

سرویس‌های زیر غیرفعال می‌شوند:

Telnet
FTP
WebFig HTTP
WebFig HTTPS
API
API-SSL

همچنین موارد زیر غیرفعال می‌شوند:

MAC Server
MAC Winbox
Neighbor Discovery
Bandwidth Server
IPv6
🔥 Firewall

یک Firewall اولیه برای input chain ایجاد می‌شود.

موارد زیر اجازه دسترسی دارند:

Established / Related / Untracked
ICMP
SSH      TCP/2525
Winbox   TCP/2526

سایر Connection هایی که مستقیماً به خود RouterOS مقصد داشته باشند Drop می‌شوند.

Forwarding

برای اینکه بعداً بتوانید روی MikroTik تنظیمات دلخواه خود را انجام دهید، مانند:

NAT
Routing
VPN
WireGuard
IPsec
Port Forwarding
Site-to-Site

روی forward chain محدودیت پیش‌فرض اعمال نشده است.

🌐 DNS

DNS های اولیه:

1.1.1.1
9.9.9.9

Remote DNS Requests نیز غیرفعال است:

allow-remote-requests=no

بنابراین RouterOS به عنوان Public DNS Server استفاده نمی‌شود.


⚠️ هشدار مهم

این اسکریپت DESTRUCTIVE است.

اسکریپت Image مربوط به MikroTik CHR را مستقیماً روی دیسک سیستم می‌نویسد.

یعنی سیستم عامل فعلی Ubuntu و اطلاعات موجود روی دیسک انتخاب‌شده حذف خواهند شد.

قبل از اجرای اسکریپت مطمئن شوید که:

اطلاعات مهم روی سرور ندارید
از VPS موردنظر Backup گرفته‌اید
دیسک انتخاب‌شده همان دیسکی است که می‌خواهید پاک شود
⚠️ بعد از اجرای dd امکان بازیابی عادی Ubuntu وجود ندارد.


🤝 مشارکت

از هرگونه مشارکت، پیشنهاد، Bug Report و Pull Request استقبال می‌شود.

اگر مشکلی در نصب یا اجرای پروژه مشاهده کردید، لطفاً Issue ایجاد کنید و اطلاعات زیر را ارسال کنید:

VPS Provider
Ubuntu Version
VPS Disk Configuration
Error Message
Installation Output

⚠️ مسئولیت استفاده

قبل از اجرای اسکریپت، مطمئن شوید که اطلاعات مهمی روی VPS وجود ندارد.

استفاده از این اسکریپت به معنی قبول حذف سیستم عامل و اطلاعات موجود روی دیسک مقصد است.

همیشه قبل از نصب از اطلاعات مهم خود Backup بگیرید.

بعد از اتصال موفق حتما پورت ها و یوزرنیم و پسورد را تعغیر بدهید چون این مقادیر پیش فرض و عمومی و قابل کرک شدن هستن و حتما مسائل امینی مورد نیاز را برای میکروتیک بعد از نصب لحاظ کنید  
