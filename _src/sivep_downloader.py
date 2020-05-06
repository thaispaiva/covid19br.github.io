import os, sys, shutil
from glob import glob
from datetime import datetime
from lxml import html
import requests
import re

address = "http://plataforma.saude.gov.br/coronavirus/dados-abertos/"
dest = "../dados/SIVEP-Gripe/SRAGHospitalizado_{data}.csv"

page = requests.get(address)
tree = html.fromstring(page.content)

l = tree.xpath('//a[starts-with(text(), "Banco de dados de 2020")]')[0]
url = address + l.attrib['href']
g = re.match(r'.* (\d+/\d+/\d+).*', l.text_content())
data = g.groups()[0]
data = datetime.strptime(data, "%d/%m/%Y").strftime("%Y_%m_%d")

r = requests.get(url, allow_redirects=True)

if url[-3:] == 'zip':
    open("sivep_tmp.zip", 'wb').write(r.content)
    import zipfile
    os.mkdir("sivep_tmp_files")
    with zipfile.ZipFile("sivep_tmp.zip", "r") as zip_ref:
        zip_ref.extractall("sivep_tmp_files")
    fname = glob("sivep_tmp_files/*.csv")[0]
    shutil.move(fname, dest.format(data=data))
    shutil.rmtree("sivep_tmp_files/")
    os.remove("sivep_tmp.zip")
elif url[-3:] == 'csv':
    open(dest.format(data=data), 'wb').write(r.content)
else:
    print("Formato desconhecido")
    sys.exit(1)

