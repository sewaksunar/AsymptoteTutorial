import subprocess
from pathlib import Path


def find_browser() -> tuple[str, str] | None:
    candidates = [
        ("Microsoft Edge", r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"),
        ("Microsoft Edge", r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"),
        ("Chrome", r"C:\Program Files\Google\Chrome\Application\chrome.exe"),
        ("Chrome", r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"),
        ("Firefox", r"C:\Program Files\Mozilla Firefox\firefox.exe"),
    ]

    for name, executable in candidates:
        if Path(executable).exists():
            return name, executable

    return None


base_dir = Path(__file__).resolve().parent
html_file = base_dir / r"3D_Figures\test_3d.html.html"
pdf_file = base_dir / r"3D_Figures\test_with_graphics.pdf"

browser = find_browser()
if browser is None:
    raise SystemExit(
        "No supported browser was found. Install Microsoft Edge, Chrome, or Firefox, "
        "then rerun this script."
    )

browser_name, browser_executable = browser

try:
    subprocess.run(
        [
            browser_executable,
            "--headless",
            "--disable-gpu",
            f"--print-to-pdf={pdf_file}",
            str(html_file),
        ],
        check=True,
        timeout=60,
    )
    print(f"PDF created: {pdf_file}")
except Exception as exc:
    raise SystemExit(f"{browser_name} PDF export failed: {exc}")
