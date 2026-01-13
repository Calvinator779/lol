import os
import sys
import shutil
import subprocess

# --- БЛОК 1: АВТОМАТИЧНЕ ВСТАНОВЛЕННЯ ---
def install(package):
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", package])
    except:
        pass

# Перевірка та імпорт бібліотек
try:
    import markdown
    import pdfkit
    import pymdownx
except ImportError:
    print("[INSTALL] Встановлюю необхідні бібліотеки...")
    install("markdown")
    install("pdfkit")
    install("pymdown-extensions")
    import markdown
    import pdfkit

# --- БЛОК 2: СТИЛІ (CSS) ---

# Тут ми додаємо "white-space: pre-wrap" для блоку pre
CSS = """
<style>
    body { 
        font-family: "Times New Roman", Times, serif; 
        font-size: 12pt; 
        line-height: 1.5;
        padding: 0;
    }

    /* --- ТИТУЛКА І ЗАГОЛОВКИ --- */
    h1, h2, h3, h4 { 
        text-align: center; 
        font-weight: bold;
        color: #000;
        page-break-after: avoid;
    }
    h2 { font-size: 16pt; text-transform: uppercase; margin-bottom: 15px; }
    h3 { font-size: 14pt; margin-bottom: 10px; }

    /* --- КОД (ВИПРАВЛЕНО) --- */
    pre { 
        background-color: #f5f5f5; 
        padding: 10px; 
        border: 1px solid #ccc; 
        border-radius: 4px;
        
        /* ЦІ РЯДКИ РОБЛЯТЬ МАГІЮ ПЕРЕНОСУ: */
        white-space: pre-wrap;       /* Зберігає пробіли, але переносить текст */
        word-wrap: break-word;       /* Ламає довгі слова, якщо треба */
        overflow-wrap: break-word;   
        
        font-size: 10pt;             /* Трохи менший шрифт для коду */
        page-break-inside: avoid;    /* Намагатись не розривати код між сторінками */
    }
    
    code { 
        font-family: "Courier New", Courier, monospace;
        color: #d63384;              /* Колір як у звичних редакторах */
    }
    
    /* pre code перебиває налаштування вище для блоків */
    pre code {
        color: #333;                 /* Темний текст для блоків коду */
    }

    /* --- ТАБЛИЦІ --- */
    table { width: 100%; border-collapse: collapse; margin: 15px 0; }
    th, td { border: 1px solid black; padding: 5px; text-align: left; vertical-align: top; }
    th { background-color: #eee; font-weight: bold; text-align: center; }

    /* --- ЗОБРАЖЕННЯ --- */
    img { max-width: 100%; height: auto; display: block; margin: 10px auto; }
    
    /* --- ВІДСТУПИ ПАРАГРАФІВ --- */
    p { margin-bottom: 10px; text-align: justify; }
</style>
"""

# --- БЛОК 3: ФОРМУЛИ (MathJax) ---
MATHJAX = """
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    tex2jax: {
      inlineMath: [['$','$'], ['\\\\(','\\\\)']],
      displayMath: [['$$','$$'], ['\\\\[','\\\\]']],
      processEscapes: true
    },
    "HTML-CSS": { 
        availableFonts: ["TeX"], 
        linebreaks: { automatic: true } 
    },
    SVG: { linebreaks: { automatic: true } }
  });
</script>
<script type="text/javascript" async
  src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-MML-AM_CHTML">
</script>
"""

# --- БЛОК 4: ЛОГІКА ---

def check_wkhtmltopdf():
    if not shutil.which("wkhtmltopdf"):
        print("[ERROR] wkhtmltopdf не знайдено!")
        if shutil.which("apt-get"):
            print("Спроба встановити через sudo...")
            try:
                subprocess.check_call("sudo apt-get update && sudo apt-get install -y wkhtmltopdf", shell=True)
            except:
                print("Встановіть вручну: sudo apt install wkhtmltopdf")
                sys.exit(1)
        else:
            print("Будь ласка, встановіть wkhtmltopdf вручну.")
            sys.exit(1)

def convert_md_to_pdf(md_path):
    pdf_path = os.path.splitext(md_path)[0] + ".pdf"
    html_temp_path = os.path.splitext(md_path)[0] + ".temp.html"

    # Перевірка актуальності
    if os.path.exists(pdf_path):
        if os.path.getmtime(md_path) <= os.path.getmtime(pdf_path):
            return

    print(f"[PROCESS] {os.path.basename(md_path)} ...")

    try:
        with open(md_path, 'r', encoding='utf-8') as f:
            text = f.read()

        # Конвертація MD -> HTML
        html_content = markdown.markdown(text, extensions=[
            'extra',                # Таблиці, форматування
            'pymdownx.arithmatex',  # Формули $$
            'pymdownx.highlight',   # Підсвітка коду
            'pymdownx.superfences', # Дозволяє вкладені блоки
            'pymdownx.details'      # Спойлери (якщо є)
        ], extension_configs={
            'pymdownx.arithmatex': {'generic': True}
        })

        # Збирання повної сторінки
        full_html = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            {CSS}
            {MATHJAX}
        </head>
        <body>
            {html_content}
        </body>
        </html>
        """

        # Запис тимчасового HTML (для налагодження можна залишити)
        with open(html_temp_path, "w", encoding="utf-8") as f:
            f.write(full_html)

        # Налаштування PDF
        options = {
            'encoding': "UTF-8",
            'enable-local-file-access': None,
            'javascript-delay': '5000', # Час для рендеру формул
            'page-size': 'A4',
            'margin-top': '20mm',
            'margin-right': '15mm',
            'margin-bottom': '20mm',
            'margin-left': '25mm',
            'no-stop-slow-scripts': None
        }

        pdfkit.from_file(html_temp_path, pdf_path, options=options)
        print(f"[OK] Створено: {pdf_path}")
        
        # Видаляємо сміття
        if os.path.exists(html_temp_path):
            os.remove(html_temp_path)

    except Exception as e:
        print(f"[FAIL] Помилка з файлом {md_path}: {e}")

def main():
    check_wkhtmltopdf()
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    print(f"--- Сканую папку: {current_dir} ---")
    
    count = 0
    for root, dirs, files in os.walk(current_dir):
        for file in files:
            if file.lower().endswith(".md"):
                convert_md_to_pdf(os.path.join(root, file))
                count += 1
                
    print("--- Роботу завершено ---")

if __name__ == "__main__":
    main()