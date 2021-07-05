import shutil
import requests
from dynaconf import Dynaconf
from pathlib import Path
from zipfile import ZipFile
from tqdm import tqdm
import subprocess
from hashlib import sha256

config = Dynaconf(settings_files=["settings.yml"])

job_id = (
        requests.get(f"{config.api_url}/projects/{config.slug}")
                    .json()["build"]["jobs"][0]["jobId"]
    )
job_artifacts = requests.get(f"{config.api_url}/buildjobs/{job_id}/artifacts").json()
job_artifacts = [a for a in job_artifacts if a["type"] == "Zip"]

dl_dir = Path("dl")
if not dl_dir.exists():
    dl_dir.mkdir()

for n, artifact in enumerate(job_artifacts):
    fn = artifact["fileName"]
    fpath = Path(f"dl/{fn}")
    if not fn.startswith("openssl") or not "win64" in fn:
        continue
    if not fpath.exists():
        print(
            f"Download {fn} {n} of {len(job_artifacts)} with size {artifact['size'] // 1024} KiB"
        )
        fc = requests.get(
            f"{config.api_url}/buildjobs/{job_id}/artifacts/{fn}", stream=True
        )
        size = fc.headers["content-length"]
        pbar = tqdm(
            unit="KiB", total=int(size) // 1024, unit_scale=1024, unit_divisor=1024
        )
        with open(fpath, "wb") as fd:
            for chunk in fc.iter_content(chunk_size=1024):
                if chunk:
                    pbar.update(len(chunk) // 1024)
                    fd.write(chunk)
        pbar.close()
    else:
        print(f"using existing file {fpath.absolute()}")

    epath = Path(f"sources")
    try:
        epath.mkdir()
    except FileExistsError:
        shutil.rmtree(epath)
        epath.mkdir()
    zf = ZipFile(fpath)
    zf.extractall(epath)
    final_path = list(epath.glob("*"))[0]
    try:
        final_path.rename("openssl")
    except FileExistsError:
        shutil.rmtree("openssl")
        final_path.rename("openssl")
    shutil.rmtree(epath)

print("make the installer")
nsi_path = Path("installer.nsi")
out = subprocess.run([config.nsis_make_path, nsi_path.absolute()], shell=True, check=True, capture_output=True)
print(out.stdout.decode())
installer = Path("openssl-setup.exe").absolute()
hash = sha256()
with open(installer, "rb") as fd:
    hash.update(fd.read())

with open(f"{installer.stem}.sha256", "w") as fd:
    fd.write(f"{installer.stem}{installer.suffix} {hash.hexdigest()}")
