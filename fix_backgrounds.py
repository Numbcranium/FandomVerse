import os, re
from glob import glob

files = glob('lib/**/*.dart', recursive=True)

dark_colors = [
    '0xFF1A1D2D', '0xFF0F111A', '0xFF030927', '0xFF0B0A25', '0xFF17163D', 
    '0xFF101052', '0xFF111B55', '0xFF171B65', '0xFF1C3A79', '0xFF07143D',
    '0xFF18245C', '0xFF142D68', '0xFF1D4389'
]

count = 0
for f in files:
    if 'app_theme.dart' in f or 'app_colors.dart' in f or 'app_text_styles.dart' in f:
        continue

    with open(f, 'r', encoding='utf-8') as file:
        content = file.read()
    
    orig = content
    
    # Safely replace Scaffold and Container backgrounds
    for hex_code in dark_colors:
        content = re.sub(r'backgroundColor:\s*(const\s*)?Color\(' + hex_code + r'\)', 'backgroundColor: Theme.of(context).scaffoldBackgroundColor', content)
        content = re.sub(r'color:\s*(const\s*)?Color\(' + hex_code + r'\)', 'color: Theme.of(context).cardColor', content)
        content = re.sub(r'dropdownColor:\s*(const\s*)?Color\(' + hex_code + r'\)', 'dropdownColor: Theme.of(context).cardColor', content)
        content = re.sub(r'fillColor:\s*(const\s*)?Color\(' + hex_code + r'\)', 'fillColor: Theme.of(context).cardColor', content)
    
    content = re.sub(r'backgroundColor:\s*AppColors\.backgroundDark', 'backgroundColor: Theme.of(context).scaffoldBackgroundColor', content)
    content = re.sub(r'color:\s*AppColors\.surfaceDarkElevated', 'color: Theme.of(context).cardColor', content)
    content = re.sub(r'color:\s*AppColors\.surfaceDark', 'color: Theme.of(context).cardColor', content)
    content = re.sub(r'color:\s*AppColors\.borderDark', 'color: Theme.of(context).dividerColor', content)
    
    # Colors.black for backgrounds
    content = re.sub(r'backgroundColor:\s*Colors\.black\b', 'backgroundColor: Theme.of(context).scaffoldBackgroundColor', content)
    content = re.sub(r'backgroundColor:\s*Colors\.black45\b', 'backgroundColor: Theme.of(context).scaffoldBackgroundColor', content)
    content = re.sub(r'backgroundColor:\s*Colors\.black54\b', 'backgroundColor: Theme.of(context).scaffoldBackgroundColor', content)
    
    # Only remove const if we actually made a change, to avoid breaking unrelated consts
    if content != orig:
        content = re.sub(r'const\s+(Scaffold|Container|BoxDecoration|Row|Column|Padding|SizedBox|Text|Icon|Center|Expanded|Positioned)', r'\1', content)
        
        with open(f, 'w', encoding='utf-8') as file:
            file.write(content)
        count += 1

print(f'Modified {count} files safely.')
