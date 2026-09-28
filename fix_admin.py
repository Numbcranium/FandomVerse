import re
f = "lib/features/admin/presentation/screens/admin_dashboard_screen.dart"
with open(f, "r", encoding="utf-8") as file: c = file.read()
# Find all Text(xxx, style...) and replace with Text(xxx.toString(), style...)
c = re.sub(r"Text\((name|role|title|value|status),", r"Text(\1.toString(),", c)
c = c.replace("Text(d['email'] ?? '',", "Text((d['email'] ?? '').toString(),")
with open(f, "w", encoding="utf-8") as file: file.write(c)
