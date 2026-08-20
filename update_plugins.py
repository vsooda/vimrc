import argparse
import os
import shutil
import subprocess
import tempfile
import urllib.request
import zipfile
from io import BytesIO
from os import path

# --- Globals ----------------------------------------------
PLUGINS = """
auto-pairs https://github.com/jiangmiao/auto-pairs
ale https://github.com/dense-analysis/ale
vim-yankstack https://github.com/maxbrunsfeld/vim-yankstack
ctrlp.vim https://github.com/ctrlpvim/ctrlp.vim
nerdtree https://github.com/preservim/nerdtree
tlib https://github.com/tomtom/tlib_vim
vim-addon-mw-utils https://github.com/MarcWeber/vim-addon-mw-utils
vim-indent-object https://github.com/michaeljsmith/vim-indent-object
vim-snipmate https://github.com/garbas/vim-snipmate
vim-snippets https://github.com/honza/vim-snippets
vim-surround https://github.com/tpope/vim-surround
vim-expand-region https://github.com/terryma/vim-expand-region
vim-visual-multi https://github.com/mg979/vim-visual-multi
vim-fugitive https://github.com/tpope/vim-fugitive
vim-rhubarb https://github.com/tpope/vim-rhubarb
goyo.vim https://github.com/junegunn/goyo.vim
vim-repeat https://github.com/tpope/vim-repeat
vim-commentary https://github.com/tpope/vim-commentary
vim-gitgutter https://github.com/airblade/vim-gitgutter
lightline.vim https://github.com/itchyny/lightline.vim
lightline-ale https://github.com/maximbaz/lightline-ale
vim-abolish https://github.com/tpope/vim-abolish
vim-markdown https://github.com/plasticboy/vim-markdown
editorconfig-vim https://github.com/editorconfig/editorconfig-vim
copilot.vim https://github.com/github/copilot.vim
vim-molokai https://github.com/tomasr/molokai
vim-lastplace https://github.com/farmergreg/vim-lastplace
vim-grepper https://github.com/mhinz/vim-grepper
vim-sleuth https://github.com/tpope/vim-sleuth
vim-unimpaired https://github.com/tpope/vim-unimpaired
vim-test https://github.com/vim-test/vim-test
""".strip()

GITHUB_ZIP = "%s/archive/HEAD.zip"

SOURCE_DIR = path.join(path.dirname(__file__), "sources_non_forked")
PLUGIN_URLS = dict(line.split(maxsplit=1) for line in PLUGINS.splitlines())


def download_extract_replace(plugin_name, zip_path, temp_dir, source_dir):
    """Download a complete archive before replacing the installed plugin."""
    with urllib.request.urlopen(zip_path, timeout=60) as req:
        zip_f = zipfile.ZipFile(BytesIO(req.read()))
        archive_root = zip_f.namelist()[0].split("/", 1)[0]
        zip_f.extractall(temp_dir)

    plugin_temp_path = path.join(temp_dir, archive_root)

    # Remove the current plugin and replace it with the extracted
    plugin_dest_path = path.join(source_dir, plugin_name)

    try:
        shutil.rmtree(plugin_dest_path)
    except OSError:
        pass

    shutil.move(plugin_temp_path, plugin_dest_path)
    print("Updated {0}".format(plugin_name))


def update(name, github_url, temp_directory):
    zip_path = GITHUB_ZIP % github_url
    try:
        download_extract_replace(name, zip_path, temp_directory, SOURCE_DIR)
        return True
    except Exception as exp:
        print("Could not update {}. Error was: {}".format(name, str(exp)))
        return False


def generate_help_tags(plugin_names):
    """Generate Vim help tags for updated plugins that ship documentation."""
    vim = shutil.which("vim")
    if not vim:
        print("Could not generate help tags: vim was not found")
        return False

    success = True
    for name in plugin_names:
        doc_dir = path.join(SOURCE_DIR, name, "doc")
        if not path.isdir(doc_dir):
            continue
        if not any(filename.endswith(".txt") for filename in os.listdir(doc_dir)):
            continue

        env = os.environ.copy()
        env["VIM_PLUGIN_DOC_DIR"] = doc_dir
        result = subprocess.run(
            [
                vim,
                "-Nu",
                "NONE",
                "-n",
                "-es",
                "-c",
                "execute 'helptags ' . fnameescape($VIM_PLUGIN_DOC_DIR)",
                "-c",
                "qa!",
            ],
            env=env,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
            text=True,
            check=False,
        )
        if result.returncode:
            print("Could not generate help tags for {}".format(name))
            success = False

    return success


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Update all bundled plugins, or only the named plugins."
    )
    parser.add_argument("plugins", nargs="*", metavar="PLUGIN")
    args = parser.parse_args()

    selected = args.plugins or list(PLUGIN_URLS)
    unknown = sorted(set(selected) - set(PLUGIN_URLS))
    if unknown:
        parser.error("unknown plugin(s): {}".format(", ".join(unknown)))

    temp_directory = tempfile.mkdtemp()

    try:
        results = [update(name, PLUGIN_URLS[name], temp_directory) for name in selected]
    finally:
        shutil.rmtree(temp_directory)

    updated = [name for name, result in zip(selected, results) if result]
    tags_ok = generate_help_tags(updated)
    raise SystemExit(0 if all(results) and tags_ok else 1)
