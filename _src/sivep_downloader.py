from datetime import datetime
from lxml import html
import requests
import re

address = "http://plataforma.saude.gov.br/coronavirus/dados-abertos/"
dest = "../dados/SIVEP-Gripe/SRAGHospitalizado_{data}.csv"

page = requests.get(address)
tree = html.fromstring(page.content)

../dados/SIVEP-Gripe/SRAGHospitalizado_2020_05_04.csv
l = tree.xpath('//a[starts-with(text(), "Banco de dados de 2020")]')[0]
url = address + l.attrib['href']
g = re.match(r'.* (\d+/\d+/\d+).*', l.text_content())
data = g.groups()[0]
data = datetime.strptime(data, "%d/%m/%Y").strftime("%Y_%m_%d")

r = requests.get(url, allow_redirects=True)
open(dest.format(data=data), 'wb').write(r.content)
